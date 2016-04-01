//
//  TopMedsTable.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 7/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopMedsTable : UIView {
    UIView *bgView;
    
    UILabel *title;
}

@property(nonatomic, strong) NSMutableDictionary *data;

- (id)initWithFrame:(CGRect)frame andData:(NSMutableDictionary *)data;

- (void)setupViews;

- (void)addMedToView:(int)index andYPosition:(float)y;
- (void)addNoDataAvailable:(float)y;
- (void)addLineSeparator:(float)y;

@end
