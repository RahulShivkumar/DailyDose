//
//  NotificationScheduler.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 7/5/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CoreMedication.h"
#import "Medication.h"
#import "DayPicker.h"
#import "Constants.h"
#import "TodayMedication.h"

@interface NotificationScheduler : NSObject

+ (void)setupLocalNotifsWithDictionary:(NSMutableDictionary *)days
                              andTimes:(NSMutableArray *)times;
+ (void)initLocalNotif:(int)number
                andDay:(NSString *)day
               andTime:(NSString *)timeString
           andDayIndex:(int)dayIndex;

+ (void)removeLocalNotificationWithCoreMedication:(CoreMedication *)cm
                                         AndTimes:(NSMutableArray *)times;
+ (void)removeNotif:(int)number
             andDay:(NSString *)day
            andTime:(NSString *)timeString
        andDayIndex:(int)dayIndex;

+ (void)alterNotificationsForTakenMed:(TodayMedication *)med;
+ (void)scheduleTodayNotificationsWithNumber:(int)number
                                      AndDay:(NSString *)day
                                 AndDayIndex:(int)dayIndex
                                     AndTime:(float)time;

@end
