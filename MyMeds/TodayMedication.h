//
//  TodayMedication.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 7/1/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DBAccess/DBAccess.h>
#import "Medication.h"

@interface TodayMedication : DBObject

@property (nonatomic, strong) CoreMedication *coreMed;
@property (nonatomic, strong) NSString *rxid;
@property (nonatomic, strong) NSString *type;

@property (nonatomic) BOOL taken;

@property (nonatomic) float time;

@property (nonatomic) int dispense;
@property (nonatomic) int refill;
@property (nonatomic) int quantity;

- (void)createFromMedication:(Medication *)med;

@end
