//
//  MedsCell.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/29/15.
//  Copyright (c) 2015 postpone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"
#import "Medication.h"

@interface MedsCell : UITableViewCell{
    CGPoint _originalCenter;
    BOOL _openMenu;
    BOOL _markCompleteOnDragRelease;
    BOOL _closeMenu;
    BOOL _closeGesture;
    BOOL _marked;
    
    StrikeThroughLabel *medLabel;
    StrikeThroughLabel *chemLabel;
    StrikeThroughLabel *timeLabel;
    UIView *mainView;
    Medication *medication;
    
    UIGestureRecognizer* panRecognizer;
    
    @public UIButton *undo;
    @public UIButton *info;
    @public UIButton *postpone;
}
@property (nonatomic, strong) DBManager *dbManager;
-(void)setMed:(Medication*)med;
-(void)setPannable;
-(void)removePannable;
-(CGFloat) window_width;
-(void)closeCell;
-(void)undo;
-(void)complete;
@end
