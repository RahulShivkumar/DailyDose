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
                        NSString *prefix = [day stringByAppendingString:[NSString stringWithFormat:@"%@",[times objectAtIndex:j]]];
                        
                        if ([identifier hasPrefix:prefix])
                        {
                            flag = YES;
                            [app cancelLocalNotification:oneEvent];
                            int number = [[identifier substringFromIndex:[prefix length]] intValue];
                            
                            [self initLocalNotif:number andDay:day
                                         andTime:[NSString stringWithFormat:@"%@",[times objectAtIndex:j]]
                                     andDayIndex:(int)[daysOfWeek indexOfObject:day] + 1];
                            
                            break;
                        }
                    }
                    if (!flag){
                        int number = 0;
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
    number += 1;
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
    if (IS_OS_8_OR_LATER){
        [NotificationScheduler registerMutableNotifications];
        notification.category = @"action_notifs";
    }
    
    NSString *key = [timeString stringByAppendingString:[NSString stringWithFormat:@"%d", number]];
    key = [day stringByAppendingString:key];
    
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
                        NSString *prefix = [day stringByAppendingString:[NSString stringWithFormat:@"%@",[times objectAtIndex:j]]];
                        
                        if ([identifier hasPrefix:prefix])
                        {
                            [app cancelLocalNotification:oneEvent];
                            int number = [[identifier substringFromIndex:[prefix length]] intValue];
                            
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


//Method called to create the local notifications
+ (void)removeNotif:(int)number andDay:(NSString *)day andTime:(NSString*)timeString andDayIndex:(int)dayIndex {
    number -= 1;
    if (number != 0) {
        
        [self initLocalNotif:number andDay:day andTime:timeString andDayIndex:dayIndex];
    }
}


+ (void)registerMutableNotifications {

    UIMutableUserNotificationAction* takenAction = [[UIMutableUserNotificationAction alloc] init];
    [takenAction setIdentifier:@"taken"];
    [takenAction setTitle:@"Taken"];
    [takenAction setActivationMode:UIUserNotificationActivationModeBackground];
    [takenAction setDestructive:YES];
    
    UIMutableUserNotificationAction* delayAction = [[UIMutableUserNotificationAction alloc] init];
    [delayAction setIdentifier:@"delay"];
    [delayAction setTitle:@"Delay"];
    [delayAction setActivationMode:UIUserNotificationActivationModeForeground];
    [delayAction setDestructive:NO];
    
    UIMutableUserNotificationCategory* deleteReplyCategory = [[UIMutableUserNotificationCategory alloc] init];
    [deleteReplyCategory setIdentifier:@"action_notifs"];
    [deleteReplyCategory setActions:@[delayAction, takenAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet* categories = [NSSet setWithArray:@[deleteReplyCategory]];
    UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    

}



@end
