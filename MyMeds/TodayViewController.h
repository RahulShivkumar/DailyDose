//
//  TodayViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DBAccess/DBAccess.h>
#import <QuartzCore/QuartzCore.h>
#import "MenuController.h"
#import "Constants.h"
#import "ComplianceAnalyzer.h"
#import "TodayMedication.h"
#import "EventLogger.h"
#import "MedsCell.h"
#import "MissedViewController.h"
#import "RTWalkthroughPageViewController.h"
#import "RTWalkthroughViewController.h"


@interface TodayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MenuControllerDelegate, RTWalkthroughPageViewControllerDelegate, RTWalkthroughViewControllerDelegate, StrikeDelegate>{
    
    NSMutableArray *amMeds;
    NSMutableArray *pmMeds;
    NSMutableArray *header;
    
    DBResultSet *missedMeds;
    
    NSArray *medsArray;
    
    MenuController *sideBar;
    
    NSDate *current;
    NSDate *futureDate;
    
    BOOL future;
    BOOL pushed;
    
    ComplianceAnalyzer *compAnalyzer;
    
    UIView *completedView;
}

@property (nonatomic, strong) UITableView *medsView;


- (void)setupSqlDefaults:(NSDate*)date;
- (void)setupTodayArrays:(NSDate *)date;
- (void)setupMeds;

- (void)setupCompAnalyzer;
- (void)setupTabBar;
- (void)setupCalendar;
- (void)setupEmptyStateWithImage:(NSString*)image AndText:(NSString*)text AndSubText:(NSString*)subText;
- (void)removeEmptyState;

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

- (NSMutableArray*)createTodayMedsArray:(NSMutableArray*)meds;

- (void)addTutorial;

@end

