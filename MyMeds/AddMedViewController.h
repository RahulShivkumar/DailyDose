//
//  AddMedViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 3/17/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayPicker.h"
#import "RMDateSelectionViewController.h"
#import "Constants.h"
#import "MPGTextField.h"
#import "Medication.h"
#import "TodayMedication.h"
#import "CoreMedication.h"
#import "NotificationScheduler.h"
#import "PermissionView.h"

@interface AddMedViewController : UIViewController<UITextFieldDelegate, RMDateSelectionViewControllerDelegate, MPGTextFieldDelegate, UIAlertViewDelegate, PermissionViewDelegate, UIApplicationDelegate>{
    UIButton *cancel;
    UIButton *done;
    UILabel *addMed;
    UILabel *name;
    UILabel *generic;
    UILabel *days;
    UILabel *dosage;
    UILabel *time;
    UILabel *notes;
    
    NSMutableArray *data;
    
    MPGTextField *medName;
    MPGTextField *chemName;
    UITextField *dosageNum;
    UITextField *tView;
    
    DayPicker *dayPicker;
    UIButton *timePicker;
    RMDateSelectionViewController *datePicker;
    
    NSMutableArray *timePickers;
    NSMutableArray *removeTimes;
    NSMutableArray *times;
    NSMutableArray *amPm;
    
    int selectedTag;
    
    DBResultSet *set;
    
    CoreMedication *coreMed;
}

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)setupViews;

- (void)createButton;
- (void)dismissKeyboard;

- (void)manipulateTime;
- (void)addTimeWithHour:(NSString *)hour andMins:(NSString *)mins andAmPm:(NSString *)ampm;

- (void)addMeds:(CoreMedication *)coreMed;

- (void)generateData;

- (void)moveTimesUp:(int)index;

- (IBAction)setDate:(id)sender;
- (IBAction)removeDate:(id)sender;
- (IBAction)closeWindow:(id)sender;
- (IBAction)done:(id)sender;


@end
