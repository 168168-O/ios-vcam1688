#import "MyVCamMediaSession.h"

@interface MyVCamMediaSession ()
@property (nonatomic, assign) BOOL didStart;
@end

@implementation MyVCamMediaSession

- (instancetype)initWithFrameSource:(id<MyVCamFrameSource>)source
                       framePipeline:(MyVCamFramePipeline *)pipeline {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    _frameSource = source;
    _framePipeline = pipeline ?: [[MyVCamFramePipeline alloc] initWithTargetFPS:30];
    _targetFPS = 30;
    _audioMode = MyVCamAudioModeMicrophone;
    _isRunning = NO;
    _didStart = NO;
    return self;
}

- (BOOL)startWithError:(NSError * _Nullable * _Nullable)error {
    if (self.frameSource == nil) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:1 userInfo:@{NSLocalizedDescriptionKey: @"Missing frame source."}];
        }
        return NO;
    }

    BOOL started = [self.frameSource startWithError:error];
    if (!started) {
        return NO;
    }

    self.isRunning = YES;
    self.didStart = YES;
    return YES;
}

- (void)stop {
    if (self.frameSource != nil) {
        [self.frameSource stop];
    }
    self.isRunning = NO;
}

- (BOOL)nextFrame:(CVPixelBufferRef _Nullable * _Nullable)pixelBuffer
              pts:(CMTime *)pts
            error:(NSError * _Nullable * _Nullable)error {
    if (!self.isRunning || self.frameSource == nil) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:2 userInfo:@{NSLocalizedDescriptionKey: @"Session is not running."}];
        }
        return NO;
    }

    CVPixelBufferRef nextFrame = NULL;
    CMTime framePTS = kCMTimeInvalid;
    BOOL ok = [self.frameSource nextPixelBuffer:&nextFrame pts:&framePTS error:error];
    if (!ok) {
        return NO;
    }

    if (pts != NULL) {
        *pts = framePTS;
    }

    if (pixelBuffer != NULL) {
        *pixelBuffer = nextFrame;
    }

    return YES;
}

@end
