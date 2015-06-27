//
//  AnalyzeViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "AnalyzeViewController.h"
#import "Constants.h"


@interface AnalyzeViewController ()

@end

#define NavBarColor [UIColor colorWithRed:170/255.0 green:18/255.0 blue:22/255.0 alpha:1.0]

@implementation AnalyzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self.view setBackgroundColor:[UIColor colorWithRed:122/255.0 green:0/255.0 blue:38/255.0 alpha:1.0]];
    [self setFakeImage];

}

- (void)setFakeImage{
    [Constants setupNavbar:self];
    [self.navigationItem setTitle:@"Analyze"];

    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, [Constants window_height] - 89)];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
  
    UIImageView *analyze = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 320, 648)];
    [analyze setImage:[UIImage imageNamed:@"fakeanalyze"]];
    
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 824)];
    [pageView addSubview:analyze];
    
    [scrollView setContentSize:pageView.frame.size];
    [scrollView addSubview:pageView];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark  - Helper Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
