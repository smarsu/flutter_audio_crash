#import "FlutterAudioCrashPlugin.h"
#if __has_include(<flutter_audio_crash/flutter_audio_crash-Swift.h>)
#import <flutter_audio_crash/flutter_audio_crash-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_audio_crash-Swift.h"
#endif

@implementation FlutterAudioCrashPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAudioCrashPlugin registerWithRegistrar:registrar];
}
@end
