//
//  TodayViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "TodayViewController.h"
#import "MedsCell.h"
#import "InfoViewController.h"
#import "Medication.h"
#import "MissedViewController.h"
#import <QuartzCore/QuartzCore.h>




@interface TodayViewController ()

@end

#define TabBarColor [UIColor colorWithRed:195/255.0 green:76/255.0 blue:60/255.0 alpha:1.0]
#define TabBarBorderColor [UIColor colorWithRed:195/255.0 green:76/255.0 blue:60/255.0 alpha:1.0].CGColor
#define TabBarBorderFrame CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.5f)

@implementation TodayViewController

#pragma mark - Lifecycle
-(void)viewDidLoad {
    [super viewDidLoad];
}

//Methods called in viewDidAppear so that the views are refreshed
-(void)viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appReturnsActive) name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    pushed = NO;
    current = [NSDate date];
    future = NO;
    futureDate = current;
    [self setupMeds];
    [self setupViews];
}


//Move the table back up when the view disappears
- (void) viewWillDisappear:(BOOL)animated {
    [self moveTableUp];
    [super viewWillDisappear:animated];
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setup Meds
//Meds setup method - Looks at current date selected and determines if its today or a future date
- (void)setupMeds{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"Date"];
    
    if(!future){
        //First time setup
        if(!date){
            [self setupSqlDefaults:current];
        } else if ([Constants compareDate:current withOtherdate:date]){
            [self setupTodayArrays:current];
        } else {
            [self setupSqlDefaults:current];
        }
    } else {
        [self setupSqlDefaults:futureDate];
    }
}


