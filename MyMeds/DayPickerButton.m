//
//  DayPickerButton.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 3/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "DayPickerButton.h"

@implementation DayPickerButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame andTitle:(NSString *)title{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor clearColor]];
        [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:30]];
        [self setTitle:title forState:UIControlStateNormal];
        self.sel = 0;
        self.layer.cornerRadius = 5.0;
        
    }
    return self;
}

-(void)addHighlight{
    if(self.sel == 0){
        [self setBackgroundColor:highlight];
        [self setTitleColor:highlightTextColor forState:UIControlStateNormal];
        self.sel = 1;
    }
    else{
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTitleColor:textColor forState:UIControlStateNormal];
        self.sel = 0;
        
    }
}

-(void)addTextColor:(UIColor*)tc andHighlightTextColor:(UIColor*)htc{
    [self setTitleColor:tc forState:UIControlStateNormal];
    textColor = tc;
    highlightTextColor = htc;
}
-(void)addHighlightColor:(UIColor*)tc{
    highlight = tc;
    [bgView setBackgroundColor:highlight];
}
@end
