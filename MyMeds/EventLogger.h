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
#import "TodayMedication.h"
#import "Medication.h"
#import "GraphData.h"


@interface EventLogger : NSObject {
    NSString *mName;
    NSString *eName;
    int time;
}

+ (void)logAction:(NSString*)action andMedication:(CoreMedication*)cm andTime:(int)time;

+ (NSDictionary*)getComplianceAnalyzerMetrics;
+ (NSMutableArray*)getGraphMetrics;

+ (void)logMissedMedsFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate;


@end
