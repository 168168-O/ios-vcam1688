#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyVCamFramePipeline : NSObject

@property (nonatomic, assign) NSInteger targetFPS;
@property (nonatomic, assign) BOOL mirror;
@property (nonatomic, assign) BOOL enableAdaptiveScale;

- (instancetype)initWithTargetFPS:(NSInteger)fps;

- (BOOL)preparePixelBuffer:(CVPixelBufferRef)inputBuffer
               outputBuffer:(CVPixelBufferRef)outputBuffer
                      pts:(CMTime)pts
                     error:(NSError * _Nullable * _Nullable)error;

- (BOOL)makeSampleBufferFromPixelBuffer:(CVPixelBufferRef)pixelBuffer
                                    pts:(CMTime)pts
                                  output:(CMSampleBufferRef _Nullable * _Nullable)sampleBuffer
                                   error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
