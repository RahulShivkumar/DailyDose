//
//  ComplianceAnalyzer.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 6/27/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComplianceCircle.h"

@interface ComplianceAnalyzer : UIView {
    ComplianceCircle *circleView1;
    ComplianceCircle *circleView2;
    ComplianceCircle *circleView3;
}

- (id)initWithFrame:(CGRect)frame;

- (void)animateViews;
- (void)clearViews;

@end
