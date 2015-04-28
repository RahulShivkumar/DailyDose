//
//  NotificationManager.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 3/25/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"
@interface NotificationManager : NSObject
@property (nonatomic, strong) DBManager *dbManager;

-(void)scheduleNotificationsWithTime:(int)time andDays:(NSMutableDictionary *)days;
@end
