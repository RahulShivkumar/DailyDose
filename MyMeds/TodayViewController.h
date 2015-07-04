//
//  TodayViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DBAccess/DBAccess.h>
#import "MenuController.h"
#import "Constants.h"
#import "ComplianceAnalyzer.h"
#import "TodayMedication.h"

@interface TodayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MenuControllerDelegate>{
    
    DBResultSet *amMeds;
    DBResultSet *pmMeds;
    
//    NSMutableArray *futureAmMeds;
//    NSMutableArray *futurePmMeds;
    
    NSMutableArray *header;
    
    DBResultSet *missedMeds;
    
    NSArray *medsArray;
    
    MenuController *sideBar;
    
    NSDate *current;
    NSDate *futureDate;
    
    BOOL future;
    BOOL pushed;
    
    ComplianceAnalyzer *compAnalyzer;
}

@property (nonatomic, strong) UITableView *medsView;

- (void)setupSqlDefaults:(NSDate*)date;
- (void)setupTodayArrays:(NSDate *)date;
- (void)setupMeds;

- (void)setupViews;
- (void)setupTabBar;
- (void)setupCalendar;

- (void)showCompliance;
- (void)moveTableUp;
- (void)moveTableDown;
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer;

- (IBAction)loadInfo:(id)sender;
- (IBAction)delay:(id)sender;
- (IBAction)undo:(id)sender;

- (void)showMenu;
- (BOOL)tabBarIsVisible;
- (UIStatusBarStyle)preferredStatusBarStyle;
- (void)appReturnsActive;

- (DBResultSet*)createTodayMedsArray:(DBResultSet*)meds;

@end

