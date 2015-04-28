//
//  AddMedViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 3/17/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayPicker.h"
#import "DBManager.h"
#import "RMDateSelectionViewController.h"
#import "Constants.h"

@interface AddMedViewController : UIViewController<UITextFieldDelegate, RMDateSelectionViewControllerDelegate>{
    UIButton *cancel;
    UIButton *done;
    UILabel *addMed;
    UILabel *name;
    UILabel *generic;
    UILabel *days;
    UILabel *dosage;
    UILabel *time;
    UILabel *notes;
    
    UITextField *medName;
    UITextField *chemName;
    UITextField *dosageNum;
    UITextField *tView;
    
    DayPicker *dayPicker;
    UIButton *timePicker;
    RMDateSelectionViewController *datePicker;
    
    NSMutableArray *timePickers;
    NSMutableArray *times;
    NSMutableArray *amPm;
    
    int selectedTag;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DBManager *dbManager;

-(void)setupView;
-(void)createButton;
-(void)dismissKeyboard;
-(void)manipulateTime;
-(void)addTimeWithHour:(NSString *)hour andMins:(NSString *)mins andAmPm:(NSString *)ampm;

-(IBAction)closeWindow:(id)sender;

@end
