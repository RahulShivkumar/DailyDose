//
//  EventLog.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 6/28/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreMedication.h"
#import "Event.h"
#import "Constants.h"
#import "Amplitude.h"

@interface EventLogger : NSObject {
    NSString *mName;
    NSString *eName;
    int time;
}

+ (void)logAction:(NSString*)action andMedication:(CoreMedication*)cm andTime:(int)time;
+ (void)undoLogWithAction:(NSString*)action andMedication:(CoreMedication*)cm andTime:(int)time;

@end
