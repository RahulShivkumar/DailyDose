//
//  AnalyzeViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "AnalyzeViewController.h"


@interface AnalyzeViewController ()



@end

@implementation AnalyzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self.view setBackgroundColor:[UIColor colorWithRed:122/255.0 green:0/255.0 blue:38/255.0 alpha:1.0]];
    [self setFakeImage];

}

-(void)setFakeImage{
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:194/255.0 green:59/255.0 blue:34/255.0 alpha:1.0]];
    [self.navigationItem setTitle:@"Analyze"];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 375, [self window_height] - 89)];
    [self.view addSubview:scrollView];
    [scrollView setScrollEnabled:YES];
    UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 824)];
    UIImageView *analyze = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 375, 774)];
    [analyze setImage:[UIImage imageNamed:@"fakeanalyze"]];
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
-(CGFloat)window_height{
    return [UIScreen mainScreen].applicationFrame.size.height;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
