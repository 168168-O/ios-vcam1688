#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyVCamFrameSource <NSObject>

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) BOOL isRunning;

- (BOOL)startWithError:(NSError * _Nullable * _Nullable)error;
- (void)stop;
- (BOOL)nextPixelBuffer:(CVPixelBufferRef _Nullable * _Nullable)pixelBuffer
                   pts:(CMTime *)pts
                  error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
