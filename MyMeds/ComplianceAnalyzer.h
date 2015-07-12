//
//  ComplianceAnalyzer.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 6/27/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplianceCircle.h"
#import "Constants.h"
#import "EventLogger.h"

@interface ComplianceAnalyzer : UIView {
    ComplianceCircle *circleView1;
    ComplianceCircle *circleView2;
    ComplianceCircle *circleView3;
    
    UILabel *header;
    UILabel *complianceRating;
    UILabel *missedMeds;
    UILabel *delayedMeds;
}

- (id)initWithFrame:(CGRect)frame;

- (void)animateViews;
- (void)clearViews;

@end
