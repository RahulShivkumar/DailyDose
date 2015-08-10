//
//  NotificationScheduler.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 7/5/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "NotificationScheduler.h"

#define kUID @"uid"
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@implementation NotificationScheduler

#pragma mark - Add Local Notification
+ (void)setupLocalNotifsWithDictionary:(NSMutableDictionary*)days andTimes:(NSMutableArray*)times {
    //Run in a separate thread so it doesn't block up the UI
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *daysOfWeek = [[NSArray alloc] initWithObjects:@"sunday", @"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", nil];
    
        for (int j = 0; j < [times count]; j++){
            
            for (NSString *day in daysOfWeek){
                
                if([[days objectForKey:day] intValue] == 1){
                    BOOL flag = NO;
                    UIApplication *app = [UIApplication sharedApplication];
                    NSArray *eventArray = [app scheduledLocalNotifications];
                    
                    for (int i = 0; i < [eventArray count]; i++)
                    {
                        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
                        NSDictionary *userInfoCurrent = oneEvent.userInfo;
                        NSString *identifier = [userInfoCurrent objectForKey:kUID];
                        NSString *prefix = [day stringByAppendingString:[@"-" stringByAppendingString:[NSString stringWithFormat:@"%@",[times objectAtIndex:j]]]];
                        
                        if ([identifier hasPrefix:prefix])
                        {
                            flag = YES;
                            [app cancelLocalNotification:oneEvent];
                            int number = [[identifier substringFromIndex:[prefix length] + 1] intValue];
                            
                            number += 1;
                            [self initLocalNotif:number andDay:day
                                         andTime:[NSString stringWithFormat:@"%@",[times objectAtIndex:j]]
                                     andDayIndex:(int)[daysOfWeek indexOfObject:day] + 1];
                            
                            break;
                        }
                    }
                    if (!flag){
                        int number = 1;
                        [self initLocalNotif:number andDay:day
                                     andTime:[NSString stringWithFormat:@"%@", [times objectAtIndex:j]]
                                 andDayIndex:(int)[daysOfWeek indexOfObject:day] + 1];
                        
                    }
                    
                }
            }
        }
//    });
}


//Method called to create the local notifications
+ (void)initLocalNotif:(int)number andDay:(NSString *)day andTime:(NSString*)timeString andDayIndex:(int)dayIndex {

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    
    NSDateComponents *componentsForFireDate = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
    [componentsForFireDate setTimeZone:[NSTimeZone localTimeZone]];
    [componentsForFireDate setWeekday: dayIndex];
    
    float timeFloat = [timeString floatValue];
    int minute = 0;
    if (timeFloat != (int)timeFloat){
        timeFloat = (int)timeFloat;
        minute = 30;
    }
    [componentsForFireDate setHour:timeFloat];
    [componentsForFireDate setMinute:minute];
    [componentsForFireDate setSecond:0];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    notification.fireDate = [calendar dateFromComponents:componentsForFireDate];
    notification.repeatInterval = NSCalendarUnitWeekOfYear;
    
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterSpellOutStyle];
    NSString *s = [f stringFromNumber:[NSNumber numberWithInt:number]];
    NSString *alertBody;
    
    if (number == 1) {
        alertBody = [s stringByAppendingString:@" med!"];
    } else {
        alertBody = [s stringByAppendingString:@" meds!"];
    }
    
    //Set the title of the notification
    notification.alertBody = [@"Time to take " stringByAppendingString:alertBody];
    
    // Check if its iOS 8 for Mutable Notifications
    if IS_OS_8_OR_LATER {
        [self registerMutableNotifications];
        notification.category = @"action_notifs";
    }
    
    NSString *key = [timeString stringByAppendingString:[@"-" stringByAppendingString:[NSString stringWithFormat:@"%d", number]]];
    day = [day stringByAppendingString:@"-"];
    key = [day stringByAppendingString:key];
    //NSLog(@"%@", key);
    
    [notification setUserInfo:[NSDictionary dictionaryWithObject:key forKey:kUID]];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


