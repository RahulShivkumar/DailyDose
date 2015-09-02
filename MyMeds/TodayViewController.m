// 
//   TodayViewController.m
//   MyMeds
// 
//   Created by Rahul Shivkumar on 1/26/15.
//   Copyright (c) 2015 test. All rights reserved.
// 

#import "TodayViewController.h"




@interface TodayViewController ()

@end

#define TabBarColor [UIColor colorWithRed:195/255.0 green:76/255.0 blue:60/255.0 alpha:1.0]
#define kMainColor [UIColor colorWithRed:229/255.0 green:98/255.0 blue:92/255.0 alpha:1.0]
#define TabBarBorderFrame CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 0.5f)

#define kBGColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]

#define IS_NO_MEDS_TODAY [amMeds count] == 0 && [pmMeds count] == 0 && !future
#define IS_NO_MEDS_FUTURE_DAY [amMeds count] == 0 && [pmMeds count] == 0

@implementation TodayViewController

#pragma mark - Test Methods
- (void)clearData{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[[Medication query] fetch] removeAll];
    [[[TodayMedication query] fetch] removeAll];
    [[[CoreMedication query] fetch] removeAll];
    [[[Event query] fetch] removeAll];
}


- (void)checkNotifications {
    NSLog(@"%@", @"Notifications Check");
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    NSLog(@"%@", [NSDate date]);
    for (int i = 0; i < [eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *identifier = [userInfoCurrent objectForKey:@"uid"];
        NSLog(@"Identifier : %@", identifier);
        NSLog(@"FireDate : %@", oneEvent.fireDate);
    }
}



#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}


// Methods called in viewDidAppear so that the views are refreshed
-(void)viewDidAppear:(BOOL)animated{
    
    [self addTutorial];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appReturnsActive) name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    pushed = NO;
    current = [NSDate date];
    future = NO;
    futureDate = current;
    
    //[self clearData];
    //[self checkNotifications];
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    
    [self setupTabBar];
    [self setupNavBar];
    [self setupCompAnalyzer];
    [self setupCalendar];
    [self addTutorial];
    [self setupTableView];
    [self setupMeds];
    
}


// Move the table back up when the view disappears
- (void) viewWillDisappear:(BOOL)animated {
    [self moveTableUp];
    [super viewWillDisappear:animated];
}


-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //  Dispose of any resources that can be recreated.
}


#pragma mark - Setup Meds
// Meds setup method - Looks at current date selected and determines if its today or a future date
- (void)setupMeds{
    
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"date"];
    
    if (date == nil){
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"date"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    BOOL medsExist = (BOOL)[[NSUserDefaults standardUserDefaults] objectForKey:@"medadded"];
    if(!future){
        // First time setup
        if(!medsExist){
            [self setupEmptyStateWithImage:@"nomeds" AndText:@"No Meds Yet." AndSubText:@"Click the 'meds' tab to add meds"];
        } else if ([Constants compareDate:current withOtherdate:date]){
            [self setupTodayArrays:current];
        } else {
            [EventLogger logMissedMedsFromDate:date toDate:current];
            [self setupSqlDefaults:current];
        }
    } else {
        [self setupSqlDefaults:futureDate];
    }
}


