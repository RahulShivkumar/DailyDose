//
//  ComplianceAnalyzer.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 6/27/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "ComplianceAnalyzer.h"

#define kDoneColor                                                             \
[UIColor colorWithRed:142 / 255.0                                            \
green:178 / 255.0                                            \
blue:197 / 255.0                                            \
alpha:1.0]
#define kInfoColor                                                             \
[UIColor colorWithRed:229 / 255.0 green:98 / 255.0 blue:92 / 255.0 alpha:1.0]
#define kDelayColor                                                            \
[UIColor colorWithRed:249 / 255.0                                            \
green:191 / 255.0                                            \
blue:118 / 255.0                                            \
alpha:1.0]

@implementation ComplianceAnalyzer

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)animateViews {
    
    header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 20)];
    [header setTextAlignment:NSTextAlignmentCenter];
    header.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, 20);
    [header setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:25]];
    [header setTextColor:[Constants getNavBarColor]];
    [header setText:@"This Week"];
    [self addSubview:header];
    
    NSDictionary *values = [EventLogger getComplianceAnalyzerMetrics];
    
    circleView1 =
    [[ComplianceCircle alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [circleView1 addCircleLayerWithType:VMMakeLocationTop];
    circleView1.strokeColor = kInfoColor;
    circleView1.center = CGPointMake(CGRectGetWidth(self.bounds) / 4,
                                     CGRectGetHeight(self.bounds) * 2 / 3);
    [circleView1 setIconButton:[UIImage imageNamed:@"Layer 14.png"]
                      withType:VMMakeLocationTop
                     withColor:kInfoColor];
    [circleView1 setLineWidthValue:1];
    [circleView1 setValue:[values objectForKey:@"missed"]
              andProperty:@"Missed Meds"
             andTextColor:kInfoColor];
    [self addSubview:circleView1];
    
    circleView2 =
    [[ComplianceCircle alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [circleView2 addCircleLayerWithType:VMMakeLocationBottom];
    circleView2.strokeColor = kDelayColor;
    circleView2.center = CGPointMake(CGRectGetWidth(self.bounds) / 2,
                                     CGRectGetHeight(self.bounds) / 3);
    [circleView2 setIconButton:[UIImage imageNamed:@"Layer 15.png"]
                      withType:VMMakeLocationBottom
                     withColor:kDelayColor];
    [circleView2 setLineWidthValue:1];
    [circleView2 setValue:[values objectForKey:@"delayed"]
              andProperty:@"Delayed Meds"
             andTextColor:kDelayColor];
    [self addSubview:circleView2];
    
    circleView3 =
    [[ComplianceCircle alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    [circleView3 addCircleLayerWithType:VMMakeLocationTop];
    circleView3.strokeColor = kDoneColor;
    circleView3.center = CGPointMake(CGRectGetWidth(self.bounds) * 3 / 4,
                                     CGRectGetHeight(self.bounds) * 2 / 3);
    [circleView3 setIconButton:[UIImage imageNamed:@"Layer 16.png"]
                      withType:VMMakeLocationTop
                     withColor:kDoneColor];
    [circleView3 setLineWidthValue:1];
    [circleView3 setValue:[values objectForKey:@"compliance"]
              andProperty:@"Compliance %"
             andTextColor:kDoneColor];
    [self addSubview:circleView3];
    
    [circleView1 buildButton];
    [circleView2 buildButton];
    [circleView3 buildButton];
}

- (void)clearViews {
    for (UIView *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
}
@end
