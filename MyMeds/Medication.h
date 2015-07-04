//
//  Medication.h
//  ClearStyle
//
//  Created by Fahim Farook on 22/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DBAccess/DBAccess.h>
#import "CoreMedication.h"

@interface Medication : DBObject

@property (nonatomic, strong) CoreMedication *coreMed;
@property (nonatomic, strong) NSString *rxid;
@property (nonatomic, strong) NSString *type;

@property (nonatomic) float time;

@property (nonatomic) int dispense;
@property (nonatomic) int refill;
@property (nonatomic) int quantity;

@property (nonatomic) BOOL monday;
@property (nonatomic) BOOL tuesday;
@property (nonatomic) BOOL wednesday;
@property (nonatomic) BOOL thursday;
@property (nonatomic) BOOL friday;
@property (nonatomic) BOOL saturday;
@property (nonatomic) BOOL sunday;


@end