// Method called when a new day's meds are setup. Sql call takes data from the meds table and puts into the "today_meds" table
- (void)setupSqlDefaults:(NSDate*)date{
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"date"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *dayOfWeek = [Constants getCurrentDayFromDate:date];

     // ----------------------------------------------------
    // TO DO - Check for expired
     // ----------------------------------------------------
    NSString *query = [NSString stringWithFormat:@"%@ = 1 and time < 12", [dayOfWeek lowercaseString]];
    NSString *query2 = [NSString stringWithFormat:@"%@ = 1 and time >= 12", [dayOfWeek lowercaseString]];
    
    amMeds = [NSMutableArray arrayWithArray:[[[[Medication query] where:query] orderBy:@"time" ] fetch]];
    pmMeds = [NSMutableArray arrayWithArray:[[[[Medication query] where:query2] orderBy:@"time"] fetch]];
    
    
    if(!future){
        
        // Clear Today_Meds and load it with new data
        [[[TodayMedication query] fetch] removeAll];
        
        // Store stuff in today's table
        for (Medication *m in amMeds){
            TodayMedication *tm = [TodayMedication new];
            [tm createFromMedication:m];
            [tm commit];
        }
        
        for (Medication *m in pmMeds){
            TodayMedication *tm = [TodayMedication new];
            [tm createFromMedication:m];
            [tm commit];
        }
        
        [self setupTodayArrays:date];
        
        
    } else {
        // Convert all the meds to today meds
        amMeds = [self createTodayMedsArray:amMeds];
        pmMeds = [self createTodayMedsArray:pmMeds];
        
        header = [[NSMutableArray alloc] init];
        
        
        if([amMeds count] == 0 && [pmMeds count] == 0){
            BOOL medExists = (BOOL)[[NSUserDefaults standardUserDefaults] objectForKey:@"medadded"];
            if (!medExists){
                [self setupEmptyStateWithImage:@"nomeds" AndText:@"No Meds Yet." AndSubText:@"Click the 'meds' tab to add meds"];
            }
            else if(IS_NO_MEDS_TODAY){
                [self setupEmptyStateWithImage:@"completed" AndText:@"Completed All Meds For Today!" AndSubText:@""];
            } else if(IS_NO_MEDS_FUTURE_DAY){
                [self setupEmptyStateWithImage:@"nomedsday" AndText:@"No Meds For The Day!" AndSubText:@""];
            }
        } else if([amMeds count] == 0){
            [header addObject:@"PM"];
            [self setupTableView];
        } else if ([pmMeds count] == 0){
            [header addObject:@"AM"];
            [self setupTableView];
        } else {
            [header addObject:@"AM"];
            [header addObject:@"PM"];
            [self setupTableView];
        }
    }
}


// Method called to setup amMeds and pmMeds arrays from today_meds table
- (void)setupTodayArrays:(NSDate *)date {
    header = [[NSMutableArray alloc] init];
    
    NSInteger hour = [Constants getCurrentHour];
    // Get am and pm meds from today's sql table
    NSString *query = [NSString stringWithFormat:@"time > %f and time < 12 and taken = %i", (float)hour -1, NO];
    amMeds = [NSMutableArray arrayWithArray:[[[[TodayMedication query] where:query] orderBy:@"time"] fetch]];
    query = [NSString stringWithFormat:@"time > %f and time >= 12 and taken = %i", (float)hour - 1, NO];
    pmMeds = [NSMutableArray arrayWithArray:[[[[TodayMedication query] where:query] orderBy:@"time"] fetch]];
    
    // First lets see if there are any missed meds today
    if(!future){
       query = [NSString stringWithFormat:@"time < %d and taken = 0", (int)hour - 1];
        missedMeds = [[[[TodayMedication query] where:query] orderBy:@"time"] fetch];
        
        if([missedMeds count] > 0){
            // Launch missed meds view
            MissedViewController *missedVC = [[MissedViewController alloc] initWithMeds:missedMeds
                                                                                andHour:(long)hour-1];
            
            [self.navigationController presentViewController:missedVC
                                                    animated:NO
                                                  completion:nil];
        }
    }
    
    for (Medication *m in amMeds){
        TodayMedication *tm = [TodayMedication new];
        [tm createFromMedication:m];
    }
    if([amMeds count] == 0 && [pmMeds count] == 0){
        if(IS_NO_MEDS_TODAY){
            [self setupEmptyStateWithImage:@"completed" AndText:@"Completed All Meds For Today!" AndSubText:@""];
        }
    } else if([amMeds count] == 0){
        [self removeEmptyState];
        [header addObject:@"PM"];
        [self setupTableView];
    } else if ([pmMeds count] == 0){
        [self removeEmptyState];
        [header addObject:@"AM"];
        [self setupTableView];
    } else {
        [self removeEmptyState];
        [header addObject:@"AM"];
        [header addObject:@"PM"];
        [self setupTableView];
    }
}



#pragma mark - Setup Views
// Method called to setup views
- (void)setupCompAnalyzer{
    compAnalyzer = [[ComplianceAnalyzer alloc] initWithFrame:CGRectMake(0, 0, [Constants window_width], [Constants window_width])];
    [compAnalyzer setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:compAnalyzer];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setFrame:CGRectMake(0, 0, [Constants window_width], [Constants window_height])];
}

