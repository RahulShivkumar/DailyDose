//
//  DayPickerButton.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 3/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayPickerButton : UIButton{
    UIView *bgView;
    
    UIColor *highlight;
    UIColor *highlightTextColor;
    UIColor *textColor;
}

@property (nonatomic) int sel;

-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title;

-(void)addHighlight;
-(void)addTextColor:(UIColor*)tc andHighlightTextColor:(UIColor*)htc;
-(void)addHighlightColor:(UIColor*)tc;

@end
