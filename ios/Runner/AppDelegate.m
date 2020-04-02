#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "XXShieldSDK.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [XXShieldSDK registerStabilitySDK];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

//云信推送生命周期
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSDictionary *userInfo = @{@"didRegisterForRemoteNotificationsWithDeviceToken":deviceToken};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XiaobaimPlugin" object:nil userInfo:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@",error);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSDictionary *userInfo = @{@"applicationDidEnterBackground":application};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XiaobaimPlugin" object:nil userInfo:userInfo];
}

@end
