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

@interface SettingsViewController : UIViewController

@property (nonatomic, strong) DBManager *dbManager;


- (void)setPlaceholderImage;
- (void)setNavbar;
- (IBAction)deleteMeds:(id)sender;
@end
