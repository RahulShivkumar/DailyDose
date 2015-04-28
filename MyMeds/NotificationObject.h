//
//  NotificationObject.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 3/25/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationObject : NSObject
@property(nonatomic)NSString *time;
@property(nonatomic)float actualTime;
@property(nonatomic)int *count;
@property(nonatomic)NSString *ampm;
@end
