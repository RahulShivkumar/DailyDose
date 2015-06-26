//
//  MissedViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 2/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "MissedViewController.h"


#define bgColor [UIColor colorWithRed:174/255.0 green:17/255.0 blue:20/255.0 alpha:1.0]
#define bgColor2 [UIColor colorWithRed:244/255.0 green:136/255.0 blue:159/255.0 alpha:1.0]
#define buttonFont [UIFont fontWithName:@"HelveticaNeue-Thin" size:18]

@interface MissedViewController ()

@end

@implementation MissedViewController

//Custom init method with meds and current hour
- (id)initWithMeds:(NSMutableArray*)missedMeds andHour:(int)hr{
    if (self = [super init]) {
        meds = missedMeds;
        hour = hr;
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Method called to setup views
- (void)setupViews{
    title = [[UILabel alloc]initWithFrame:CGRectMake(10, [Constants window_height]/6 - 40, [Constants window_width], 40)];
    [title setFont:[UIFont fontWithName:@"HelveticaNeue" size:30]];
    [title setText:@"Missed Medication:"];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[bgColor CGColor], (id)[bgColor2 CGColor], nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    self.medsView = [[UITableView alloc] init];
    [self.medsView setDataSource:self];
    [self.medsView setDelegate:self];
    [self.medsView registerClass:[MedsCell class] forCellReuseIdentifier:@"cell"];
    [self.medsView setBackgroundColor:[UIColor whiteColor]];
    [self.medsView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.medsView setSeparatorInset:UIEdgeInsetsZero];
    [self.medsView setSeparatorColor:[UIColor colorWithRed:204/255.0 green:46/255.0 blue:46/255.0 alpha:1.0]];
    
    if([meds count] <= 5){
        [self.medsView setFrame:CGRectMake(0, [Constants window_height]/6, [Constants window_width], [Constants window_height]/8 *[meds count])];
        [self.medsView setScrollEnabled:NO];
    } else {
        [self.medsView setFrame:CGRectMake(0, [Constants window_height]/6, [Constants window_width], [Constants window_height]/8 * 5)];
    }
    
    [self.view addSubview:self.medsView];
    
    taken = [[UIButton alloc] initWithFrame:CGRectMake(20, self.medsView.frame.origin.y + self.medsView.frame.size.height + 30, 70, 70)];
    [taken setImage:[UIImage imageNamed:@"taken"] forState:UIControlStateNormal];
    [taken addTarget:self action:@selector(taken:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:taken];
    
    UILabel *takenLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.medsView.frame.origin.y + self.medsView.frame.size.height + 110, 70, 20)];
    [takenLabel setTextColor:[UIColor whiteColor]];
    [takenLabel setFont:buttonFont];
    [takenLabel setText:@"Taken"];
    [takenLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:takenLabel];
    
    delay = [[UIButton alloc] initWithFrame:CGRectMake([Constants window_width]/2 - 35, self.medsView.frame.origin.y + self.medsView.frame.size.height + 30, 70, 70)];
    [delay setImage:[UIImage imageNamed:@"delay"] forState:UIControlStateNormal];
    [delay addTarget:self action:@selector(delay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delay];
    
    UILabel *delayLabel = [[UILabel alloc] initWithFrame:CGRectMake([Constants window_width]/2 - 35, self.medsView.frame.origin.y + self.medsView.frame.size.height + 110, 70, 20)];
    [delayLabel setTextColor:[UIColor whiteColor]];
    [delayLabel setFont:buttonFont];
    [delayLabel setText:@"Delay"];
    [delayLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:delayLabel];
    
    skip = [[UIButton alloc] initWithFrame:CGRectMake([Constants window_width] - 20- 70, self.medsView.frame.origin.y + self.medsView.frame.size.height + 30, 70, 70)];
    [skip setImage:[UIImage imageNamed:@"skip"] forState:UIControlStateNormal];
    [skip addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skip];
    
    UILabel *skipLabel = [[UILabel alloc] initWithFrame:CGRectMake([Constants window_width] - 20- 70, self.medsView.frame.origin.y + self.medsView.frame.size.height + 110, 70, 20)];
    [skipLabel setTextColor:[UIColor whiteColor]];
    [skipLabel setFont:buttonFont];
    [skipLabel setText:@"Skip"];
    [skipLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:skipLabel];
    
}


#pragma mark - Table view delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [meds count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MedsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell setDelegate:self];
    
    Medication *med = [meds objectAtIndex:indexPath.row];
    
    [cell->info addTarget:self action:@selector(loadInfo:) forControlEvents:UIControlEventTouchUpInside];
    [cell->postpone addTarget:self action:@selector(delaySingleMed:) forControlEvents:UIControlEventTouchUpInside];
    [cell->undo addTarget:self action:@selector(skipSingleMed:) forControlEvents:UIControlEventTouchUpInside];
    [cell->undo setTitle:@"Skip" forState:UIControlStateNormal];
    
    [cell setMed:med];
    [cell setPannable];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Constants window_height]/8;
}


