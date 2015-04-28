//
//  Medication.m
//  ClearStyle
//
//  Created by Fahim Farook on 22/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import "Medication.h"

@implementation Medication

-(id)initWithName:(NSString*)text andChemName:(NSString*)chem{
    if (self = [super init]) {
		self.medName = text;
        self.chemName = chem;
    }
    return self;
}

+(id)initWithName:(NSString*)text andChemName:(NSString*)chem {
    return [[Medication alloc] initWithName:text andChemName:chem];
}
-(void)isCompleted:(BOOL)complete{
    self.completed = complete;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
    NSString *query;
    if(complete){
        query = [NSString stringWithFormat: @"UPDATE today_meds set completed = 1 where rowid = %f", self.med_id];
    }
    else{
        query = [NSString stringWithFormat: @"UPDATE today_meds set completed = 0 where rowid = %f", self.med_id];
    }
    [self.dbManager executeQuery:query];
}

@end
