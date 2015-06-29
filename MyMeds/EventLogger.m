//
//  EventLog.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 6/28/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "EventLogger.h"

@implementation EventLogger

- (id)initWithMedName:(NSString *)medName andEventName:(NSString *)eventName{
    self = [super init];
    if (self) {
        mName = medName;
        eName = eventName;
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
    }
    return self;
}


- (void)log {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"MM/dd/yyyy"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];

    NSString *query = [NSString stringWithFormat: @"insert into analytics(med_name, date, event) values ('%@', '%@', '%@') ",  mName, dateString, eName];
    [self.dbManager executeQuery:query];
    
    //TO-DO Store in the cloud 
}
@end