# pragma mark - Remove Local Notification
+ (void)removeLocalNotificationWithCoreMedication:(CoreMedication*)cm AndTimes:(NSMutableArray*)times{
    //Run in a separate thread so it doesn't block up the UI
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        Medication *med = [[[[[Medication query] whereWithFormat:@"coreMed = %@", cm] limit:1] fetch] objectAtIndex:0];
        
        NSArray *daysOfWeek = [[NSArray alloc] initWithObjects:@"sunday", @"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", nil];
        
        NSArray *daysValues = [[NSArray alloc] initWithObjects:[NSNumber numberWithBool:med.sunday], [NSNumber numberWithBool:med.monday], [NSNumber numberWithBool:med.tuesday], [NSNumber numberWithBool:med.wednesday], [NSNumber numberWithBool:med.thursday], [NSNumber numberWithBool:med.friday], [NSNumber numberWithBool:med.saturday], nil];
                
        for (int j = 0; j < [times count]; j++){
            
            for (int i = 0; i < [daysOfWeek count]; i++){
                
                if((BOOL)[daysValues objectAtIndex:i]){
                    
                    NSString *day = [daysOfWeek objectAtIndex:i];
                    
                    UIApplication *app = [UIApplication sharedApplication];
                    NSArray *eventArray = [app scheduledLocalNotifications];
                    
                    for (int i = 0; i < [eventArray count]; i++)
                    {
                        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
                        NSDictionary *userInfoCurrent = oneEvent.userInfo;
                        NSString *identifier = [userInfoCurrent objectForKey:kUID];
                        NSString *prefix = [day stringByAppendingString:[@"-" stringByAppendingString:[NSString stringWithFormat:@"%@",[times objectAtIndex:j]]]];
                        
                        if ([identifier hasPrefix:prefix])
                        {
                            [app cancelLocalNotification:oneEvent];
                            int number = [[identifier substringFromIndex:[prefix length] + 1] intValue];
                            
                            [self removeNotif:number andDay:day
                                         andTime:[NSString stringWithFormat:@"%@",[times objectAtIndex:j]]
                                     andDayIndex:(int)[daysOfWeek indexOfObject:day]];
                            
                            break;
                        }
                    }
                    
                }
            }
        }
//    });
}


//Method called to remove med from local notification
+ (void)removeNotif:(int)number andDay:(NSString *)day andTime:(NSString*)timeString andDayIndex:(int)dayIndex {
    number -= 1;
    if (number != 0) {
        
        [self initLocalNotif:number andDay:day andTime:timeString andDayIndex:dayIndex];
    }
}


#pragma mark - Alter Notifications Per Day
+ (void)alterNotificationsForTakenMed:(TodayMedication*)med {
    int dayIndex = [Constants getCurrentDay];
    NSArray *daysOfWeek = [[NSArray alloc] initWithObjects:@"sunday", @"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", nil];
    
    NSString *day = [daysOfWeek objectAtIndex:dayIndex];
    
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    
    for (int i = 0; i < [eventArray count]; i++) {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *identifier = [userInfoCurrent objectForKey:kUID];
        NSString *prefix = [day stringByAppendingString:[@"-" stringByAppendingString:[NSString stringWithFormat:@"%f",med.time]]];
        NSString *completeKey = [prefix stringByAppendingString:@"-today"];
        
        if (identifier == completeKey){
            //If we already have an "editted" notification for the day, lets just reduce the number from it
            int number = [[identifier substringFromIndex:[prefix length] + 1] intValue];
            number -= 1;
            
            [self scheduleTodayNotificationsWithNumber:number AndDay:day AndDayIndex:dayIndex AndTime:med.time];
            
        } else if ([identifier hasPrefix:prefix]) {
            
            NSString *alertMsg = oneEvent.alertBody;
            [app cancelLocalNotification:oneEvent];
            
            
            int number = [[identifier substringFromIndex:[prefix length] + 1] intValue];
            number -= 1;
            //First Lets change the notification for today.
            if (number > 0) {
                [self scheduleTodayNotificationsWithNumber:number AndDay:day AndDayIndex:dayIndex AndTime:med.time];
            }
            
            //Now lets re-add the existing notification for a week from today
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDate *now = [[NSDate date] dateByAddingTimeInterval:7*24*60*60];
            
            NSDateComponents *componentsForFireDate = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
            [componentsForFireDate setTimeZone:[NSTimeZone localTimeZone]];
            [componentsForFireDate setWeekday: dayIndex];
            
            float timeFloat = med.time;
            int minute = 0;
            if (timeFloat != (int)timeFloat){
                timeFloat = (int)timeFloat;
                minute = 30;
            }
            [componentsForFireDate setHour:timeFloat];
            [componentsForFireDate setMinute:minute];
            [componentsForFireDate setSecond:0];
            
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            
            notification.fireDate = [calendar dateFromComponents:componentsForFireDate];
            notification.repeatInterval = NSCalendarUnitWeekOfYear;
            
            
            //Set the title of the notification
            notification.alertBody = alertMsg;
            
            // Check if its iOS 8 for Mutable Notifications
            if IS_OS_8_OR_LATER {
                [self registerMutableNotifications];
                notification.category = @"action_notifs";
            }
            
            
            [notification setUserInfo:[NSDictionary dictionaryWithObject:identifier forKey:kUID]];
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
            
            
            
            break;
        }
    }
}

