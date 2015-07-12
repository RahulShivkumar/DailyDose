//
//  DayPicker.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 3/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayPickerButton.h"

@interface DayPicker : UIView{
    DayPickerButton *sunday;
    DayPickerButton *monday;
    DayPickerButton *tuesday;
    DayPickerButton *wednesday;
    DayPickerButton *thursday;
    DayPickerButton *friday;
    DayPickerButton *saturday;
    
    NSMutableArray *tviews;
}

@property (nonatomic, strong)NSMutableDictionary *days;

- (id)initWithFrame:(CGRect)frame andBG:(UIColor*)bg andTc:(UIColor*)tc andHtc:(UIColor*)htc andHl:(UIColor*)hl andTextviews:(NSMutableArray *)tViews;

- (IBAction)sunday:(id)sender;
- (IBAction)monday:(id)sender;
- (IBAction)tuesday:(id)sender;
- (IBAction)wednesday:(id)sender;
- (IBAction)thursday:(id)sender;
- (IBAction)friday:(id)sender;
- (IBAction)saturday:(id)sender;

@end
