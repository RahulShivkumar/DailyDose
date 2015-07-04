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
        event.timeStamp = [NSDate date];
        //Negative time = time the med is taken after it should be
        event.timeDelta = time - [Constants getCurrentHour] + [Constants getCurrentMinute]/60.0;
        [event commit];
        
        //Remote Logging
        NSDictionary *eventProperties = [[NSDictionary alloc] initWithObjects:@[cm.genName, cm.chemName, [NSNumber numberWithInt:event.time],  [NSNumber numberWithFloat:event.timeDelta], event.timeStamp]
                                                                      forKeys:@[@"gen_name", @"chem_name", @"time", @"time_delta", @"time_stamp"]];
        [Amplitude logEvent:action withEventProperties:eventProperties];
    });
}

+ (void)undoLogWithAction:(NSString*)action andMedication:(CoreMedication*)cm andTime:(int)time{
    
    
}
@end
