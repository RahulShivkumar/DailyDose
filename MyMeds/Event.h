//
//  Events.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 7/3/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <DBAccess/DBAccess.h>
#import "CoreMedication.h"

@interface Event : DBObject

@property (nonatomic, strong) NSString *action;

@property (nonatomic, strong) CoreMedication *cm;

@property (nonatomic, strong) NSString *medName;

@property (nonatomic) long long timeStamp;

@property (nonatomic)float timeDelta;
@property (nonatomic)int time;

@end
