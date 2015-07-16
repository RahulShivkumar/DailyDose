//
//  EventLog.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 6/28/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "EventLogger.h"

@implementation EventLogger

+ (void)logAction:(NSString*)action andMedication:(CoreMedication*)cm andTime:(int)time{
    //Run it on a background thread so it doesn't choke the main thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Event *event = [Event new];
        event.cm = cm;
        event.action = action;
        event.time = time;
        long long timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
        event.timeStamp = timeInMiliseconds;
        //Negative time = time the med is taken after it should be
        event.timeDelta = time - [Constants getCurrentHour] + [Constants getCurrentMinute]/60.0;
        [event commit];
        
        //Remote Logging
        NSDictionary *eventProperties = [[NSDictionary alloc] initWithObjects:@[[NSNumber numberWithInt:event.time],  [NSNumber numberWithFloat:event.timeDelta], [NSDate date]]
                                                                      forKeys:@[@"time", @"time_delta", @"time_stamp"]];
        [Amplitude logEvent:action withEventProperties:eventProperties];
    });
}


+ (NSDictionary*)getComplianceAnalyzerMetrics {
    int currentDay = [Constants getCurrentDay];
    float requiredTimeLapse = currentDay - 1;
    
    //If its a sunday
    if (requiredTimeLapse == 0){
        int currentHour = (int)[Constants getCurrentHour];
        //Just present missed meds for the day
        requiredTimeLapse = currentHour/24;
    }
    
    long long sevenDaysAgo =  [[[NSDate date] dateByAddingTimeInterval:-requiredTimeLapse*24*60*60] timeIntervalSince1970];
    long long current = [[NSDate date] timeIntervalSince1970];
    NSString *query = [NSString stringWithFormat:@"timeStamp >= %lld and timeStamp <= %lld and action = 'missed'", sevenDaysAgo, current];
    int missedMeds = [[[Event query] where:query] count];
    
    query = [NSString stringWithFormat:@"timeStamp >= %lld and timeStamp <= %lld and action = 'delayed'", sevenDaysAgo, current];
    int delayedMeds = [[[Event query] where:query] count];
    
    query = [NSString stringWithFormat:@"timeStamp >= %lld and timeStamp <= %lld and action = 'taken'", sevenDaysAgo, current];
    int takenMeds = [[[Event query] where:query] count];
    
    //Consider the undo commands
     query = [NSString stringWithFormat:@"timeStamp >= %lld and timeStamp <= %lld and action = 'undo'", sevenDaysAgo, current];
    takenMeds = takenMeds - [[[Event query] where:query] count];
    
    float compliance = (takenMeds - 0.2 *delayedMeds)/(takenMeds + missedMeds) * 100.0;
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", (int)compliance], @"compliance", [NSString stringWithFormat:@"%d", (int)delayedMeds], @"delayed", [NSString stringWithFormat:@"%d", (int)missedMeds], @"missed", nil];
}


+ (NSMutableArray*)getGraphMetrics{
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    NSDate *movingDate = [NSDate date];
    for (int i = 0 ; i < 4 ; i ++) {
        float requiredTimeLapse = 7;
        if (i == 0){
            int currentDay = [Constants getCurrentDay];
            float requiredTimeLapse = currentDay - 1;
            
            //If its a sunday
            if (requiredTimeLapse == 0){
                int currentHour = (int)[Constants getCurrentHour];
                //Just present missed meds for the day
                requiredTimeLapse = currentHour/24;
            }
        }
        long long sevenDaysAgo =  [[movingDate dateByAddingTimeInterval:-requiredTimeLapse*24*60*60] timeIntervalSince1970];
        long long current = [movingDate timeIntervalSince1970];
        NSString *query = [NSString stringWithFormat:@"timeStamp >= %lld and timeStamp <= %lld and action = 'missed'", sevenDaysAgo, current];
        int missedMeds = [[[Event query] where:query] count];
        
        query = [NSString stringWithFormat:@"timeStamp >= %lld and timeStamp <= %lld and action = 'delayed'", sevenDaysAgo, current];
        int delayedMeds = [[[Event query] where:query] count];
        
        query = [NSString stringWithFormat:@"timeStamp >= %lld and timeStamp <= %lld and action = 'taken'", sevenDaysAgo, current];
        int takenMeds = [[[Event query] where:query] count];
        
        //Consider the undo commands
        query = [NSString stringWithFormat:@"timeStamp >= %lld and timeStamp <= %lld and action = 'undo'", sevenDaysAgo, current];
        takenMeds = takenMeds - [[[Event query] where:query] count];
        
        float compliance = (takenMeds - 0.2 *delayedMeds)/(takenMeds + missedMeds) * 100.0;
        
        if ((int)compliance < 0){
            compliance = 0;
        }
        
        movingDate = [NSDate dateWithTimeIntervalSince1970:sevenDaysAgo];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setDateFormat:@"MMM dd"];
        
        GraphData *gd = [GraphData new];
        [gd setDate:[formatter stringFromDate:movingDate]];
        [gd setCompliance:(int)compliance];
        [results addObject:gd];
    }
    return results;
}


+ (void)logMissedMedsFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate {
    //Lets log these events in the main thread before TodayMeds is cleared
    for (TodayMedication *tm in [[[TodayMedication query] where:@"taken = 0"] fetch]){
        [self logAction:@"missed" andMedication:tm.coreMed andTime:tm.time];
    }
    
    //Log these events in a separate thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Now lets log all the missed meds in the 'remaining days' between the last open and today
        NSDate *rollingDate = [fromDate dateByAddingTimeInterval:24*60*60];
        
        if(![Constants compareDate:rollingDate withOtherdate:toDate]){
             NSString *dayOfWeek = [Constants getCurrentDayFromDate:rollingDate];
            for (Medication *med in [[[Medication query] whereWithFormat:@"%@ = 1", [dayOfWeek lowercaseString]] fetch]){
                [self logAction:@"missed" andMedication:med.coreMed andTime:med.time];
            }
        }
    });
    
}

@end
