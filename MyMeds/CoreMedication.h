//
//  CoreMedication.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 7/2/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <DBAccess/DBAccess.h>

@interface CoreMedication : DBObject

@property (nonatomic, strong) NSString *genName;
@property (nonatomic, strong) NSString *chemName;
@property (nonatomic, strong) NSString *dosage;

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, copy) NSDate *endDate;

@property (nonatomic) int expired;

@end
