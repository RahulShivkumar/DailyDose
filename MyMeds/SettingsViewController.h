//
//  SettingsViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "Constants.h"
#import "Parsimmon.h"
#import "DBManager.h"

@interface SettingsViewController : UIViewController

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UITextField *scriptPhrase;
@property (strong, nonatomic) ParsimmonNaiveBayesClassifier *classifier;
@property (weak, nonatomic) IBOutlet UILabel *type1;
@property (weak, nonatomic) IBOutlet UILabel *type2;
@property (weak, nonatomic) IBOutlet UILabel *type3;
@property (weak, nonatomic) IBOutlet UILabel *type4;
@property (weak, nonatomic) IBOutlet UILabel *type5;

- (IBAction)parse:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *setType1;
@property (weak, nonatomic) IBOutlet UITextField *setType2;
@property (weak, nonatomic) IBOutlet UITextField *setType3;
@property (weak, nonatomic) IBOutlet UITextField *setType4;

@property (weak, nonatomic) IBOutlet UITextField *setType5;
- (IBAction)input:(id)sender;
- (IBAction)correct:(id)sender;
- (IBAction)wrong:(id)sender;
- (IBAction)delete:(id)sender;

- (void)setPlaceholderImage;
- (void)setNavbar;
- (IBAction)deleteMeds:(id)sender;
- (IBAction)syncMeds:(id)sender;
@end
