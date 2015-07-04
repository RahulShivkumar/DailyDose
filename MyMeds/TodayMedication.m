//
//  TodayMedication.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 7/1/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "TodayMedication.h"

@implementation TodayMedication

@dynamic coreMed, rxid, type, taken, time, dispense, refill, quantity;

- (void)createFromMedication:(Medication *)med{
    self.coreMed = med.coreMed;
    self.rxid = med.rxid;
    
    self.taken = NO;
    
    self.time = med.time;
    
    self.dispense = med.dispense;
    self.refill = med.refill;
    self.quantity = med.quantity;
}
@end
