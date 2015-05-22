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

@interface SettingsViewController : UIViewController

@property (nonatomic, strong) DBManager *dbManager;

@property (weak, nonatomic) IBOutlet UITextField *scriptPhrase;
@property (strong, nonatomic) ParsimmonNaiveBayesClassifier *classifier;

- (IBAction)parse:(id)sender;

- (void)setPlaceholderImage;
- (void)setNavbar;
- (IBAction)deleteMeds:(id)sender;
- (IBAction)syncMeds:(id)sender;
@end
