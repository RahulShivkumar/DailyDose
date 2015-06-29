//
//  EventLog.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 6/28/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface EventLogger : NSObject {
    NSString *mName;
    NSString *eName;
}

@property (nonatomic, strong) DBManager *dbManager;

- (id)initWithMedName:(NSString *)medName andEventName:(NSString *)eName;
- (void)log;
@end
