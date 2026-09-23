#import <Foundation/Foundation.h>

#import "MyVCamAudioMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyVCamAudioMixer : NSObject

@property (nonatomic, assign, readonly) MyVCamAudioMode mode;

- (instancetype)initWithMode:(MyVCamAudioMode)mode;
- (BOOL)configureMode:(MyVCamAudioMode)mode error:(NSError * _Nullable * _Nullable)error;
- (BOOL)mixSamples:(const float *)inputSamples
            count:(size_t)count
           output:(float *)outputSamples
            error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
