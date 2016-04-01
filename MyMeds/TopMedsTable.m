//
//  TopMedsTable.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 7/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "TopMedsTable.h"

@implementation TopMedsTable

#define kSizeOfView                                                            \
(self.frame.size.height - 27) * MAX(1, [[self.data allKeys] count]) / 5.0
#define kSizeOfRow (self.frame.size.height - 27) / 5.0

- (id)initWithFrame:(CGRect)frame andData:(NSMutableDictionary *)data {
    self = [super initWithFrame:frame];
    if (self) {
        self.data = data;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    title = [[UILabel alloc]
             initWithFrame:CGRectMake(17, 0, self.frame.size.width, 20)];
    [title setText:@"TOP MISSED MEDS (4 WEEKS):"];
    [title setTextColor:[UIColor lightGrayColor]];
    [title setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:title];
    
    bgView = [[UIView alloc]
              initWithFrame:CGRectMake(0, 27, self.frame.size.width, kSizeOfView)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    
    [self addLineSeparator:0];
    
    if ([[self.data allKeys] count] > 0) {
        [self addMedToView:0 andYPosition:kSizeOfRow / 2 - 10];
        [self addLineSeparator:kSizeOfRow];
    } else {
        [self addNoDataAvailable:kSizeOfRow / 2 - 10];
        [self addLineSeparator:kSizeOfRow];
    }
    
    if ([[self.data allKeys] count] > 1) {
        [self addMedToView:1 andYPosition:kSizeOfRow + (kSizeOfRow / 2 - 10)];
        [self addLineSeparator:2 * kSizeOfRow];
    }
    if ([[self.data allKeys] count] > 2) {
        [self addMedToView:2 andYPosition:2 * kSizeOfRow + (kSizeOfRow / 2 - 10)];
        [self addLineSeparator:3 * kSizeOfRow];
    }
    if ([[self.data allKeys] count] > 3) {
        [self addMedToView:3 andYPosition:3 * kSizeOfRow + (kSizeOfRow / 2 - 10)];
        [self addLineSeparator:4 * kSizeOfRow];
    }
    if ([[self.data allKeys] count] > 4) {
        [self addMedToView:4 andYPosition:4 * kSizeOfRow + (kSizeOfRow / 2 - 10)];
        [self addLineSeparator:5 * kSizeOfRow];
    }
    [self addSubview:bgView];
}

- (void)addMedToView:(int)index andYPosition:(float)y {
    NSString *key = [[self.data allKeys] objectAtIndex:index];
    
    UILabel *medLabel = [[UILabel alloc]
                         initWithFrame:CGRectMake(17, y, bgView.frame.size.width * 0.70, 20)];
    [medLabel setText:key];
    [bgView addSubview:medLabel];
    
    UILabel *valueLabel = [[UILabel alloc]
                           initWithFrame:CGRectMake(bgView.frame.size.width * 0.80, y,
                                                    bgView.frame.size.width * 0.20, 20)];
    [valueLabel
     setText:[NSString stringWithFormat:@"%@", [self.data objectForKey:key]]];
    [bgView addSubview:valueLabel];
}

- (void)addNoDataAvailable:(float)y {
    
    UILabel *noDataLabel = [[UILabel alloc]
                            initWithFrame:CGRectMake(17, y, bgView.frame.size.width * 0.70, 20)];
    [noDataLabel setText:@"No Data Available"];
    [bgView addSubview:noDataLabel];
}

- (void)addLineSeparator:(float)y {
    UIView *lineSeperator1 = [[UIView alloc]
                              initWithFrame:CGRectMake(0, y, bgView.frame.size.width, 0.5)];
    [lineSeperator1 setBackgroundColor:[UIColor lightGrayColor]];
    [bgView addSubview:lineSeperator1];
}
@end
