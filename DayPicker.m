//
//  DayPicker.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 3/18/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "DayPicker.h"
#import "DayPickerButton.h"

@implementation DayPicker

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame andBG:(UIColor*)bg andTc:(UIColor*)tc andHtc:(UIColor*)htc andHl:(UIColor*)hl andTextviews:(NSMutableArray *)tViews{
    self = [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:bg];
        self.days = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:0], @"mon",[NSNumber numberWithInt:0], @"tue", [NSNumber numberWithInt:0], @"wed", [NSNumber numberWithInt:0], @"thur", [NSNumber numberWithInt:0], @"fri", [NSNumber numberWithInt:0], @"sat", [NSNumber numberWithInt:0], @"sun", nil];
        
        sun = [[DayPickerButton alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"S"];
        [sun addTextColor:tc andHighlightTextColor:htc];
        [sun addHighlightColor:hl];
        [sun addTarget:self action:@selector(sun:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sun];
        
        mon = [[DayPickerButton alloc] initWithFrame:CGRectMake(self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"M"];
        [mon addTextColor:tc andHighlightTextColor:htc];
        [mon addHighlightColor:hl];
        [mon addTarget:self action:@selector(mon:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mon];
        
        tue = [[DayPickerButton alloc] initWithFrame:CGRectMake(2*self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"T"];
        [tue addTextColor:tc andHighlightTextColor:htc];
        [tue addHighlightColor:hl];
        [tue addTarget:self action:@selector(tue:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tue];
        
        wed = [[DayPickerButton alloc] initWithFrame:CGRectMake(3*self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"W"];
        [wed addTextColor:tc andHighlightTextColor:htc];
        [wed addHighlightColor:hl];
        [wed addTarget:self action:@selector(wed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:wed];
        
        thur = [[DayPickerButton alloc] initWithFrame:CGRectMake(4*self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"Th"];
        [thur addTextColor:tc andHighlightTextColor:htc];
        [thur addHighlightColor:hl];
        [thur addTarget:self action:@selector(thur:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:thur];
        
        fri = [[DayPickerButton alloc] initWithFrame:CGRectMake(5*self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"F"];
        [fri addTextColor:tc andHighlightTextColor:htc];
        [fri addHighlightColor:hl];
        [fri addTarget:self action:@selector(fri:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:fri];
        
        sat = [[DayPickerButton alloc] initWithFrame:CGRectMake(6*self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"S"];
        [sat addTextColor:tc andHighlightTextColor:htc];
        [sat addHighlightColor:hl];
        [sat addTarget:self action:@selector(sat:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sat];
        
        tviews = tViews;

    }
    return self;
}


- (IBAction)sun:(id)sender{
    [sun addHighlight];
    sun.selected  = !sun.selected;
    if(sun.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"sun"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"sun"];
    }
    [self hideTviews];
}


- (IBAction)mon:(id)sender{
    [mon addHighlight];
    mon.selected  = !mon.selected;
    if(mon.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"mon"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"mon"];
    }
    [self hideTviews];
}


- (IBAction)tue:(id)sender{
    [tue addHighlight];
    tue.selected  = !tue.selected;
    if(tue.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"tue"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"tue"];
    }
    [self hideTviews];
}


- (IBAction)wed:(id)sender{
    [wed addHighlight];
    wed.selected  = !wed.selected;
    if(wed.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"wed"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"wed"];
    }
    [self hideTviews];
}


- (IBAction)thur:(id)sender{
    [thur addHighlight];
    thur.selected  = !thur.selected;
    if(thur.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"thur"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"thur"];
    }
    [self hideTviews];
}


-(IBAction)fri:(id)sender{
    [fri addHighlight];
    fri.selected  = !fri.selected;
    if(fri.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"fri"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"fri"];
    }
    [self hideTviews];
}


-(IBAction)sat:(id)sender{
    [sat addHighlight];
    sat.selected  = !sat.selected;
    if(sat.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"sat"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"sat"];
    }
    [self hideTviews];
}


-(void)hideTviews{
    for (int i = 0; i < [tviews count]; i ++){
        [tviews[i] resignFirstResponder];
    }
}


@end
