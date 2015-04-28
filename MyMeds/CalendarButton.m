//
//  CalendarButton.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 2/10/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "CalendarButton.h"

#define highlight [UIColor colorWithRed:194/255.0 green:59/255.0 blue:34/255.0 alpha:1.0]
#define gray [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1.0]

#define bgFrame CGRectMake(self.frame.origin.x + 5, 0, 80, self.frame.size.height)
#define dateFrame CGRectMake(0, 0, frame.size.width - 6, frame.size.height * 0.6)
#define dayFrame CGRectMake(0 , frame.size.height * 0.6, frame.size.width , frame.size.height * 0.35)

@implementation CalendarButton
-(id)initWithDate:(NSDate*)date andFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *dateAndTime = [self convertDate:date];
        
        dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
        dateLabel.backgroundColor = [UIColor clearColor];
        [dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:42]];
        [dateLabel setTextAlignment:NSTextAlignmentCenter];
        [dateLabel setText:[dateAndTime objectAtIndex:0]];
        
        dayLabel = [[UILabel alloc] initWithFrame:dayFrame];
        dayLabel.backgroundColor = [UIColor clearColor];
        [dayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
        [dayLabel setTextAlignment:NSTextAlignmentCenter];
        [dayLabel setText:[dateAndTime objectAtIndex:1]];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [dateLabel setTextColor:gray];
        [dayLabel setTextColor:gray];
        
        [self addSubview:dateLabel];
        [self addSubview:dayLabel];
    }

    return self;
}

+(id)initWithDate:(NSDate*)date andFrame:(CGRect)frame{
    return [[CalendarButton alloc] initWithDate:date andFrame:frame];
}

-(void)addHighlight{
    bgView = [[UIView alloc] initWithFrame:bgFrame];
    [bgView setBackgroundColor:highlight];
    bgView.layer.cornerRadius = 5.0;
    [self addSubview:bgView];
    [dateLabel setTextColor:[UIColor whiteColor]];
    [dayLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:dateLabel];
    [self addSubview:dayLabel];
    self.selected = YES;
}

-(void)removeHighlight{
    [bgView removeFromSuperview];
    [dateLabel setTextColor:gray];
    [dayLabel setTextColor:gray];
    [self addSubview:dateLabel];
    [self addSubview:dayLabel];
    self.selected = NO;
}

-(NSMutableArray*)convertDate:(NSDate*)date{
    NSMutableArray *dateAndTime = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd";
    [dateAndTime addObject:[dateFormatter stringFromDate:date]];
    
    dateFormatter.dateFormat=@"EEEE";
    [dateAndTime addObject:[dateFormatter stringFromDate:date]];
    return dateAndTime;
}

@end
