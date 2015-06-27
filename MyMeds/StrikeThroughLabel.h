//
//  StrikeThroughLabel.h
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/29/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StrikeThroughLabel : UILabel{
    bool _strikethrough;
    CALayer* _strikethroughLayer;
}

@property (nonatomic) bool strikethrough;

- (void)setText:(NSString *)text;
- (void)resizeStrikeThrough;

@end
