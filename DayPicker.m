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
        self.days = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithInt:0], @"monday",[NSNumber numberWithInt:0], @"tuesday", [NSNumber numberWithInt:0], @"wednesdaynesday", [NSNumber numberWithInt:0], @"thursday", [NSNumber numberWithInt:0], @"friday", [NSNumber numberWithInt:0], @"saturday", [NSNumber numberWithInt:0], @"sunday", nil];
        
        sunday = [[DayPickerButton alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"S"];
        [sunday addTextColor:tc andHighlightTextColor:htc];
        [sunday addHighlightColor:hl];
        [sunday addTarget:self action:@selector(sunday:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sunday];
        
        monday = [[DayPickerButton alloc] initWithFrame:CGRectMake(self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"M"];
        [monday addTextColor:tc andHighlightTextColor:htc];
        [monday addHighlightColor:hl];
        [monday addTarget:self action:@selector(monday:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:monday];
        
        tuesday = [[DayPickerButton alloc] initWithFrame:CGRectMake(2*self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"T"];
        [tuesday addTextColor:tc andHighlightTextColor:htc];
        [tuesday addHighlightColor:hl];
        [tuesday addTarget:self action:@selector(tuesday:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tuesday];
        
        wednesday = [[DayPickerButton alloc] initWithFrame:CGRectMake(3*self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"W"];
        [wednesday addTextColor:tc andHighlightTextColor:htc];
        [wednesday addHighlightColor:hl];
        [wednesday addTarget:self action:@selector(wednesday:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:wednesday];
        
        thursday = [[DayPickerButton alloc] initWithFrame:CGRectMake(4*self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"Th"];
        [thursday addTextColor:tc andHighlightTextColor:htc];
        [thursday addHighlightColor:hl];
        [thursday addTarget:self action:@selector(thursday:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:thursday];
        
        friday = [[DayPickerButton alloc] initWithFrame:CGRectMake(5*self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"F"];
        [friday addTextColor:tc andHighlightTextColor:htc];
        [friday addHighlightColor:hl];
        [friday addTarget:self action:@selector(friday:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:friday];
        
        saturday = [[DayPickerButton alloc] initWithFrame:CGRectMake(6*self.frame.size.width/7, 5, self.frame.size.width/7, self.frame.size.height - 10) andTitle:@"S"];
        [saturday addTextColor:tc andHighlightTextColor:htc];
        [saturday addHighlightColor:hl];
        [saturday addTarget:self action:@selector(saturday:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saturday];
        
        tviews = tViews;

    }
    return self;
}


- (IBAction)sunday:(id)sender{
    [sunday addHighlight];
    sunday.selected  = !sunday.selected;
    if(sunday.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"sunday"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"sunday"];
    }
    [self hideTviews];
}


- (IBAction)monday:(id)sender{
    [monday addHighlight];
    monday.selected  = !monday.selected;
    if(monday.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"monday"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"monday"];
    }
    [self hideTviews];
}


- (IBAction)tuesday:(id)sender{
    [tuesday addHighlight];
    tuesday.selected  = !tuesday.selected;
    if(tuesday.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"tuesday"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"tuesday"];
    }
    [self hideTviews];
}


- (IBAction)wednesday:(id)sender{
    [wednesday addHighlight];
    wednesday.selected  = !wednesday.selected;
    if(wednesday.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"wednesday"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"wednesday"];
    }
    [self hideTviews];
}


- (IBAction)thursday:(id)sender{
    [thursday addHighlight];
    thursday.selected  = !thursday.selected;
    if(thursday.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"thursday"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"thursday"];
    }
    [self hideTviews];
}


-(IBAction)friday:(id)sender{
    [friday addHighlight];
    friday.selected  = !friday.selected;
    if(friday.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"friday"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"friday"];
    }
    [self hideTviews];
}


-(IBAction)saturday:(id)sender{
    [saturday addHighlight];
    saturday.selected  = !saturday.selected;
    if(saturday.selected){
        [self.days setObject:[NSNumber numberWithInt:1] forKey:@"saturday"];
    } else {
        [self.days setObject:[NSNumber numberWithInt:0] forKey:@"saturday"];
    }
    [self hideTviews];
}


-(void)hideTviews{
    for (int i = 0; i < [tviews count]; i ++){
        [tviews[i] resignFirstResponder];
    }
}


@end
