#import "MyVCamTestPatternSource.h"

@interface MyVCamTestPatternSource () {
    size_t _width;
    size_t _height;
    NSInteger _fps;
    NSUInteger _frameIndex;
    BOOL _isRunning;
}
@end

@implementation MyVCamTestPatternSource

- (instancetype)initWithWidth:(size_t)width height:(size_t)height fps:(NSInteger)fps {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    _width = width > 0 ? width : 1280;
    _height = height > 0 ? height : 720;
    _fps = MAX(1, fps);
    _frameIndex = 0;
    _isRunning = NO;
    _identifier = [NSString stringWithFormat:@"test-pattern-%zu-%zu", _width, _height];
    return self;
}

- (BOOL)startWithError:(NSError * _Nullable * _Nullable)error {
    _isRunning = YES;
    _frameIndex = 0;
    return YES;
}

- (void)stop {
    _isRunning = NO;
}

- (BOOL)nextPixelBuffer:(CVPixelBufferRef _Nullable * _Nullable)pixelBuffer
                   pts:(CMTime *)pts
                  error:(NSError * _Nullable * _Nullable)error {
    if (!_isRunning) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:30 userInfo:@{NSLocalizedDescriptionKey: @"Test pattern source is stopped."}];
        }
        return NO;
    }

    OSType pixelFormat = kCVPixelFormatType_32BGRA;
    NSDictionary *attrs = @{
        (NSString *)kCVPixelBufferIOSurfacePropertiesKey: @{},
        (NSString *)kCVPixelBufferPixelFormatTypeKey: @(pixelFormat)
    };

    CVPixelBufferRef generated = NULL;
    CVReturn ret = CVPixelBufferCreate(
        kCFAllocatorDefault,
        _width,
        _height,
        pixelFormat,
        (__bridge CFDictionaryRef)attrs,
        &generated);

    if (ret != kCVReturnSuccess || generated == NULL) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:31 userInfo:@{NSLocalizedDescriptionKey: @"Failed to create test pattern buffer."}];
        }
        return NO;
    }

    CVPixelBufferLockBaseAddress(generated, 0);
    uint8_t *base = (uint8_t *)CVPixelBufferGetBaseAddress(generated);
    size_t stride = CVPixelBufferGetBytesPerRow(generated);
    size_t bytes = stride * _height;
    memset(base, 0, bytes);

    for (size_t y = 0; y < _height; ++y) {
        for (size_t x = 0; x < _width; ++x) {
            size_t i = (y * stride) + (x * 4);
            uint8_t r = (uint8_t)((x * 255) / _width);
            uint8_t g = (uint8_t)((y * 255) / _height);
            uint8_t b = (uint8_t)(((_frameIndex * 10) + x + y) % 255);
            uint8_t a = 255;

            if (((x / 32) + (y / 32) + (_frameIndex % 8)) % 2 == 0) {
                r = 255 - r;
                g = 255 - g;
                b = 255 - b;
            }

            base[i + 0] = b;
            base[i + 1] = g;
            base[i + 2] = r;
            base[i + 3] = a;
        }
    }

    CVPixelBufferUnlockBaseAddress(generated, 0);

    if (pts != NULL) {
        *pts = CMTimeMake((int64_t)_frameIndex, (int32_t)_fps);
    }

    if (pixelBuffer != NULL) {
        *pixelBuffer = generated;
    }

    _frameIndex += 1;
    return YES;
}

@end
