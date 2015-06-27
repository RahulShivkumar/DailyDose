//
//  CalendarButton.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 2/10/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarButton : UIButton{
    UIView *bgView;
    UILabel *dayLabel;
    UILabel *dateLabel;
    
    BOOL selected;
}

- (id)initWithDate:(NSDate*)date andFrame:(CGRect)frame;
+ (id)initWithDate:(NSDate*)date andFrame:(CGRect)frame;

- (void)addHighlight;
- (void)removeHighlight;

- (NSMutableArray*)convertDate:(NSDate*)date;

@end