#pragma mark - IBActions 
//Method called to mark all missed meds as taken
- (IBAction)taken:(id)sender{
    NSString *query = [NSString stringWithFormat: @"update today_meds set completed = 1 where time <= %d - 1", hour];
    [self.dbManager executeQuery:query];
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
    for (Medication *med in meds){
//        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        
//        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Taken"
//                                                              action:@"Missed"
//                                                               label:med.medName
//                                                               value:[NSNumber numberWithInt:med.actualTime]] build]];

    }
}
//Method called to delay all missed meds
- (IBAction)delay:(id)sender{
    NSString *amPm = @"AM";
    if(hour > 12){
        amPm = @"PM";
    }
    
    NSString *query = [NSString stringWithFormat: @"update today_meds set time = %d, ampm = %@  where time <= %d and completed = 0", hour + 2, amPm, hour];
    
    for (Medication *med in meds){
//        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        
//        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Delay"
//                                                              action:@"Missed"
//                                                               label:med.medName
//                                                               value:[NSNumber numberWithInt:med.actualTime]] build]];
    }
    
    [self.dbManager executeQuery:query];
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}


//Method called to skip all meds
- (IBAction)skip:(id)sender{
    //2 Used to show it is skipped
    NSString *query = [NSString stringWithFormat: @"update today_meds set completed = 2 where time <= %d and completed = 0", hour];
    [self.dbManager executeQuery:query];
    
    for (Medication *med in meds){
//        id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        
//        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Skip"
//                                                              action:@"Missed"
//                                                               label:med.medName
//                                                               value:[NSNumber numberWithInt:med.actualTime]] build]];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)loadInfo:(id)sender{
    //Get Button Position to detect which med to send
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.medsView];
    NSIndexPath *indexPath = [self.medsView indexPathForRowAtPoint:buttonPosition];
    MedsCell *cell = (MedsCell*)[self.medsView cellForRowAtIndexPath:indexPath];
   
    InfoViewController *infoVC = [[InfoViewController alloc] initWithMed:[meds objectAtIndex:indexPath.row]];
    [self presentViewController:infoVC
                       animated:YES
                     completion:^{[cell closeCell];}];
}


- (IBAction)delaySingleMed:(id)sender{
    //Get Button Position to detect which med to send
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.medsView];
    NSIndexPath *indexPath = [self.medsView indexPathForRowAtPoint:buttonPosition];
    MedsCell *cell = (MedsCell*)[self.medsView cellForRowAtIndexPath:indexPath];[cell closeCell];
    [cell closeCell];
    Medication *med = [meds objectAtIndex:indexPath.row];

    if (med.actualTime < 23){
        
        //Convert to PM if its past 12!
        NSString *amPm = @"AM";
        if(hour > 12){
            amPm = @"PM";
        }
        
        NSString *query = [NSString stringWithFormat: @"update today_meds set time = %d, ampm = %@  where rowid = %f and completed = 0", hour + 2, amPm, med.med_id];
        [self.dbManager executeQuery:query];
    }
    
//    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Delay"
//                                                          action:@"Missed"
//                                                           label:med.medName
//                                                           value:[NSNumber numberWithInt:med.actualTime]] build]];
    
    [meds removeObjectAtIndex:indexPath.row];
    
    [self.medsView beginUpdates];
    
    [self.medsView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                         withRowAnimation:UITableViewRowAnimationFade];
    
    [self.medsView endUpdates];
    
    [self checkCompleted];
}


- (IBAction)skipSingleMed:(id)sender{
    //Get Button Position to detect which med to send
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.medsView];
    NSIndexPath *indexPath = [self.medsView indexPathForRowAtPoint:buttonPosition];
    MedsCell *cell = (MedsCell*)[self.medsView cellForRowAtIndexPath:indexPath];
    [cell closeCell];
    
    Medication *med = [meds objectAtIndex:indexPath.row];
    
    NSString *query = [NSString stringWithFormat: @"update today_meds set completed = 2 where rowid = %f", med.med_id];
    [self.dbManager executeQuery:query];
    
    [meds removeObjectAtIndex:indexPath.row];
    
    [self.medsView beginUpdates];
    [self.medsView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [self.medsView endUpdates];
    
//    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Skip"
//                                                          action:@"Missed"
//                                                           label:med.medName
//                                                           value:[NSNumber numberWithInt:med.actualTime]] build]];

    [self checkCompleted];
    //TO-DO dismiss med from the screen
    // [self setupTodayArrays:current];
    //[self.medsView reloadData];
}


#pragma mark Strike Delegate
- (void)strikeDelegate:(id)sender{
    MedsCell *medCell = (MedsCell *)sender;
    NSIndexPath *indexPath = [self.medsView indexPathForCell:medCell];
    Medication *med = [meds objectAtIndex:indexPath.row];
    [meds removeObjectAtIndex:indexPath.row];

//    id <GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    
//    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Taken"
//                                                          action:@"Missed"
//                                                           label:med.medName
//                                                           value:[NSNumber numberWithInt:med.actualTime]] build]];
    
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //code to be executed on the main queue after delay
        [self.medsView beginUpdates];
        
        [self.medsView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                             withRowAnimation:UITableViewRowAnimationFade];
        
        [self.medsView endUpdates];
        [self checkCompleted];
    });

    

}


- (void)checkCompleted{
    if ([meds count] == 0){
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}



@end
