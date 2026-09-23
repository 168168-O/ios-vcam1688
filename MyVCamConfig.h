#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString * const MyVCamPreferencesDomain;
FOUNDATION_EXPORT NSString * const MyVCamEnabledKey;
FOUNDATION_EXPORT NSString * const MyVCamStreamURLKey;
FOUNDATION_EXPORT NSString * const MyVCamAllowedBundleIDsKey;
FOUNDATION_EXPORT NSString * const MyVCamFallbackKey;

BOOL MyVCamIsEnabledForCurrentBundle(void);
BOOL MyVCamIsBundleAllowed(NSString *bundleIdentifier);
NSURL * _Nullable MyVCamConfiguredURL(void);
BOOL MyVCamShouldFallback(void);

NS_ASSUME_NONNULL_END
