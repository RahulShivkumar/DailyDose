//
//  Medication.h
//  ClearStyle
//
//  Created by Fahim Farook on 22/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBManager.h"

@interface Medication : NSObject

@property (nonatomic, copy) NSString *medName;
@property (nonatomic, copy) NSString *chemName;
@property (nonatomic, copy) NSString *subName;
@property (nonatomic, copy) NSString *dosage;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *rxid;
@property (nonatomic)int actualTime;
@property (nonatomic, copy) NSString *amPm;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;
@property (nonatomic) int dispense;
@property (nonatomic) int refill;
@property (nonatomic) int quantity;
@property (nonatomic) double med_id;


@property (nonatomic) BOOL completed;
@property (nonatomic) BOOL mon;
@property (nonatomic) BOOL tue;
@property (nonatomic) BOOL wed;
@property (nonatomic) BOOL thurs;
@property (nonatomic) BOOL fri;
@property (nonatomic) BOOL sat;
@property (nonatomic) BOOL sun;

@property (nonatomic, strong) DBManager *dbManager;
// Returns an Medication item initialised with the given text.
-(id)initWithName:(NSString*)text andChemName:(NSString*)chem;
-(void)isCompleted:(BOOL)complete;
// Returns an Medication item initialised with the given text.
+(id)initWithName:(NSString*)text andChemName:(NSString*)chem;

@end
