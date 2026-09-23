#import "MyVCamConfig.h"

NSString * const MyVCamPreferencesDomain = @"com.murkaska.virtualcampro";
NSString * const MyVCamEnabledKey = @"enabled";
NSString * const MyVCamStreamURLKey = @"streamURL";
NSString * const MyVCamAllowedBundleIDsKey = @"allowedBundleIDs";
NSString * const MyVCamFallbackKey = @"fallbackToOriginal";

static NSDictionary *MyVCamPreferences(void) {
    NSDictionary *preferences = [[NSUserDefaults standardUserDefaults] persistentDomainForName:MyVCamPreferencesDomain];
    return [preferences isKindOfClass:[NSDictionary class]] ? preferences : @{};
}

BOOL MyVCamIsBundleAllowed(NSString *bundleIdentifier) {
    if (bundleIdentifier.length == 0) return NO;
    NSArray *allowed = MyVCamPreferences()[MyVCamAllowedBundleIDsKey];
    if (![allowed isKindOfClass:[NSArray class]]) return NO;
    for (id value in allowed) {
        if ([value isKindOfClass:[NSString class]] && [value isEqualToString:bundleIdentifier]) return YES;
    }
    return NO;
}

BOOL MyVCamIsEnabledForCurrentBundle(void) {
    NSDictionary *preferences = MyVCamPreferences();
    if (![preferences[MyVCamEnabledKey] boolValue]) return NO;
    return MyVCamIsBundleAllowed(NSBundle.mainBundle.bundleIdentifier ?: @"");
}

NSURL *MyVCamConfiguredURL(void) {
    NSString *value = MyVCamPreferences()[MyVCamStreamURLKey];
    if (![value isKindOfClass:[NSString class]] || value.length == 0) return nil;
    NSURL *url = [NSURL URLWithString:value];
    return (url.scheme.length > 0 && url.host.length > 0) ? url : nil;
}

BOOL MyVCamShouldFallback(void) {
    id value = MyVCamPreferences()[MyVCamFallbackKey];
    return value == nil ? YES : [value boolValue];
}
