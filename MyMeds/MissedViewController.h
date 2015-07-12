//
//  MissedViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 2/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DBAccess/DBAccess.h>
#import "Constants.h"
#import "InfoViewController.h"
#import "MedsCell.h"
#import "MissedViewController.h"
#import "Medication.h"
#import "MedsCell.h"
#import "EventLogger.h"

@interface MissedViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, StrikeDelegate>{
    NSMutableArray *meds;
    
    UILabel *title;
    
    UIButton *taken;
    UIButton *delay;
    
    UIButton *skip;
    long hour;
}

@property (nonatomic, strong) UITableView *medsView;

- (id)initWithMeds:(DBResultSet*)missedMeds andHour:(long)hr;

- (void)setupViews;

- (IBAction)taken:(id)sender;
- (IBAction)delay:(id)sender;
- (IBAction)skip:(id)sender;
- (IBAction)loadInfo:(id)sender;
- (IBAction)delaySingleMed:(id)sender;
- (IBAction)skipSingleMed:(id)sender;
- (void)checkCompleted;


@end
