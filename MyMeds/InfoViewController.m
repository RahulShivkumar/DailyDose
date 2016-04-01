//
//  InfoViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 2/4/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "InfoViewController.h"

#define kBGColor                                                               \
[UIColor colorWithRed:229 / 255.0 green:98 / 255.0 blue:92 / 255.0 alpha:1.0]
#define kBGColor2                                                              \
[UIColor colorWithRed:249 / 255.0                                            \
green:191 / 255.0                                            \
blue:118 / 255.0                                            \
alpha:1.0]
#define kTextColor [UIColor whiteColor]

@implementation InfoViewController

- (id)initWithMed:(CoreMedication *)medication {
    if (self = [super init]) {
        cm = medication;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.screenName = @"Info Screen";
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark View Setup
- (void)setupView {
    for (UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    
    [self.view setBackgroundColor:kBGColor];
    
    close = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 60, 40)];
    [close.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close.titleLabel setTextColor:kTextColor];
    [self.view addSubview:close];
    [close addTarget:self
              action:@selector(closeWindow:)
    forControlEvents:UIControlEventTouchUpInside];
    
    if (cm.expired == 0) {
        edit = [[UIButton alloc]
                initWithFrame:CGRectMake([Constants window_width] - 60, 15, 60, 40)];
        [edit.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        [edit setTitle:@"Edit" forState:UIControlStateNormal];
        [edit.titleLabel setTextColor:kTextColor];
        [self.view addSubview:edit];
        [edit addTarget:self
                 action:@selector(editMeds:)
       forControlEvents:UIControlEventTouchUpInside];
    }
    
    medInfo = [[UILabel alloc]
               initWithFrame:CGRectMake([Constants window_width] / 2 - 100, 15, 200,
                                        40)];
    [medInfo setTextAlignment:NSTextAlignmentCenter];
    [medInfo setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [medInfo setText:@"Medication Info"];
    [medInfo setTextColor:kTextColor];
    [self.view addSubview:medInfo];
    //
    medLabel = [[UILabel alloc]
                initWithFrame:CGRectMake(25, [Constants window_height] * 0.05,
                                         [Constants window_width] * 0.7,
                                         [Constants window_height] * 0.2)];
    [medLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:42]];
    [medLabel setTextColor:kTextColor];
    [medLabel setText:cm.genName];
    [self.view addSubview:medLabel];
    
    chemLabel = [[UILabel alloc]
                 initWithFrame:CGRectMake(30, [Constants window_height] * 0.155,
                                          [Constants window_width] - 10,
                                          [Constants window_height] * 0.145)];
    [chemLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:22]];
    [chemLabel setTextColor:kTextColor];
    [chemLabel setText:[@"- " stringByAppendingString:cm.chemName]];
    [self.view addSubview:chemLabel];
    
    // Caculate medlabel's text size and use that
    CGSize textSize = [medLabel.text
                       sizeWithAttributes:@{NSFontAttributeName : [medLabel font]}];
    description = [[UILabel alloc]
                   initWithFrame:CGRectMake(textSize.width + 30,
                                            [Constants window_height] * 0.09,
                                            [Constants window_width] - 10,
                                            [Constants window_height] * 0.145)];
    [description setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:22]];
    [description setTextColor:kTextColor];
    [description setText:cm.dosage];
    [self.view addSubview:description];
    
    startDate = [[UILabel alloc]
                 initWithFrame:CGRectMake(30, [Constants window_height] * 0.210,
                                          [Constants window_width] - 10,
                                          [Constants window_height] * 0.145)];
    [startDate setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:22]];
    [startDate setTextColor:kTextColor];
    [self.view addSubview:startDate];
    
    endDate = [[UILabel alloc]
               initWithFrame:CGRectMake(30, [Constants window_height] * 0.265,
                                        [Constants window_width] - 10,
                                        [Constants window_height] * 0.145)];
    [endDate setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:22]];
    [endDate setTextColor:kTextColor];
    [self.view addSubview:endDate];
    
    timeTaken = [[UILabel alloc]
                 initWithFrame:CGRectMake(10, [Constants window_height] * 0.38,
                                          [Constants window_width] / 2.0 - 10,
                                          [Constants window_height] * 0.2)];
    [timeTaken setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:25]];
    [timeTaken setTextColor:kTextColor];
    [timeTaken setText:@"Time Taken:"];
    [self.view addSubview:timeTaken];
    
    underLine1 = [[UIView alloc]
                  initWithFrame:CGRectMake(10, [Constants window_height] * 0.5,
                                           [Constants window_width] - 20, 1)];
    [underLine1 setBackgroundColor:kTextColor];
    [self.view addSubview:underLine1];
    
    endMed = [[UIButton alloc]
              initWithFrame:CGRectMake(30, [Constants window_height] * 0.95,
                                       [Constants window_width] - 60, 30)];
    [endMed.layer setBorderWidth:1.0];
    [endMed.layer setBorderColor:kTextColor.CGColor];
    
    if (cm.expired) {
        [endMed setTitle:@"Delete Record" forState:UIControlStateNormal];
        [endMed addTarget:self
                   action:@selector(deleteRecord:)
         forControlEvents:UIControlEventTouchUpInside];
    } else {
        [endMed setTitle:@"End Course" forState:UIControlStateNormal];
        [endMed addTarget:self
                   action:@selector(endCourse:)
         forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.view addSubview:endMed];
    
    [self getDates];
    [self setupDaysTaken];
    [self setupTime];
}

