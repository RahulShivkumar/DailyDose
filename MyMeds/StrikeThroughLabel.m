//
//  StrikeThroughLabel.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/29/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "StrikeThroughLabel.h"

@implementation StrikeThroughLabel

const float STRIKEOUT_THICKNESS = 1.0f;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _strikethroughLayer = [CALayer layer];
        _strikethroughLayer.backgroundColor = [[UIColor colorWithRed:94 / 255.0
                                                               green:94 / 255.0
                                                                blue:94 / 255.0
                                                               alpha:1.0] CGColor];
        _strikethroughLayer.hidden = YES;
        [self.layer addSublayer:_strikethroughLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resizeStrikeThrough];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self resizeStrikeThrough];
}

// resizes the strikethrough layer to match the current label text
- (void)resizeStrikeThrough {
    CGSize textSize =
    [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
    // Only for Time since its right aligned
    if (self.textAlignment == NSTextAlignmentRight) {
        // For 3 digit time
        if (textSize.width < 80) {
            _strikethroughLayer.frame =
            CGRectMake(0.35 * textSize.width, self.bounds.size.height / 2,
                       textSize.width * 1.1, STRIKEOUT_THICKNESS);
        }
        // For 4 digit time
        else {
            _strikethroughLayer.frame =
            CGRectMake(0.1 * textSize.width, self.bounds.size.height / 2,
                       textSize.width * 1.05, STRIKEOUT_THICKNESS);
        }
    }
    // For every other label since they are left aligned
    else {
        _strikethroughLayer.frame = CGRectMake(0, self.bounds.size.height / 2,
                                               textSize.width, STRIKEOUT_THICKNESS);
    }
}

#pragma mark - property setter
- (void)setStrikethrough:(bool)strikethrough {
    _strikethrough = strikethrough;
    _strikethroughLayer.hidden = !strikethrough;
}

@end
