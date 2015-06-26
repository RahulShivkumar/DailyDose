//
//  TodayViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuController.h"
#import "DBManager.h"
#import "Constants.h"

@interface TodayViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MenuControllerDelegate>{
    NSMutableArray *amMeds;
    NSMutableArray *pmMeds;
    NSMutableArray *futureAmMeds;
    NSMutableArray *futurePmMeds;
    NSMutableArray *header;
    NSMutableArray *missedMeds;
    
    NSArray *medsArray;
    
    MenuController *sideBar;
    
    NSDate *current;
    NSDate *futureDate;
    
    BOOL future;
    BOOL pushed;
}

@property (nonatomic, strong) UITableView *medsView;
@property (nonatomic, strong) DBManager *dbManager;

- (void)setupSqlDefaults:(NSDate*)date;
- (void)setupTodayArrays:(NSDate *)date;
- (NSMutableArray *)setDataInArray:(NSArray *)temp andToday:(BOOL)today;
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

@end

