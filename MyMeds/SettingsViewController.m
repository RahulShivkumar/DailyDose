//
//  SettingsViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "SettingsViewController.h"
#import "Parser.h"

@interface SettingsViewController ()

@end

#define NavBarColor [UIColor colorWithRed:170/255.0 green:18/255.0 blue:22/255.0 alpha:1.0]

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavbar];

    // Do any additional setup after loading the view.
}
//Place a placeholder image for now
- (void)setPlaceholderImage{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, [Constants window_height] - 89)];
    [self.view addSubview:imageView];
    [imageView setImage:[UIImage imageNamed:@"settingsph"]];
}
//Method called to set navigation bar
- (void)setNavbar{
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBarTintColor:NavBarColor];
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

- (IBAction)syncMeds:(id)sender{
     Parser *parser = [[Parser alloc] init];
}

@end