//Method called when a new day's meds are setup. Sql call takes data from the meds table and puts into the "today_meds" table
- (void)setupSqlDefaults:(NSDate*)date{
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayOfWeek = [dateFormatter stringFromDate:date];
    
    NSString *query = [NSString stringWithFormat: @"select med_name, chem_name, dosage, time, ampm, type from meds where %@ = 1 and ampm = 'AM' and completed = 0 order by time",dayOfWeek];
    
    NSArray *temp = [self.dbManager loadDataFromDB:query];
    amMeds = [self setDataInArray:temp andToday:NO];
    
    query = [NSString stringWithFormat: @"select med_name, chem_name, dosage, time, ampm, type from meds where %@ = 1 and ampm = 'PM' and completed = 0 order by time",dayOfWeek];
    
    
    temp = [self.dbManager loadDataFromDB:query];
    pmMeds = [self setDataInArray:temp andToday:NO];
    
    if(!future){
        [[NSUserDefaults standardUserDefaults] setObject:current forKey:@"Date"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Clear Today_Meds and load it with new data
        query = [NSString stringWithFormat: @"delete from today_meds"];
        [self.dbManager executeQuery:query];
        
        
        //Store stuff in today's table
        for (int i = 0; i < [amMeds count]; i ++){
            Medication *med = [amMeds objectAtIndex:i];
            //Need to change the model a bit
            query = [NSString stringWithFormat: @"insert into today_meds(med_name, chem_name, dosage, time, type, ampm, completed) values ('%@', '%@', '%@', %d, '%@', '%@', 0)",med.medName, med.chemName, med.dosage, med.actualTime, med.type, med.amPm];
            [self.dbManager executeQuery:query];
        }
        
        for (int i = 0; i < [pmMeds count]; i ++){
            Medication *med = [pmMeds objectAtIndex:i];
            //Need to change the model a bit
            query = [NSString stringWithFormat: @"insert into today_meds(med_name, chem_name, dosage, time, type, ampm, completed) values ('%@', '%@', '%@', %d, '%@', '%@', 0)",med.medName, med.chemName, med.dosage, med.actualTime, med.type, med.amPm];
            [self.dbManager executeQuery:query];
        }
        
        [self setupTodayArrays:date];
        
    } else {
        
        header = [[NSMutableArray alloc]init];
        if([amMeds count] == 0 && [pmMeds count] == 0){
            
        } else if([amMeds count] == 0){
            [header addObject:@"PM"];
        } else if ([pmMeds count] == 0){
            [header addObject:@"AM"];
        } else {
            [header addObject:@"AM"];
            [header addObject:@"PM"];
        }
        [self.medsView reloadData];
    }
}


//Method called to setup amMeds and pmMeds arrays from today_meds table
- (void)setupTodayArrays:(NSDate *)date {
    header = [[NSMutableArray alloc]init];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
    
    [amMeds removeAllObjects];
    [pmMeds removeAllObjects];
    
    missedMeds = [[NSMutableArray alloc] init];
    
    NSInteger hour;
    if(!future){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
        hour= [components hour];
    }
    else {
        hour = 0;
    }
    
    //Get am and pm meds from today's sql table
    NSString *query = [NSString stringWithFormat: @"select rowid, med_name, chem_name, dosage, time, ampm, completed from today_meds where  time >= %ld and ampm = 'AM' order by time", (long)hour - 1];
    NSArray *temp = [self.dbManager loadDataFromDB:query];
    amMeds = [self setDataInArray:temp andToday:YES];
    
    query = [NSString stringWithFormat: @"select rowid, med_name, chem_name, dosage, time, ampm, completed from today_meds where time >= %ld and ampm = 'PM' order by time", (long)hour - 1];
    temp = [self.dbManager loadDataFromDB:query];
    pmMeds = [self setDataInArray:temp andToday:YES];
    
    //First lets see if there are any missed meds today
    if([Constants compareDate:[NSDate date] withOtherdate:date]){
        NSString *query = [NSString stringWithFormat: @"select rowid, med_name, chem_name, dosage, time, ampm, completed from today_meds where  time < %d and completed = 0 order by time", (int)hour - 1];
        NSArray *temp = [self.dbManager loadDataFromDB:query];
        missedMeds = [self setDataInArray:temp andToday:YES];
        
        if([missedMeds count] > 0){
            //Launch missed meds view
            MissedViewController *missedVC = [[MissedViewController alloc] initWithMeds:missedMeds
                                                                                andHour:(int)hour-1];
            
            [self.navigationController presentViewController:missedVC
                                                    animated:NO
                                                  completion:nil];
        }
    }
    
    if([amMeds count] == 0 && [pmMeds count] == 0){
        
    } else if([amMeds count] == 0){
        [header addObject:@"PM"];
        [self.medsView reloadData];
    } else if ([pmMeds count] == 0){
        [header addObject:@"AM"];
        [self.medsView reloadData];
    } else {
        [header addObject:@"AM"];
        [header addObject:@"PM"];
        [self.medsView reloadData];
    }
}


//Method used for converting SQL results into an array
- (NSMutableArray *)setDataInArray:(NSArray *)temp andToday:(BOOL)today{
    NSMutableArray *tempMutable = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [temp count]; i++){
        NSString *medName = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"med_name"]];
        
        NSString *chemName = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"chem_name"]];
        
        NSString *dosage = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"dosage"]];
        
        NSString *amPm = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"ampm"]];
        
        //   NSString *type = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"type"]];
        NSString *subName = [chemName stringByAppendingString:@" - "];
        subName = [subName stringByAppendingString:dosage];
        
        Medication *med = [[Medication alloc]initWithName:medName andChemName:chemName];
        NSString *tempTime = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"time"]];
        
        float actualTime = [tempTime floatValue];
        med.actualTime = actualTime;
        
        med.subName = subName;
        med.dosage = dosage;
        med.amPm = amPm;
        //     med.type = type;
        if(actualTime > 12.5){
            actualTime -= 12;
        }
        
        NSString *time = [NSString stringWithFormat:@"%d",(int)actualTime];
        if(actualTime == (int) actualTime){
            time = [time stringByAppendingString:@":00"];
        } else {
            time = [time stringByAppendingString:@":30"];
        }
        
        [med setTime:time];
        
        //If its today we need to get two more rows!
        if(today){
            NSString *rowid = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"rowid"]];
            
            NSString *completed = [[temp objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"completed"]];
            med.med_id = [rowid intValue];
            
            if([completed intValue] == 1){
                med.completed = YES;
            } else {
                med.completed = NO;
            }
            
        }
        
        [tempMutable addObject:med];
    }
    
    return tempMutable;
}


#pragma mark - Setup Views
//Method called to setup views
- (void)setupViews{
    //Remove all subviews first
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    
    compAnalyzer = [[ComplianceAnalyzer alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    [self.view addSubview:compAnalyzer];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setFrame:CGRectMake(0, 0, [Constants window_width], [Constants window_height])];
//    if([amMeds count] == 0 && [pmMeds count] == 0 && [Constants compareDate:[NSDate date] withOtherdate:futureDate]){
//        UIImageView *completedImage = [[UIImageView alloc] initWithFrame:CGRectMake(([Constants window_width] - 300)/2, 50, 300, 311)];
//        [completedImage setImage:[UIImage imageNamed:@"completed"]];
//        UIView *bgImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Constants window_width], [Constants window_height])];
//        [bgImage setBackgroundColor:[UIColor whiteColor]];
//        [bgImage addSubview:completedImage];
//        [self.view addSubview:bgImage];
//        
//    }
//    else if([amMeds count] == 0 && [pmMeds count] == 0){
//        
//    }
//    else {
    self.medsView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [Constants window_width], self.navigationController.view.frame.size.height - 44)];
    
    UITapGestureRecognizer *singleFingerTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.medsView addGestureRecognizer:singleFingerTap];
    
    [self.medsView setDataSource:self];
    [self.medsView setDelegate:self];
    
    [self.medsView setBackgroundColor:[UIColor whiteColor]];
    [self.medsView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.medsView setSeparatorInset:UIEdgeInsetsZero];
    
    [self.view addSubview:self.medsView];
