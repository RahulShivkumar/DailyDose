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

@protocol StrikeDelegate
- (void)strikeDelegate:(id)sender;
@end

@interface MedsCell : UITableViewCell{
    CGPoint _originalCenter;
    BOOL _openMenu;
    BOOL _markCompleteOnDragRelease;
    BOOL _closeMenu;
    BOOL _closeGesture;
    BOOL _marked;
    BOOL _viewSet;
    
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
- (void)undo;
- (void)uiUndo;
- (void)complete;
- (void)uiComplete;
@end