- (void)setupTableView{
    //[self.medsView removeFromSuperview];
    [self removeEmptyState];
    if (self.medsView == nil) {
        self.medsView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [Constants window_width], [Constants window_height] - 24)];
        UITapGestureRecognizer *singleFingerTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.medsView addGestureRecognizer:singleFingerTap];
        
        [self.medsView setDataSource:self];
        [self.medsView setDelegate:self];
        
        [self.medsView setBackgroundColor:[UIColor whiteColor]];
        [self.medsView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self.medsView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if (![self.medsView isDescendantOfView:self.view]){
        [self.view addSubview:self.medsView];
    }
    
//    NSLog(@"LIST OF SUBVIEW ----");
//    for (UIView *v in self.view.subviews){
//        NSLog(@"Subviews :%@", v);
//    }

    [self.medsView reloadData];
}

// Method called to setup tabbar
- (void)setupTabBar{
    [self.tabBarController.tabBar setTintColor:TabBarColor];
    [self.tabBarController.tabBar setTintColor:kMainColor];
    CALayer *topBorder = [CALayer layer];
    [topBorder setFrame:TabBarBorderFrame];
    [topBorder setBackgroundColor:kMainColor.CGColor];
    [self.tabBarController.tabBar.layer addSublayer:topBorder];
    
    [self.tabBarController.tabBar setClipsToBounds:YES];
}


// Method called to setup navbar
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
    [personButton setImage:[UIImage imageNamed:@"circle"]];
    attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName ,nil];
    [personButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [self.navigationItem setLeftBarButtonItem:personButton];
}


// Method used to setup calendar
- (void)setupCalendar{
    sideBar = [[MenuController alloc] initWithDate:[NSDate date]
                                    andCurrentDate:current
                                           andView:self.navigationController.view andVC:self];
    sideBar.delegate = self;
}


// Method used to setup empty states
- (void)setupEmptyStateWithImage:(NSString*)image AndText:(NSString*)text AndSubText:(NSString*)subText {
    //[self.medsView removeFromSuperview];
    [completedView removeFromSuperview];
    
    if (completedView == nil) {
        completedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.navigationController.view.frame.size.height - 44)];
        [completedView setBackgroundColor:kBGColor];
        
        UIImageView *completedImage = [[UIImageView alloc] initWithFrame:CGRectMake([Constants window_width]/4, 110, [Constants window_width]/2, [Constants window_width]/2)];
        [completedImage setImage:[UIImage imageNamed:image]];
        UILabel *completedText = [[UILabel alloc] initWithFrame:CGRectMake(5, 120 + [Constants window_width]/2, [Constants window_width] - 10, 30)];
        [completedText setTextAlignment:NSTextAlignmentCenter];
        [completedText setText:text];
        [completedText setTextColor:[UIColor lightGrayColor]];
        [completedText setFont:[UIFont systemFontOfSize:20]];
        
        UILabel *completedText2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 150 + [Constants window_width]/2, [Constants window_width], 30)];
        [completedText2 setTextAlignment:NSTextAlignmentCenter];
        [completedText2 setText:subText];
        [completedText2 setTextColor:[UIColor lightGrayColor]];
        [completedText2 setFont:[UIFont systemFontOfSize:20]];
        
        [completedView addSubview:completedText];
        [completedView addSubview:completedText2];
        [completedView addSubview:completedImage];
    }
    
    if (![completedView isDescendantOfView:self.view]) {
        [self.view addSubview:completedView];
    }
}


- (void)removeEmptyState {
    [completedView removeFromSuperview];
}


