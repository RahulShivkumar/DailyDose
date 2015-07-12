//
//  ComplianceCircle.h
//  ComplianceCircle
//
//  Created by Rahul Shivkumar on 6/27/15.
//  Copyright (c) 2015 Rahul Shivkumar. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, VMMakeLocation) {
    VMMakeLocationTop = 1,
    VMMakeLocationBottom
};

@interface ComplianceCircle : UIView
@property(nonatomic) UIColor *strokeColor;

@property(nonatomic) CAShapeLayer *circleLayer;
@property (nonatomic) CAShapeLayer *lineLayerTopToBottom;
@property (nonatomic) CAShapeLayer *lineLayerBottomToHide;

@property (nonatomic, strong) UIImageView *imgIcon;

@property (nonatomic, strong) UILabel *property;
@property (nonatomic, strong) UILabel *value;

@property (nonatomic) float lineWidth;

- (void)addCircleLayerWithType:(NSInteger)type;
- (void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated;
- (void)buildButton;
- (void)setValue:(NSString*)value andProperty:(NSString*)property andTextColor:(UIColor*)textColor;
- (void)setIconButton:(UIImage*)icon withType:(NSInteger)type withColor:(UIColor*)color;
- (void)setLineWidthValue:(float)lineWidthTemp;
- (void)addAction:(SEL)selector;

@end
