//
//  AppDelegate.m
//  PushDemo
//
//  Created by aBerning on 2021/2/28.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self push];
    return YES;
}

- (void)push
{
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            NSLog(@"%@", error);

        }];
        
        UNNotificationCategory* generalCategory = [UNNotificationCategory
                                                   categoryWithIdentifier:@"GENERAL"
                                                   actions:@[]
                                                   intentIdentifiers:@[]
                                                   options:UNNotificationCategoryOptionCustomDismissAction];
        
        // Create the custom actions for expired timer notifications.
        UNNotificationAction* snoozeAction = [UNNotificationAction
                                              actionWithIdentifier:@"SNOOZE_ACTION"
                                              title:@"Snooze"
                                              options:UNNotificationActionOptionAuthenticationRequired];
        
        UNNotificationAction* stopAction = [UNNotificationAction
                                            actionWithIdentifier:@"STOP_ACTION"
                                            title:@"Stop"
                                            options:UNNotificationActionOptionDestructive];
        UNNotificationAction* forAction = [UNNotificationAction
                                            actionWithIdentifier:@"FOR_ACTION"
                                            title:@"forAction"
                                            options:UNNotificationActionOptionForeground];
        
        // Create the category with the custom actions.
        UNNotificationCategory* expiredCategory = [UNNotificationCategory
                                                   categoryWithIdentifier:@"TIMER_EXPIRED"
                                                   actions:@[snoozeAction, stopAction,forAction]
                                                   intentIdentifiers:@[]
                                                   options:UNNotificationCategoryOptionNone];
        
        // Register the notification categories.
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        [center setDelegate:self];
        [center setNotificationCategories:[NSSet setWithObjects:generalCategory, expiredCategory,
                                           nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else {
//        if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
//            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];

//        }
//        else {//(iOS version < iOS8)
//            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
//        }
    }

}




#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


#pragma mark - User NotificationCenter Delegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    NSLog(@"will present : %s", __func__);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler{
    
    NSLog(@"did receive : %s", __func__);
    NSLog(@"notification = %@",response.notification.request.content);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    

    NSString *toke = [self getHexStringForData:deviceToken];
    NSLog(@"regisger success : %@",toke);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"regisger failed : %@",error.localizedDescription);
}


- (NSString *)getHexStringForData:(NSData *)data
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 13) {
        
        if (![data isKindOfClass:[NSData class]]) {
            return @"";
        }
        NSUInteger len = [data length];
        char *chars = (char *)[data bytes];
        NSMutableString *hexString = [[NSMutableString alloc]init];
        for (NSUInteger i=0; i<len; i++) {
            [hexString appendString:[NSString stringWithFormat:@"%0.2hhx" , chars[i]]];
        }
        return hexString;
    } else {
         NSString *token = [[data description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
        return token;
    }
}


@end
