//
//  MedsCell.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/29/15.
//  Copyright (c) 2015 Rahul Shivkumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StrikeThroughLabel.h"
#import "TodayMedication.h"
#import "Constants.h"
#import "EventLogger.h"

@protocol StrikeDelegate
- (void)strikeDelegate:(id)sender;
@end

@interface MedsCell : UITableViewCell{
    CGPoint originalCenter;
    BOOL openMenu;
    BOOL markCompleteOnDragRelease;
    BOOL closeMenu;
    BOOL closeGesture;
    BOOL marked;
    BOOL viewSet;
    
    StrikeThroughLabel *medLabel;
    StrikeThroughLabel *chemLabel;
    StrikeThroughLabel *timeLabel;
    
    UIView *mainView;
    
    TodayMedication *medication;
    
    UIGestureRecognizer* panRecognizer;
    
    @public UIButton *undo;
    @public UIButton *info;
    @public UIButton *postpone;
}
@property (nonatomic, assign) id  <StrikeDelegate> delegate;

- (void)setMed:(TodayMedication*)med;
- (void)setPannable;
- (void)removePannable;
- (void)closeCell;
- (void)complete;
- (void)uiComplete;

- (void)undo;
- (void)uiUndo;

@end