- (void)getDates {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    [startDate
     setText:[@"- Start Date: " stringByAppendingString:
              [dateFormat stringFromDate:cm.startDate]]];
    
    // End Date detection
    if (cm.endDate == nil) {
        [endDate setText:@"- End Date: N/A"];
    } else {
        [endDate
         setText:[@"- End Date: " stringByAppendingString:
                  [dateFormat stringFromDate:cm.endDate]]];
    }
}
- (void)setupDaysTaken {
    daySchedule = [[NSMutableArray alloc] init];
    UILabel *daysTaken = [[UILabel alloc]
                          initWithFrame:CGRectMake(30, [Constants window_height] * 0.320,
                                                   [Constants window_width] * 0.6,
                                                   [Constants window_height] * 0.145)];
    [daysTaken setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:22]];
    [daysTaken setTextColor:kTextColor];
    [daysTaken setText:@"- Days Taken:"];
    [self.view addSubview:daysTaken];
    
    DBResultSet *temp = [
                         [[[Medication query] whereWithFormat:@"coreMed = %@", cm] limit:1] fetch];
    Medication *tempMed = [temp objectAtIndex:0];
    NSArray *tempBools = [[NSArray alloc]
                          initWithObjects:[NSNumber numberWithBool:tempMed.sunday],
                          [NSNumber numberWithBool:tempMed.monday],
                          [NSNumber numberWithBool:tempMed.tuesday],
                          [NSNumber numberWithBool:tempMed.wednesday],
                          [NSNumber numberWithBool:tempMed.thursday],
                          [NSNumber numberWithBool:tempMed.friday],
                          [NSNumber numberWithBool:tempMed.saturday], nil];
    NSMutableArray *days = [[NSMutableArray alloc]
                            initWithObjects:@"S", @"M", @"T", @"W", @"Th", @"F", @"S", nil];
    
    for (int i = 0; i < 7; i++) {
        UILabel *day = [[UILabel alloc]
                        initWithFrame:CGRectMake(158 + i * 0.072 * [Constants window_width],
                                                 [Constants window_height] * 0.375,
                                                 [Constants window_width] * 0.072,
                                                 [Constants window_width] * 0.072)];
        [day setText:[days objectAtIndex:i]];
        [day setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
        [day setTextAlignment:NSTextAlignmentCenter];
        [day setTextColor:kTextColor];
        
        [daySchedule addObject:[tempBools objectAtIndex:i]];
        
        if ([tempBools objectAtIndex:i] == [NSNumber numberWithBool:YES]) {
            [day.layer setBorderWidth:1.0];
            [day.layer setCornerRadius:day.frame.size.width / 2.0];
            [day.layer setBorderColor:kTextColor.CGColor];
        }
        [self.view addSubview:day];
    }
}

- (void)setupTime {
    times = [[NSMutableArray alloc] init];
    
    DBResultSet *temp = [[[[Medication query] whereWithFormat:@"coreMed = %@", cm]
                          orderBy:@"time"] fetch];
    
    int i = 0;
    
    for (Medication *m in temp) {
        
        [times addObject:[NSNumber numberWithFloat:m.time]];
        
        time = [[UILabel alloc]
                initWithFrame:CGRectMake([Constants window_width] / 2.0,
                                         [Constants window_height] * 0.38 +
                                         0.05 * i * [Constants window_height],
                                         [Constants window_width] / 2.0 - 10,
                                         [Constants window_height] * 0.2)];
        
        [time setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:25]];
        [time setTextColor:kTextColor];
        [time setTextAlignment:NSTextAlignmentRight];
        [time setText:[Constants convertTimeToString:m.time]];
        
        [self.view addSubview:time];
        
        i++;
    }
}

- (IBAction)closeWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)editMeds:(id)sender {
    
    EditMedsController *editMedsController =
    [[EditMedsController alloc] initWithMed:cm
                                    andDays:daySchedule
                                    andTime:times];
    [editMedsController
     setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self presentViewController:editMedsController animated:YES completion:nil];
}

- (IBAction)endCourse:(id)sender {
    UIAlertView *theAlert = [[UIAlertView alloc]
                             initWithTitle:@"End Course?"
                             message:@"Ending a course will remove it from your schedule "
                             @"and send it to 'past' meds"
                             delegate:self
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:@"End Course", nil];
    [theAlert show];
}

- (IBAction)deleteRecord:(id)sender {
    UIAlertView *theAlert = [[UIAlertView alloc]
                             initWithTitle:@"Delete This Med?"
                             message:
                             @"Deleting this med will remove it permanently from the app"
                             delegate:self
                             cancelButtonTitle:@"Cancel"
                             otherButtonTitles:@"Delete", nil];
    [theAlert show];
}

#pragma mark - UIAlertview delegate
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([title isEqualToString:@"End Course"]) {
        // Lets remove it from TodayMeds
        [[[[TodayMedication query]
           whereWithFormat:@"coreMed = %@", cm] fetch] removeAll];
        
        cm.expired = 1;
        cm.endDate = [NSDate date];
        [cm commit];
        
        // Remove from local notification
        [NotificationScheduler removeLocalNotificationWithCoreMedication:cm
                                                                AndTimes:times];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } else if ([title isEqualToString:@"Delete"]) {
        [[[[Medication query]
           whereWithFormat:@"coreMed = %@", cm] fetch] removeAll];
        [[[[TodayMedication query]
           whereWithFormat:@"coreMed = %@", cm] fetch] removeAll];
        [cm remove];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
