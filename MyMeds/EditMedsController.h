//
//  EditMedsController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 5/8/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"
#import "DayPicker.h"
#import "Constants.h"
#import "Medication.h"
#import "CoreMedication.h"
#import "TodayMedication.h"
#import "NotificationScheduler.h"

@interface EditMedsController : UIViewController <UITextFieldDelegate, RMDateSelectionViewControllerDelegate>{
    UIButton *cancel;
    UIButton *done;
    UILabel *addMed;
    UILabel *name;
    UILabel *generic;
    UILabel *days;
    UILabel *dosage;
    UILabel *time;
    UILabel *notes;
    
    CoreMedication *cm;
    
    UITextField *medName;
    UITextField *chemName;
    UITextField *dosageNum;
    UITextField *tView;
    
    DayPicker *dayPicker;
    UIButton *timePicker;
    RMDateSelectionViewController *datePicker;
    
    NSMutableArray *timePickers;
    NSMutableArray *times;
    NSMutableArray *oldTimes;
    
    int selectedTag;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *dayShedule;

- (id)initWithMed:(CoreMedication*)medication andDays:(NSMutableArray *)daySchedule andTime:(NSMutableArray *)timeSchedule;

- (void)setupView;
- (void)createButton;
- (void)dismissKeyboard;
- (void)manipulateTime;

- (IBAction)closeWindow:(id)sender;


@end
