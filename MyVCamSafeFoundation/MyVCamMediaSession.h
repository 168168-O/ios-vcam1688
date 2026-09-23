#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "MyVCamAudioMode.h"
#import "MyVCamFrameSource.h"
#import "MyVCamFramePipeline.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyVCamMediaSession : NSObject

@property (nonatomic, strong, nullable) id<MyVCamFrameSource> frameSource;
@property (nonatomic, strong, nullable) MyVCamFramePipeline *framePipeline;
@property (nonatomic, assign) MyVCamAudioMode audioMode;
@property (nonatomic, assign) NSInteger targetFPS;
@property (nonatomic, assign) BOOL isRunning;

- (instancetype)initWithFrameSource:(id<MyVCamFrameSource>)source
                       framePipeline:(MyVCamFramePipeline *)pipeline;

- (BOOL)startWithError:(NSError * _Nullable * _Nullable)error;
- (void)stop;

- (BOOL)nextFrame:(CVPixelBufferRef _Nullable * _Nullable)pixelBuffer
              pts:(CMTime *)pts
            error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
