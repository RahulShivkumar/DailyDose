//
//  OverviewViewController.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DBAccess/DBAccess.h>
#import "Constants.h"


@interface OverviewViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    DBResultSet *meds;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *add;

@property (weak, nonatomic) IBOutlet UISegmentedControl *timeline;

@property (nonatomic, strong) UITableView *medsView;

@property (nonatomic, strong) UISearchBar *searchBar;

- (void)setupViews;

- (void)setupMeds:(int)expired;

- (IBAction)addMedication:(id)sender;
- (IBAction)changeTimeline:(id)sender;
- (IBAction)toggleSearch:(id)sender;



@end

