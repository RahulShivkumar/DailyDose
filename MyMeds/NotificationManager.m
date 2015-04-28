//
//  NotificationManager.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 3/25/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "NotificationManager.h"
#import "NotificationObject.h"

@implementation NotificationManager
-(id)init{
    self = [super init];
    if(self){
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
    }
    return self;
}

-(void)scheduleNotificationsWithTime:(int)time andDays:(NSMutableDictionary *)days{
    //Lets Delete the existing Notification for that time/day
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *eventArray = [app scheduledLocalNotifications];
//    for (int i=0; i<[eventArray count]; i++)
//    {
//        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
//        NSDictionary *userInfoCurrent = oneEvent.userInfo;
//        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
//        if ([uid isEqualToString:uidtodelete])
//        {
//            //Cancelling local notification
//            [app cancelLocalNotification:oneEvent];
//            break;
//        }
//    }
}
-(NSMutableArray *)setDataInArray:(NSArray *)temp{
    NSMutableArray *tempMutable = [[NSMutableArray alloc] init];
    for(int i = 0; i < [temp count]; i++){
        int count = [[[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"count"]]intValue];
        NSString *amPm = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"ampm"]];
        NSString *tempTime = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"time"]];
        float actualTime = [tempTime floatValue];
        if(actualTime > 12.5){
            actualTime -= 12;
        }
        NSString *time = [NSString stringWithFormat:@"%d",(int)actualTime];
        if(actualTime == (int) actualTime){
            time = [time stringByAppendingString:@":00"];
        }
        else{
            time = [time stringByAppendingString:@":30"];
        }
        
        NotificationObject *notObj;
        [notObj setTime:time];
        [notObj setAmpm:amPm];
        [notObj setCount:&count];
        [notObj setActualTime:actualTime];
        
        [tempMutable addObject:notObj];
    }
    return tempMutable;
}
@end
