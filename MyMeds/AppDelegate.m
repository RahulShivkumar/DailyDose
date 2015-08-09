//
//  AppDelegate.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "AppDelegate.h"
#import "TodayViewController.h"
#import "OverviewViewController.h"
#import "AnalyzeViewController.h"
#import "SettingsViewController.h"
#import "LTHPasscodeViewController.h"
#import "Amplitude.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#define ROOTVIEW [[[UIApplication sharedApplication] keyWindow] rootViewController]


@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Testing interactive Notifications Code
    NSString *UUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"UUID"];
    
    if (!UUID){
        // If the app is deleted, we want to remove exisiting local notifications when a user re downloads
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[Amplitude instance] initializeApiKey:@"6173840dbe787b3041206d97de06b633" userId:[self getUserID]];
        //NSLog(@"%@", [self getUserID]);
    } else {
        [[Amplitude instance] initializeApiKey:@"6173840dbe787b3041206d97de06b633" userId:UUID];
        //NSLog(@"%@", UUID);
    }
//
    [Fabric with:@[CrashlyticsKit]];

    [DBAccess setDelegate:self];
    [DBAccess openDatabaseNamed:@"dailydose"];

    //Ask for notifications permission
    //This has been moved...
    /*if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
                                                                                                              categories:nil]];
    }*/
    
    //If passcode is enabled, show lock screen
    if ([LTHPasscodeViewController doesPasscodeExist] &&
        [LTHPasscodeViewController didPasscodeTimerEnd]) {
        LTHPasscodeViewController *pvc = [LTHPasscodeViewController sharedUser];
        [self.window addSubview:pvc.view];
        [self.window makeKeyAndVisible];
        [pvc showLockScreenWithAnimation:YES withLogout:NO andLogoutTitle:nil];
    }
    

    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSString*)getUserID {
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
    CFRelease(uuidObject);
    
    [[NSUserDefaults standardUserDefaults] setObject:uuidStr forKey:@"UUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return uuidStr;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    
    NSString *notifID = [notification.userInfo objectForKey:@"uid"];
    float time = [[notifID componentsSeparatedByString: @"-"][1] floatValue];
    if ([identifier isEqualToString:@"taken"]) {
        DBResultSet *tms = [[[TodayMedication query] whereWithFormat:@"time = %f", time] fetch];
        for (TodayMedication *tm in tms) {
            tm.taken = YES;
            [tm commit];
            [EventLogger logAction:@"taken" andMedication:tm.coreMed andTime:time];
        }
    }
    else if ([identifier isEqualToString:@"delayed"]) {
        DBResultSet *tms = [[[TodayMedication query] whereWithFormat:@"time = %f", time] fetch];
        for (TodayMedication *tm in tms) {
            int hour = (int)[Constants getCurrentHour];
            if (hour + 2 < 24) {
                tm.time = hour + 2;
                [tm commit];
                [EventLogger logAction:@"delayed" andMedication:tm.coreMed andTime:time];
            } else {
                // Log as missed or just ignore for now?
            }
            
        }
        
       
    }
    if (completionHandler) {
        
        completionHandler();
    }
}



@end
