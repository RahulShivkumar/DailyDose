//
//  AnalyzeViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "BEMSimpleLineGraphView.h"
#import "EventLogger.h"


@interface AnalyzeViewController : UIViewController <BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>{
    
}

@property(strong, nonatomic)BEMSimpleLineGraphView *complianceGraph;
- (void)setupViews;

@end
