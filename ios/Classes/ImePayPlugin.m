#import "ImePayPlugin.h"
#if __has_include(<ime_pay/ime_pay-Swift.h>)
#import <ime_pay/ime_pay-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ime_pay-Swift.h"
#endif

@implementation ImePayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftImePayPlugin registerWithRegistrar:registrar];
}
@end
