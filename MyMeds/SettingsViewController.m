//
//  SettingsViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavbar];

    // Do any additional setup after loading the view.
}
- (void)setPlaceholderImage{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, [Constants window_height] - 89)];
    [self.view addSubview:imageView];
    [imageView setImage:[UIImage imageNamed:@"settingsph"]];
}
- (void)setNavbar{
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:194/255.0 green:59/255.0 blue:34/255.0 alpha:1.0]];
    [self.navigationItem setTitle:@"Settings"];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)deleteMeds:(id)sender{
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dailydosedb.sql"];
        NSString *query2 = [NSString stringWithFormat: @"delete from meds"];
        //Store in today's sql table after deleting what exists
        [self.dbManager executeQuery:query2];
          NSString *query4 = [NSString stringWithFormat: @"delete from today_meds"];
        [self.dbManager executeQuery:query4];
}

@end
