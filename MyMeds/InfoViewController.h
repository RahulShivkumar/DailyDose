//
//  InfoViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 2/4/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Medication.h"
#import "Constants.h"
#import "EditMedsController.h"
#import "Medication.h"
#import "TodayMedication.h"
#import "NotificationScheduler.h"

@interface InfoViewController : UIViewController <UIAlertViewDelegate> {
    UIButton *close;
    UIButton *edit;
    UIButton *endMed;
    
    UILabel *medInfo;
    UILabel *medLabel;
    UILabel *chemLabel;
    UILabel *description;
    UILabel *startDate;
    UILabel *endDate;
    UILabel *timeTaken;
    UILabel *time;
    
    UIView *underLine1;
    
    CoreMedication *cm;
    
    NSMutableArray *daySchedule;
    NSMutableArray *times;
}

- (void)setupView;

- (IBAction)closeWindow:(id)sender;
- (IBAction)editMeds:(id)sender;
- (IBAction)endCourse:(id)sender;
- (IBAction)deleteRecord:(id)sender;

- (id)initWithMed:(CoreMedication *)medication;

@end
