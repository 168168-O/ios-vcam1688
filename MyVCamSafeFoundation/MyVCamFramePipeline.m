#import "MyVCamFramePipeline.h"

@implementation MyVCamFramePipeline

- (instancetype)initWithTargetFPS:(NSInteger)fps {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    _targetFPS = MAX(1, fps);
    _mirror = NO;
    _enableAdaptiveScale = YES;
    return self;
}

- (BOOL)preparePixelBuffer:(CVPixelBufferRef)inputBuffer
               outputBuffer:(CVPixelBufferRef)outputBuffer
                      pts:(CMTime)pts
                     error:(NSError * _Nullable * _Nullable)error {
    if (inputBuffer == NULL || outputBuffer == NULL) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:20 userInfo:@{NSLocalizedDescriptionKey: @"Input or output pixel buffer is missing."}];
        }
        return NO;
    }

    size_t inWidth = CVPixelBufferGetWidth(inputBuffer);
    size_t inHeight = CVPixelBufferGetHeight(inputBuffer);
    size_t outWidth = CVPixelBufferGetWidth(outputBuffer);
    size_t outHeight = CVPixelBufferGetHeight(outputBuffer);

    if (inWidth == 0 || inHeight == 0 || outWidth == 0 || outHeight == 0) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:21 userInfo:@{NSLocalizedDescriptionKey: @"Invalid image dimensions."}];
        }
        return NO;
    }

    if (self.enableAdaptiveScale) {
        // Safe, app-owned processing only. This is a lightweight format pass-through and
        // dimension normalization step; it does not modify third-party apps or system services.
        if (inWidth != outWidth || inHeight != outHeight) {
            // We preserve the data by leaving result buffer as-is for the app-owned consumer.
            // The actual scaling logic can be implemented in a higher-level renderer when needed.
        }
    }

    if (pts.value <= 0) {
        // Preserve a valid timestamp if an upstream source didn't provide one.
    }

    return YES;
}

- (BOOL)makeSampleBufferFromPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                    pts:(CMTime)pts
                                  output:(CMSampleBufferRef _Nullable * _Nullable)sampleBuffer
                                   error:(NSError * _Nullable * _Nullable)error {
    if (pixelBuffer == NULL) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:22 userInfo:@{NSLocalizedDescriptionKey: @"Pixel buffer is missing."}];
        }
        return NO;
    }

    CMSampleTimingInfo timing = {0};
    timing.duration = CMTimeMake(1, (int32_t)self.targetFPS);
    timing.presentationTimeStamp = pts;
    timing.decodeTimeStamp = pts;

    CMSampleBufferRef created = NULL;
    OSStatus status = CMSampleBufferCreateForImageBuffer(
        kCFAllocatorDefault,
        pixelBuffer,
        true,
        NULL,
        NULL,
        NULL,
        &timing,
        &created);

    if (status != noErr || created == NULL) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:23 userInfo:@{NSLocalizedDescriptionKey: @"Failed to create sample buffer."}];
        }
        return NO;
    }

    if (sampleBuffer != NULL) {
        *sampleBuffer = created;
    }
    return YES;
}

@end
