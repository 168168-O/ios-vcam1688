#import "MyVCamLocalFileSource.h"

@interface MyVCamLocalFileSource () {
    AVAssetReader *_reader;
    AVAssetReaderTrackOutput *_videoOutput;
    AVURLAsset *_asset;
    BOOL _isRunning;
    CMTime _lastPTS;
}
@end

@implementation MyVCamLocalFileSource

- (instancetype)initWithURL:(NSURL *)URL {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    _identifier = URL.lastPathComponent ?: @"local-file";
    _asset = [[AVURLAsset alloc] initWithURL:URL options:nil];
    _isRunning = NO;
    _lastPTS = kCMTimeZero;
    return self;
}

- (BOOL)startWithError:(NSError * _Nullable * _Nullable)error {
    if (_asset == nil) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:5 userInfo:@{NSLocalizedDescriptionKey: @"Asset is invalid."}];
        }
        return NO;
    }

    NSError *readerError = nil;
    _reader = [[AVAssetReader alloc] initWithAsset:_asset error:&readerError];
    if (_reader == nil) {
        if (error) {
            *error = readerError;
        }
        return NO;
    }

    AVAssetTrack *videoTrack = [[_asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    if (videoTrack == nil) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:6 userInfo:@{NSLocalizedDescriptionKey: @"No video track found."}];
        }
        return NO;
    }

    NSDictionary *settings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    _videoOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:settings];
    _videoOutput.alwaysCopiesSampleData = NO;

    if (![_reader canAddOutput:_videoOutput]) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:7 userInfo:@{NSLocalizedDescriptionKey: @"Cannot add video output."}];
        }
        return NO;
    }

    [_reader addOutput:_videoOutput];
    [_reader startReading];
    _isRunning = YES;
    return YES;
}

- (void)stop {
    if (_reader != nil) {
        [_reader cancelReading];
        _reader = nil;
    }
    _videoOutput = nil;
    _isRunning = NO;
}

- (BOOL)nextPixelBuffer:(CVPixelBufferRef _Nullable * _Nullable)pixelBuffer
                   pts:(CMTime *)pts
                  error:(NSError * _Nullable * _Nullable)error {
    if (!_isRunning || _reader == nil || _videoOutput == nil) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:8 userInfo:@{NSLocalizedDescriptionKey: @"Reader is not active."}];
        }
        return NO;
    }

    CMSampleBufferRef sampleBuffer = [_videoOutput copyNextSampleBuffer];
    if (sampleBuffer == NULL) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:9 userInfo:@{NSLocalizedDescriptionKey: @"No more sample buffers."}];
        }
        return NO;
    }

    CVPixelBufferRef outBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (outBuffer != NULL) {
        CVPixelBufferRetain(outBuffer);
    }

    if (pts != NULL) {
        *pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
        _lastPTS = *pts;
    }

    if (pixelBuffer != NULL) {
        *pixelBuffer = outBuffer;
    }

    CFRelease(sampleBuffer);
    return YES;
}

@end
