//
//  MissedViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 2/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "MissedViewController.h"
#import "Medication.h"
#import "MedsCell.h"

@interface MissedViewController ()

@end

@implementation MissedViewController

-(id)initWithMeds:(NSMutableArray*)missedMeds andHour:(int)hr{
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
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupViews{
    title = [[UILabel alloc]initWithFrame:CGRectMake(10, [self window_height]/6 - 40, [self window_width], 40)];
    [title setFont:[UIFont fontWithName:@"HelveticaNeue" size:30]];
    [title setText:@"Missed Medication:"];
    [title setTextColor:[UIColor whiteColor]];
    [self.view addSubview:title];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:204/255.0 green:46/255.0 blue:46/255.0 alpha:1.0]];
    self.medsView = [[UITableView alloc] init];
    [self.medsView setDataSource:self];
    [self.medsView setDelegate:self];
    [self.medsView registerClass:[MedsCell class] forCellReuseIdentifier:@"cell"];
    [self.medsView setBackgroundColor:[UIColor whiteColor]];
    [self.medsView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.medsView setSeparatorInset:UIEdgeInsetsZero];
    [self.medsView setSeparatorColor:[UIColor colorWithRed:204/255.0 green:46/255.0 blue:46/255.0 alpha:1.0]];
    if([meds count] <= 5){
        [self.medsView setFrame:CGRectMake(0, [self window_height]/6, [self window_width], [self window_height]/8 *[meds count])];
        [self.medsView setScrollEnabled:NO];
    }
    else{
        [self.medsView setFrame:CGRectMake(0, [self window_height]/6, [self window_width], [self window_height]/8 * 5)];
    }
    [self.view addSubview:self.medsView];
    
    taken = [[UIButton alloc] initWithFrame:CGRectMake(20, self.medsView.frame.origin.y + self.medsView.frame.size.height + 30, 70, 70)];
    [taken setImage:[UIImage imageNamed:@"taken"] forState:UIControlStateNormal];
    [taken addTarget:self action:@selector(taken:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:taken];
    
    UILabel *takenLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.medsView.frame.origin.y + self.medsView.frame.size.height + 110, 70, 20)];
    [takenLabel setTextColor:[UIColor whiteColor]];
    [takenLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18]];
    [takenLabel setText:@"Taken"];
    [takenLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:takenLabel];
    
    delay = [[UIButton alloc] initWithFrame:CGRectMake([self window_width]/2 - 35, self.medsView.frame.origin.y + self.medsView.frame.size.height + 30, 70, 70)];
    [delay setImage:[UIImage imageNamed:@"delay"] forState:UIControlStateNormal];
    [delay addTarget:self action:@selector(delay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delay];
    
    UILabel *delayLabel = [[UILabel alloc] initWithFrame:CGRectMake([self window_width]/2 - 35, self.medsView.frame.origin.y + self.medsView.frame.size.height + 110, 70, 20)];
    [delayLabel setTextColor:[UIColor whiteColor]];
    [delayLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18]];
    [delayLabel setText:@"Delay"];
    [delayLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:delayLabel];
    
    skip = [[UIButton alloc] initWithFrame:CGRectMake([self window_width] - 20- 70, self.medsView.frame.origin.y + self.medsView.frame.size.height + 30, 70, 70)];
    [skip setImage:[UIImage imageNamed:@"skip"] forState:UIControlStateNormal];
    [skip addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skip];
    
    UILabel *skipLabel = [[UILabel alloc] initWithFrame:CGRectMake([self window_width] - 20- 70, self.medsView.frame.origin.y + self.medsView.frame.size.height + 110, 70, 20)];
    [skipLabel setTextColor:[UIColor whiteColor]];
    [skipLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18]];
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
    Medication *med = [meds objectAtIndex:indexPath.row];
    [cell setMed:med];
    [cell setPannable];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self window_height]/8;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
#pragma mark - IBActions 
-(IBAction)taken:(id)sender{
    NSString *query = [NSString stringWithFormat: @"update today_meds set completed = 1 where time <= %d and completed = 0", hour];
    [self.dbManager executeQuery:query];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)delay:(id)sender{
    NSString *amPm = @"AM";
    if(hour > 12){
        amPm = @"PM";
    }
    NSString *query = [NSString stringWithFormat: @"update today_meds set time = %d, ampm = %@  where time <= %d and completed = 0", hour + 2, amPm, hour];
    [self.dbManager executeQuery:query];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)skip:(id)sender{\
    //2 Used to show it is skipped
    NSString *query = [NSString stringWithFormat: @"update today_meds set completed = 2 where time <= %d and completed = 0", hour];
    [self.dbManager executeQuery:query];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark  - Helper Methods
-(CGFloat)window_height{
    return [UIScreen mainScreen].applicationFrame.size.height;
}

-(CGFloat)window_width{
    return [UIScreen mainScreen].applicationFrame.size.width;
}

@end