//    }
    [self setupTabBar];
    [self setupNavBar];
    [self setupCalendar];
}


//Method called to setup tabbar
- (void)setupTabBar{
    [self.tabBarController.tabBar setTintColor:TabBarColor];
    [self.tabBarController.tabBar setBackgroundColor:TabBarColor];
    CALayer *topBorder = [CALayer layer];
    [topBorder setFrame:TabBarBorderFrame];
    [topBorder setBackgroundColor:TabBarBorderColor];
    [self.tabBarController.tabBar.layer addSublayer:topBorder];
    
    [self.tabBarController.tabBar setClipsToBounds:YES];
}


//Method called to setup navbar
- (void)setupNavBar{
    
    [Constants setupNavbar:self];
    
    [self.navigationItem setTitle:@"Daily Dose"];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *calendarButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(showMenu)];
    [calendarButton setImage:[UIImage imageNamed:@"CalendarIcon"]];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName ,nil];
    [calendarButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:calendarButton];
    
    UIBarButtonItem *personButton = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(showCompliance)];
    [personButton setImage:[UIImage imageNamed:@"personIcon"]];
    attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName ,nil];
    [personButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:personButton];
}


//Method used to setup calendar
- (void)setupCalendar{
    sideBar = [[MenuController alloc] initWithDate:[NSDate date]
                                    andCurrentDate:current
                                           andView:self.navigationController.view andVC:self];
    sideBar.delegate = self;
}


#pragma mark - Table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [header count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if([[header objectAtIndex:section]  isEqual: @"AM"]){
        return [amMeds count];
    } else {
        return [pmMeds count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MedsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[MedsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //cell.reuseIdentifier = @"cell";
    }
    if([Constants compareDate:current withOtherdate:futureDate]){
        [cell setPannable];
    } else {
        [cell removePannable];
    }
    
    [cell->info addTarget:self action:@selector(loadInfo:) forControlEvents:UIControlEventTouchUpInside];
    [cell->postpone addTarget:self action:@selector(delay:) forControlEvents:UIControlEventTouchUpInside];
    [cell->undo addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
    
    Medication * med;
    
    // set the text
    if([[header objectAtIndex:indexPath.section]  isEqual: @"AM"]){
        med = [amMeds objectAtIndex:indexPath.row];
    } else {
        med = [pmMeds objectAtIndex:indexPath.row];
    }
    
    [cell setMed:med];
    
    if(med.completed){
        [cell uiComplete];
    } else {
        [cell uiUndo];
    }
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Constants window_height]/8;
}


//Setup AM & PM headers
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, self.navigationController.view.frame.size.height/28.4)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.frame.size.width, self.navigationController.view.frame.size.height/28.4 - 4)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    
    if ([[header objectAtIndex:section] isEqual: @"AM"]){
        [label setText:@"AM"];
    } else {
        [label setText:@"PM"];
    }
    
    [label setTextColor:[UIColor whiteColor]];
    [view addSubview:label];
    [view setBackgroundColor:[Constants getNavBarColor]];
    
    return view;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Constants window_width], 500)];
    [footer setBackgroundColor:[UIColor whiteColor]];
    
    return footer;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if([[header objectAtIndex:section] isEqual: @"AM"]){
        return 0.0f;
    }
    
    return 70.0f;
}


#pragma mark - Menu Delegate
- (void)menuButtonClicked:(int)index{
    futureDate = [[NSDate date] dateByAddingTimeInterval: + index * 86400.0];
    if(index == 0){
        future = NO;
    } else {
        future = YES;
    }
    
    [self setupMeds];
    //[self setupViews];
}


#pragma mark - Move Table View
- (void)showCompliance{
    if(pushed){
        [self moveTableUp];
        pushed = NO;
    } else {
        [self moveTableDown];
        pushed = YES;
    }
}


