#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import "MyVCamConfig.h"

#ifdef DEBUG_MODE
#define MyVCamLog(fmt, ...) NSLog((@"[MyVCam] " fmt), ##__VA_ARGS__)
#else
#define MyVCamLog(...)
#endif

// This baseline deliberately limits itself to AVFoundation and an explicit
// allow-list. It does not alter system-wide APIs or inspect/hide security state.
%hook AVCaptureVideoDataOutput

- (void)setSampleBufferDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)delegate
                           queue:(dispatch_queue_t)queue {
    if (!MyVCamIsEnabledForCurrentBundle()) {
        %orig(delegate, queue);
        return;
    }

    MyVCamLog(@"Enabled for %@; preserving the app's capture delegate", NSBundle.mainBundle.bundleIdentifier);
    // Preserve the application's delegate and queue until a validated frame
    // provider is attached. This makes failures fall back to the original path.
    %orig(delegate, queue);
}

%end

%ctor {
    @autoreleasepool {
        if (MyVCamIsEnabledForCurrentBundle()) {
            MyVCamLog(@"Allow-listed capture path active for %@", NSBundle.mainBundle.bundleIdentifier);
        }
    }
}