#pragma mark - Table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //  Return the number of sections.
    return [header count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //  Return the number of rows in the section.
    if([[header objectAtIndex:section]  isEqual: @"AM"]){
        return [amMeds count];
    } else {
        return [pmMeds count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MedsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setDelegate:self];
    
    
    if (cell == nil) {
        cell = [[MedsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setDelegate:self];
        // cell.reuseIdentifier = @"cell";
    }
    
    [cell closeCell];
    
    if(!future){
        [cell setPannable];
    } else {
        [cell removePannable];
    }
    
    [cell->info addTarget:self action:@selector(loadInfo:) forControlEvents:UIControlEventTouchUpInside];
    [cell->postpone addTarget:self action:@selector(delay:) forControlEvents:UIControlEventTouchUpInside];
    [cell->undo addTarget:self action:@selector(undo:) forControlEvents:UIControlEventTouchUpInside];
    
    TodayMedication * med;
    
    //  set the text
    if ([header count] > 0) {
        if([[header objectAtIndex:indexPath.section]  isEqual: @"AM"]){
            med = [amMeds objectAtIndex:indexPath.row];
        } else {
            med = [pmMeds objectAtIndex:indexPath.row];
        }
    }
    
    [cell setMed:med];
    
    if (!future){
        if(med.taken){
            [cell uiComplete];
        }
//        } else {
//            [cell uiUndo];
//        }
    } else {
        [cell uiUndo];
    }
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Constants window_height]/8;
}


// Setup AM & PM headers
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, self.navigationController.view.frame.size.height/28.4)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, tableView.frame.size.width, self.navigationController.view.frame.size.height/28.4 - 4)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
    
    if ([header count] > 0) {
        if ([[header objectAtIndex:section] isEqual: @"AM"]){
            [label setText:@"AM"];
        } else {
            [label setText:@"PM"];
        }
    }
    
    [label setTextColor:[UIColor whiteColor]];
    [view addSubview:label];
    [view setBackgroundColor:[Constants getNavBarColor]];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 29, view.frame.size.width, 0.5)];
    [separator setBackgroundColor:[UIColor darkGrayColor]];
    [view addSubview:separator];
    
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
    return 30;
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
    [self.medsView reloadData];
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
        if([self.medsView isDescendantOfView:self.view]){
            [self.medsView setFrame:CGRectMake(0, 0, [Constants window_width], self.navigationController.view.frame.size.height - 44)];
        }
         if ([completedView isDescendantOfView:self.view]){
            [completedView setFrame:CGRectMake(0, 0, [Constants window_width], self.navigationController.view.frame.size.height - 44)];
         }
        // [self.medsView reloadData];
    }];
    [self.medsView setScrollEnabled:YES];
    
}


- (void)moveTableDown{
    [compAnalyzer clearViews];
    [UIView animateWithDuration:0.7 animations:^(){
        // 297 for i5
        if([self.medsView isDescendantOfView:self.view]){
            [self.medsView setFrame:CGRectMake(0, 350, [Constants window_width], self.medsView.frame.size.height)];
        }
        if ([completedView isDescendantOfView:self.view]){
            [completedView setFrame:CGRectMake(0, 350, [Constants window_width], self.navigationController.view.frame.size.height - 44)];
        }
        // [self.medsView reloadData];
    }];
    [compAnalyzer animateViews];
    [self.medsView setScrollEnabled:NO];
    //  [self.medsView setBackgroundColor:[UIColor whiteColor]];
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if(pushed){
        [self moveTableUp];
        pushed = NO;
    }
    // Do stuff here...
}


#pragma mark - Strike Delegate

- (void)strikeDelegate:(id)sender{
    
    MedsCell *medCell = (MedsCell *)sender;
    NSIndexPath *indexPath = [self.medsView indexPathForCell:medCell];
    Medication *med;
    
    
    if (indexPath.section == 0 && [amMeds count] > 0){
        med = [amMeds objectAtIndex:indexPath.row];
        [amMeds removeObjectAtIndex:indexPath.row];
    } else {
        med = [pmMeds objectAtIndex:indexPath.row];
        [pmMeds removeObjectAtIndex:indexPath.row];
    }
    
    NSString *query = [NSString stringWithFormat:@"coreMed = %@ and time = %f", med.coreMed, med.time];
  
    [[[[TodayMedication query] where:query] fetch] removeAll];
    [EventLogger logAction:@"taken" andMedication:med.coreMed andTime:med.time];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self.medsView beginUpdates];
        
        [self.medsView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                             withRowAnimation:UITableViewRowAnimationFade];
        
        [self.medsView endUpdates];
        
    });
    
    if ([amMeds count] == 0 && [pmMeds count] == 0) {
        
        //This is not a good bit of code... This should be changed...
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self setupEmptyStateWithImage:@"completed" AndText:@"Completed All Meds For Today!" AndSubText:@""];
        });
        
        
    }
}


