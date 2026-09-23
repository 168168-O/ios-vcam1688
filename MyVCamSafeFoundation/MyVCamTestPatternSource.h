#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

#import "MyVCamFrameSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyVCamTestPatternSource : NSObject <MyVCamFrameSource>

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) BOOL isRunning;

- (instancetype)initWithWidth:(size_t)width height:(size_t)height fps:(NSInteger)fps;

@end

NS_ASSUME_NONNULL_END
