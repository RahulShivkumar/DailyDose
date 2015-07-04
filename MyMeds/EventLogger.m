//
//  EventLog.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 6/28/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "EventLogger.h"

@implementation EventLogger

- (id)initWithMedName:(NSString *)medName andEventName:(NSString *)eventName andMedTime:(int)medTime{
    self = [super init];
    if (self) {
        mName = medName;
        eName = eventName;
        time = medTime;
    }
    return self;
}


- (void)log {
 
    
    //TO-DO Store in the cloud 
}
@end
