#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>

#import "MyVCamFrameSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyVCamLocalFileSource : NSObject <MyVCamFrameSource>

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) BOOL isRunning;

- (instancetype)initWithURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
