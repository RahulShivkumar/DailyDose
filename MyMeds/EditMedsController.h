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
#import "DBManager.h"
#import "Constants.h"
#import "Medication.h"

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
    
    Medication * med;
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
    NSMutableArray *amPm;
    
    int selectedTag;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSMutableArray *dayShedule;
@property (nonatomic, strong) NSMutableArray *times;;
-(void)setupView;
-(void)createButton;
-(void)dismissKeyboard;
-(void)manipulateTime;
-(void)addTimeWithHour:(NSString *)hour andMins:(NSString *)mins andAmPm:(NSString *)ampm;

-(id)initWithMed:(Medication*)medication andDays:(NSMutableArray *)daySchedule andTime:(NSMutableArray *)timeSchedule;
-(IBAction)closeWindow:(id)sender;

@end
