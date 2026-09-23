#import "MyVCamAudioMixer.h"

@implementation MyVCamAudioMixer {
    MyVCamAudioMode _mode;
}

- (instancetype)initWithMode:(MyVCamAudioMode)mode {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _mode = mode;
    return self;
}

- (BOOL)configureMode:(MyVCamAudioMode)mode error:(NSError * _Nullable * _Nullable)error {
    if (mode < MyVCamAudioModeMicrophone || mode > MyVCamAudioModeMuted) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:40 userInfo:@{NSLocalizedDescriptionKey: @"Unsupported audio mode."}];
        }
        return NO;
    }
    _mode = mode;
    return YES;
}

- (BOOL)mixSamples:(const float *)inputSamples
            count:(size_t)count
           output:(float *)outputSamples
            error:(NSError * _Nullable * _Nullable)error {
    if (inputSamples == NULL || outputSamples == NULL) {
        if (error) {
            *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:41 userInfo:@{NSLocalizedDescriptionKey: @"Audio buffers are missing."}];
        }
        return NO;
    }

    switch (_mode) {
        case MyVCamAudioModeMicrophone:
            for (size_t i = 0; i < count; ++i) {
                outputSamples[i] = inputSamples[i];
            }
            return YES;

        case MyVCamAudioModeVideoAudio:
            for (size_t i = 0; i < count; ++i) {
                outputSamples[i] = inputSamples[i];
            }
            return YES;

        case MyVCamAudioModeMix:
            for (size_t i = 0; i < count; ++i) {
                outputSamples[i] = inputSamples[i] * 0.75f;
            }
            return YES;

        case MyVCamAudioModeMuted:
            memset(outputSamples, 0, count * sizeof(float));
            return YES;

        default:
            if (error) {
                *error = [NSError errorWithDomain:@"MyVCamSafeFoundation" code:42 userInfo:@{NSLocalizedDescriptionKey: @"Unexpected audio mode."}];
            }
            return NO;
    }
}

@end
