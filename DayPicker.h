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
    DayPickerButton *sun;
    DayPickerButton *mon;
    DayPickerButton *tue;
    DayPickerButton *wed;
    DayPickerButton *thur;
    DayPickerButton *fri;
    DayPickerButton *sat;
    
    NSMutableArray *tviews;
}
@property (nonatomic, strong)NSMutableDictionary *days;
-(id)initWithFrame:(CGRect)frame andBG:(UIColor*)bg andTc:(UIColor*)tc andHtc:(UIColor*)htc andHl:(UIColor*)hl andTextviews:(NSMutableArray *)tViews;
-(IBAction)sun:(id)sender;
-(IBAction)mon:(id)sender;
-(IBAction)tue:(id)sender;
-(IBAction)wed:(id)sender;
-(IBAction)thur:(id)sender;
-(IBAction)fri:(id)sender;
-(IBAction)sat:(id)sender;
@end