+ (void)scheduleTodayNotificationsWithNumber:(int)number AndDay:(NSString*)day AndDayIndex:(int)dayIndex AndTime:(int)time {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [[NSDate date] dateByAddingTimeInterval:7*24*60*60];
    
    NSDateComponents *componentsForFireDate = [calendar components:(NSYearCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit| NSSecondCalendarUnit | NSWeekdayCalendarUnit) fromDate: now];
    [componentsForFireDate setTimeZone:[NSTimeZone localTimeZone]];
    [componentsForFireDate setWeekday: dayIndex];
    
    float timeFloat = time;
    int minute = 0;
    if (timeFloat != (int)timeFloat){
        timeFloat = (int)timeFloat;
        minute = 30;
    }
    [componentsForFireDate setHour:timeFloat];
    [componentsForFireDate setMinute:minute];
    [componentsForFireDate setSecond:0];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    notification.fireDate = [calendar dateFromComponents:componentsForFireDate];
    
    //Set the title of the notification
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterSpellOutStyle];
    NSString *s = [f stringFromNumber:[NSNumber numberWithInt:number]];
    NSString *alertBody;
    
    if (number == 1) {
        alertBody = [s stringByAppendingString:@" med!"];
    } else {
        alertBody = [s stringByAppendingString:@" meds!"];
    }
    
    // Check if its iOS 8 for Mutable Notifications
    if IS_OS_8_OR_LATER {
        [self registerMutableNotifications];
        notification.category = @"action_notifs";
    }
    
    NSString *key = [[NSString stringWithFormat:@"%d", time] stringByAppendingString:[@"-" stringByAppendingString:[NSString stringWithFormat:@"%d", number]]];
    day = [day stringByAppendingString:@"-"];
    key = [day stringByAppendingString:@"today"];
    
    [notification setUserInfo:[NSDictionary dictionaryWithObject:key forKey:kUID]];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - Register Mutable Notifications for iOS8
+ (void)registerMutableNotifications {

    UIMutableUserNotificationAction* takenAction = [[UIMutableUserNotificationAction alloc] init];
    [takenAction setIdentifier:@"taken"];
    [takenAction setTitle:@"Taken"];
    [takenAction setActivationMode:UIUserNotificationActivationModeBackground];
    [takenAction setDestructive:YES];
    
    UIMutableUserNotificationAction* delayAction = [[UIMutableUserNotificationAction alloc] init];
    [delayAction setIdentifier:@"delayed"];
    [delayAction setTitle:@"Delay"];
    [delayAction setActivationMode:UIUserNotificationActivationModeForeground];
    [delayAction setDestructive:NO];
    
    UIMutableUserNotificationCategory* takenDelayCategory = [[UIMutableUserNotificationCategory alloc] init];
    [takenDelayCategory setIdentifier:@"action_notifs"];
    [takenDelayCategory setActions:@[delayAction, takenAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet* categories = [NSSet setWithArray:@[takenDelayCategory]];
    UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    

}



@end