- (void)moveTableUp{
    [UIView animateWithDuration:0.7 animations:^(){
        [self.medsView setFrame:CGRectMake(0, 0, [Constants window_width], self.navigationController.view.frame.size.height - 44)];
        //[self.medsView reloadData];
    }];
    [self.medsView setScrollEnabled:YES];
    
}


- (void)moveTableDown{
    [compAnalyzer clearViews];
    [UIView animateWithDuration:0.7 animations:^(){
        //297 for i5
        [self.medsView setFrame:CGRectMake(0, 350, [Constants window_width], self.medsView.frame.size.height)];
        //[self.medsView reloadData];
    }];
    [compAnalyzer animateViews];
    [self.medsView setScrollEnabled:NO];
    // [self.medsView setBackgroundColor:[UIColor whiteColor]];
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if(pushed){
        [self moveTableUp];
        pushed = NO;
    }
    //Do stuff here...
}


#pragma mark - IBActions
//Method called to load info page
- (IBAction)loadInfo:(id)sender{
    //Get Button Position to detect which med to send
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.medsView];
    NSIndexPath *indexPath = [self.medsView indexPathForRowAtPoint:buttonPosition];
    MedsCell *cell = (MedsCell*)[self.medsView cellForRowAtIndexPath:indexPath];
    
    Medication *med;
    
    if([[header objectAtIndex:indexPath.section]  isEqual: @"AM"]){
        med = [amMeds objectAtIndex:indexPath.row];
    } else {
        med = [pmMeds objectAtIndex:indexPath.row];
    }
    
    InfoViewController *infoVC = [[InfoViewController alloc] initWithMed:med];
    [self.navigationController presentViewController:infoVC
                                            animated:YES
                                          completion:^{[cell closeCell];}];
}


//Method called to delay med
- (IBAction)delay:(id)sender{
    //Get Button Position to detect which med to send
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.medsView];
    NSIndexPath *indexPath = [self.medsView indexPathForRowAtPoint:buttonPosition];
    
    MedsCell *cell = (MedsCell*)[self.medsView cellForRowAtIndexPath:indexPath];
    [cell closeCell];
    
    Medication *med;
    
    if([[header objectAtIndex:indexPath.section]  isEqual: @"AM"]){
        med = [amMeds objectAtIndex:indexPath.row];
    } else {
        med = [pmMeds objectAtIndex:indexPath.row];
    }
    
    if (med.actualTime < 23){
        NSString *query;
        //Convert to PM if its past 12!
        if(med.actualTime >= 11 && [med.amPm  isEqual: @"AM"]){
            query = [NSString stringWithFormat: @"update today_meds set time = %d, ampm ='PM' where rowid = %f", med.actualTime + 1, med.med_id];
        } else {
            query = [NSString stringWithFormat: @"update today_meds set time = %d where rowid = %f", med.actualTime + 1, med.med_id];
        }
        
        [self.dbManager executeQuery:query];
        
//        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Delay"
//                                                              action:@"Regular"
//                                                               label:med.medName
//                                                               value:[NSNumber numberWithInt:med.actualTime]] build]];
    }

    [self setupTodayArrays:current];
    [self.medsView reloadData];
}


//Method called to undo "taken" med
- (IBAction)undo:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.medsView];
    NSIndexPath *indexPath = [self.medsView indexPathForRowAtPoint:buttonPosition];
    
    MedsCell *cell = (MedsCell*)[self.medsView cellForRowAtIndexPath:indexPath];
    
    Medication *med;
    
    if([[header objectAtIndex:indexPath.section]  isEqual: @"AM"]){
        med = [amMeds objectAtIndex:indexPath.row];
    }
    else {
        med = [pmMeds objectAtIndex:indexPath.row];
    }
    
    if (med.completed){
        //Complete med
        [cell closeCell];
        [cell undo];
        
//        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Undo"
//                                                              action:@"Regular"
//                                                               label:med.medName
//                                                               value:[NSNumber numberWithInt:med.actualTime]] build]];

    } else {
        //Incomplete med
        [cell closeCell];
        [cell complete];
        
//        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Taken"
//                                                              action:@"Regular"
//                                                               label:med.medName
//                                                               value:[NSNumber numberWithInt:med.actualTime]] build]];

    }
}

#pragma mark - UI Helpers
- (void)showMenu{
    [sideBar showMenu];
}


// know the current state
- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Refresh from BG
- (void)appReturnsActive{
    current = [NSDate date];
    future = NO;
    futureDate = current;
    
    [self setupMeds];
    [self setupViews];
}


@end
