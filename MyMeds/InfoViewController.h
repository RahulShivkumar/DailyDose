//
//  InfoViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 2/4/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Medication.h"
#import "DBManager.h"

@interface InfoViewController : UIViewController{
    UIButton *close;
    UIButton *endMed;
    UILabel *medInfo;
    UILabel *medLabel;
    UILabel *chemLabel;
    UILabel *description;
    UILabel *startDate;
    UILabel *endDate;
    UILabel *timeTaken;
    UILabel *time;
    
    UIView *underLine1;
    Medication *med;
    
}
@property (nonatomic, strong) DBManager *dbManager;

-(void)setupData;
-(IBAction)closeWindow:(id)sender;
-(CGFloat)window_height;
-(CGFloat)window_width;

-(id)initWithMed:(Medication*)medication;

@end
