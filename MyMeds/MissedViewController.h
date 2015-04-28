//
//  MissedViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 2/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface MissedViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *meds;
    UILabel *title;
    UIButton *taken;
    UIButton *delay;
    UIButton *skip;
    int hour;
}
@property (nonatomic, strong) UITableView *medsView;
@property (nonatomic, strong) DBManager *dbManager;

-(id)initWithMeds:(NSMutableArray*)missedMeds andHour:(int)hr;
-(void)setupViews;
-(CGFloat)window_height;
-(CGFloat)window_width;
-(IBAction)taken:(id)sender;
-(IBAction)delay:(id)sender;
-(IBAction)skip:(id)sender;
@end
