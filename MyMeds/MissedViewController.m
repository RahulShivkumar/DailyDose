//
//  MissedViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 2/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "MissedViewController.h"


#define kBGColor [UIColor colorWithRed:194/255.0 green:59/255.0 blue:34/255.0 alpha:1.0]
#define buttonFont [UIFont fontWithName:@"HelveticaNeue-Thin" size:18]

@interface MissedViewController ()

@end

@implementation MissedViewController

//Custom init method with meds and current hour
- (id)initWithMeds:(DBResultSet*)missedMeds andHour:(long)hr{
    if (self = [super init]) {
        meds = [NSMutableArray arrayWithArray:missedMeds];
        hour = hr;
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
    
    [self.view setBackgroundColor:kBGColor];
    
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
    
    TodayMedication *med = [meds objectAtIndex:indexPath.row];
    
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
    for (TodayMedication *med in meds){
        [EventLogger logAction:@"taken" andMedication:med.coreMed andTime:med.time];
    }
    [meds removeAllObjects];
    [self checkCompleted];
    
}
//Method called to delay all missed meds
- (IBAction)delay:(id)sender{
    if (hour + 2 < 24){
        for (TodayMedication *tm in meds){
            tm.time = hour + 2;
            [tm commit];
        }
        
        for (Medication *med in meds){
            [EventLogger logAction:@"delayed" andMedication:med.coreMed andTime:med.time];
        }
        
        [meds removeAllObjects];
        [self checkCompleted];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Cannot Delay!"
                                                          message:@"Delaying will send medication to the next day!"
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        [message show];
    }
}


//Method called to skip all meds
- (IBAction)skip:(id)sender{
    for (TodayMedication *med in meds){
        [EventLogger logAction:@"missed" andMedication:med.coreMed andTime:med.time];
    }
    
    [meds removeAllObjects];
    [self checkCompleted];
}


- (IBAction)loadInfo:(id)sender{
    //Get Button Position to detect which med to send
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.medsView];
    NSIndexPath *indexPath = [self.medsView indexPathForRowAtPoint:buttonPosition];
    MedsCell *cell = (MedsCell*)[self.medsView cellForRowAtIndexPath:indexPath];
   
    TodayMedication *med = [meds objectAtIndex:indexPath.row];
    InfoViewController *infoVC = [[InfoViewController alloc] initWithMed:med.coreMed];
    
    [EventLogger logAction:@"info" andMedication:med.coreMed andTime:med.time];
    
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

    if (hour + 2 < 24){
        med.time = hour + 2;
        [med commit];
        
        [EventLogger logAction:@"delayed" andMedication:med.coreMed andTime:med.time];
        
        [meds removeObjectAtIndex:indexPath.row];
        
        [self.medsView beginUpdates];
        
        [self.medsView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                             withRowAnimation:UITableViewRowAnimationFade];
        
        [self.medsView endUpdates];
        
        [self checkCompleted];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Cannot Delay!"
                                                          message:@"Delaying will send medication to the next day!"
                                                         delegate:nil
                                                cancelButtonTitle:@"Ok"
                                                otherButtonTitles:nil];
        [message show];
    }
}


- (IBAction)skipSingleMed:(id)sender{
    //Get Button Position to detect which med to send
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.medsView];
    NSIndexPath *indexPath = [self.medsView indexPathForRowAtPoint:buttonPosition];
    MedsCell *cell = (MedsCell*)[self.medsView cellForRowAtIndexPath:indexPath];
    [cell closeCell];
    
    Medication *med = [meds objectAtIndex:indexPath.row];
    
    [EventLogger logAction:@"missed" andMedication:med.coreMed andTime:med.time];

    [meds removeObjectAtIndex:indexPath.row];
    
    [self.medsView beginUpdates];
    [self.medsView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    [self.medsView endUpdates];

    [self checkCompleted];
}


#pragma mark Strike Delegate
- (void)strikeDelegate:(id)sender{
    MedsCell *medCell = (MedsCell *)sender;
    NSIndexPath *indexPath = [self.medsView indexPathForCell:medCell];
    Medication *med = [meds objectAtIndex:indexPath.row];
    [meds removeObjectAtIndex:indexPath.row];
    
    [EventLogger logAction:@"taken" andMedication:med.coreMed andTime:med.time];
    
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
        //Remove all the meds that haven't been delayed since we have recorded their outcome
        [[[[TodayMedication query] whereWithFormat:@"time < %d", (int)hour] fetch] removeAll];
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}



@end