#pragma mark - IBActions
// Method called to load info page
- (IBAction)loadInfo:(id)sender{
    // Get Button Position to detect which med to send
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.medsView];
    NSIndexPath *indexPath = [self.medsView indexPathForRowAtPoint:buttonPosition];
    MedsCell *cell = (MedsCell*)[self.medsView cellForRowAtIndexPath:indexPath];
    [cell setDelegate:self];
    
    Medication *med;
    
    if([[header objectAtIndex:indexPath.section]  isEqual: @"AM"]){
        med = [amMeds objectAtIndex:indexPath.row];
    } else {
        med = [pmMeds objectAtIndex:indexPath.row];
    }
    
    [EventLogger logAction:@"missed" andMedication:med.coreMed andTime:med.time];
    
    InfoViewController *infoVC = [[InfoViewController alloc] initWithMed:med.coreMed];
    [self.navigationController presentViewController:infoVC
                                            animated:YES
                                          completion:^{[cell closeCell];}];
}


//  Method called to delay med
- (IBAction)delay:(id)sender{
    // Get Button Position to detect which med to send
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
    
    if (med.time < 23){
        med.time += 1;
        [med commit];
        [EventLogger logAction:@"delayed" andMedication:med.coreMed andTime:med.time];
        
        [self setupTodayArrays:current];
        [self.medsView reloadData];
    } else{
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Cannot Delay!"
                                                          message:@"Delaying will send medication to the next day!"
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        [message show];
    }
    
  
}


//  Method called to undo "taken" med
- (IBAction)undo:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.medsView];
    NSIndexPath *indexPath = [self.medsView indexPathForRowAtPoint:buttonPosition];
    
    MedsCell *cell = (MedsCell*)[self.medsView cellForRowAtIndexPath:indexPath];
    
    TodayMedication *med;
    
    if([[header objectAtIndex:indexPath.section]  isEqual: @"AM"]){
        med = [amMeds objectAtIndex:indexPath.row];
    } else {
        med = [pmMeds objectAtIndex:indexPath.row];
    }
    
//    if (med.taken){
//        // Complete med
//        [cell closeCell];
//        [cell undo];
//
//    }
   // else {
        // Incomplete med
    [cell closeCell];
    [cell complete];
   // }
}

#pragma mark - UI Helpers
- (void)showMenu{
    if (pushed){
        [UIView animateWithDuration:0.3 animations:^(){
            [self moveTableUp];
            pushed = NO;
            // [self.medsView reloadData];
        }
                         completion:^(BOOL finished){
                             [sideBar showMenu];
                         }];
    } else {
        [sideBar showMenu];
    }
}


//  know the current state
- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Background methods
- (void)appReturnsActive{
    if (sideBar.isOpen){
        [sideBar dismissMenu];
    }
    
    [self setupMeds];
}



#pragma mark - Convert Meds to Today Meds
- (NSMutableArray*)createTodayMedsArray:(NSMutableArray*)meds{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (Medication *m in meds){
        TodayMedication *tm = [TodayMedication new];
        [tm createFromMedication:m];
        [temp addObject:tm];
    }
    // [meds removeAll];
    
    DBResultSet *newdDBRS = (DBResultSet*)[NSArray arrayWithArray:temp];
    return [NSMutableArray arrayWithArray: newdDBRS];
}

#pragma mark - Add Tutorial 

- (void)addTutorial {
    BOOL walkthrough = [[NSUserDefaults standardUserDefaults] boolForKey:@"walkthrough"];
    
    if (!walkthrough) {
        UIStoryboard *stb = [UIStoryboard storyboardWithName:@"Walkthrough" bundle:nil];
        RTWalkthroughViewController *walkthrough = [stb instantiateViewControllerWithIdentifier:@"walk"];
        
        RTWalkthroughPageViewController *pageOne = [stb instantiateViewControllerWithIdentifier:@"walk1"];
        RTWalkthroughPageViewController *pageTwo = [stb instantiateViewControllerWithIdentifier:@"walk2"];
        RTWalkthroughPageViewController *pageThree = [stb instantiateViewControllerWithIdentifier:@"walk3"];
        
        walkthrough.delegate = self;
        [walkthrough addViewController:pageOne];
        [walkthrough addViewController:pageTwo];
        [walkthrough addViewController:pageThree];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"walkthrough"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self presentViewController:walkthrough animated:YES completion:nil];
    }
}

- (void)walkthroughControllerDidClose:(RTWalkthroughViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
