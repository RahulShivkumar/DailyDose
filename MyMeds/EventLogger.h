//
//  EventLog.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 6/28/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventLogger : NSObject {
    NSString *mName;
    NSString *eName;
    int time;
}

- (id)initWithMedName:(NSString *)medName andEventName:(NSString *)eName andMedTime:(int)medTime;
- (void)log;
@end
