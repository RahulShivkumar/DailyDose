//
//  AnalyzeViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AnalyzeViewController : UIViewController <UITextFieldDelegate>{

}
@property (weak, nonatomic) IBOutlet UITextField *medName;
@property (weak, nonatomic) IBOutlet UITextField *chemName;
@property (weak, nonatomic) IBOutlet UITextField *dosage;
@property (weak, nonatomic) IBOutlet UITextField *time;
@property (weak, nonatomic) IBOutlet UITextField *ampm;
@property (weak, nonatomic) IBOutlet UITextField *type;

@property (weak, nonatomic) IBOutlet UISwitch *monday;
@property (weak, nonatomic) IBOutlet UISwitch *tuesday;
@property (weak, nonatomic) IBOutlet UISwitch *wednesday;

@property (weak, nonatomic) IBOutlet UISwitch *thurs;
@property (weak, nonatomic) IBOutlet UISwitch *fri;
@property (weak, nonatomic) IBOutlet UISwitch *sat;
@property (weak, nonatomic) IBOutlet UISwitch *sun;

- (void)setFakeImage;

@end
