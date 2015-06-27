//
//  Medication.m
//  ClearStyle
//
//  Created by Fahim Farook on 22/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import "Medication.h"

@implementation Medication

- (id)initWithName:(NSString*)text andChemName:(NSString*)chem{
    if (self = [super init]) {
		self.medName = text;
        self.chemName = chem;
    }
    return self;
}

+ (id)initWithName:(NSString*)text andChemName:(NSString*)chem {
    return [[Medication alloc] initWithName:text andChemName:chem];
}


@end
