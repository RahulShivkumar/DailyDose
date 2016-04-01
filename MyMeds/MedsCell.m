//
//  MedsCell.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/29/15.
//  Copyright (c) 2015 Rahul Shivkumar. All rights reserved.
//

#import "MedsCell.h"
#import "Medication.h"

#define kDoneColor                                                             \
[UIColor colorWithRed:142 / 255.0                                            \
green:178 / 255.0                                            \
blue:197 / 255.0                                            \
alpha:1.0]
#define kInfoColor                                                             \
[UIColor colorWithRed:229 / 255.0 green:98 / 255.0 blue:92 / 255.0 alpha:1.0]
#define kDelayColor                                                            \
[UIColor colorWithRed:249 / 255.0                                            \
green:191 / 255.0                                            \
blue:118 / 255.0                                            \
alpha:1.0]

@implementation MedsCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!viewSet) {
            [self setViews];
            viewSet = YES;
        }
    }
    return self;
}

- (void)setViews {
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    // Set the buttons here
    info = [[UIButton alloc]
            initWithFrame:CGRectMake(0.31 * [Constants window_width],
                                     self.frame.origin.y,
                                     0.23 * [Constants window_width],
                                     [Constants window_height] / 8)];
    [info.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [info setBackgroundColor:kInfoColor];
    [info setTitle:@"Info" forState:UIControlStateNormal];
    
    undo = [[UIButton alloc]
            initWithFrame:CGRectMake(0.77 * [Constants window_width],
                                     self.frame.origin.y,
                                     0.23 * [Constants window_width],
                                     [Constants window_height] / 8)];
    [undo.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [undo setBackgroundColor:kDoneColor];
    [undo setTitle:@"Taken" forState:UIControlStateNormal];
    
    postpone = [[UIButton alloc]
                initWithFrame:CGRectMake(0.54 * [Constants window_width],
                                         self.frame.origin.y,
                                         0.23 * [Constants window_width],
                                         [Constants window_height] / 8)];
    [postpone.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17]];
    [postpone setBackgroundColor:kDelayColor];
    [postpone setTitle:@"Delay" forState:UIControlStateNormal];
    // Set mainView
    mainView = [[UIView alloc]
                initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y,
                                         [Constants window_width],
                                         [Constants window_height] / 8)];
    [mainView setBackgroundColor:[UIColor whiteColor]];
    //    [self roundCornersOnView:mainView onTopLeft:YES topRight:NO
    //    bottomLeft:YES bottomRight:NO radius:20.0];
    //    [self roundCornersOnView:self onTopLeft:YES topRight:NO bottomLeft:YES
    //    bottomRight:NO radius:10.0];
    
    // Set the labels
    medLabel = [[StrikeThroughLabel alloc]
                initWithFrame:CGRectMake(10, 0, self.bounds.size.width * 0.7,
                                         mainView.bounds.size.height * 0.67)];
    medLabel.textColor = [UIColor blackColor];
    medLabel.backgroundColor = [UIColor clearColor];
    [medLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light"
                                      size:mainView.bounds.size.height * 0.4]];
    //[medLabel setAdjustsFontSizeToFitWidth:YES];
    [medLabel setTextColor:[UIColor colorWithRed:94 / 255.0
                                           green:94 / 255.0
                                            blue:94 / 255.0
                                           alpha:1.0]];
    
    chemLabel = [[StrikeThroughLabel alloc]
                 initWithFrame:CGRectMake(12, mainView.bounds.size.height * 0.37,
                                          self.bounds.size.width * 0.7,
                                          mainView.bounds.size.height - 10)];
    chemLabel.textColor = [UIColor blackColor];
    chemLabel.backgroundColor = [UIColor clearColor];
    [chemLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light"
                                       size:mainView.bounds.size.height * 0.28]];
    [chemLabel setTextColor:[UIColor colorWithRed:94 / 255.0
                                            green:94 / 255.0
                                             blue:94 / 255.0
                                            alpha:1.0]];
    
    timeLabel = [[StrikeThroughLabel alloc]
                 initWithFrame:CGRectMake(2.70 * [Constants window_width] / 4,
                                          mainView.bounds.size.height * 0.05,
                                          1.2 * [Constants window_width] / 4,
                                          mainView.bounds.size.height - 10)];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.backgroundColor = [UIColor clearColor];
    [timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin"
                                       size:mainView.bounds.size.height * 0.5]];
    [timeLabel setTextColor:[UIColor colorWithRed:94 / 255.0
                                            green:94 / 255.0
                                             blue:94 / 255.0
                                            alpha:1.0]];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    
    // Add buttons as subviews to self.view
    [self addSubview:info];
    [self addSubview:undo];
    [self addSubview:postpone];
    // Add labels as subviews to mainView
    [mainView addSubview:medLabel];
    [mainView addSubview:chemLabel];
    [mainView addSubview:timeLabel];
    // Final setup
    [self addSubview:mainView];
    [self setBackgroundColor:[UIColor whiteColor]];
}
- (void)setMed:(TodayMedication *)med {
    [medLabel setText:med.coreMed.genName];
    [chemLabel setText:med.coreMed.chemName];
    
    float actualTime = med.time;
    if (actualTime > 12.5) {
        actualTime -= 12;
    }
    
    NSString *timeString = [NSString stringWithFormat:@"%d", (int)actualTime];
    
    if (actualTime == (int)actualTime) {
        timeString = [timeString stringByAppendingString:@":00"];
    } else {
        timeString = [timeString stringByAppendingString:@":30"];
    }
    
    [timeLabel setText:timeString];
    
    if (med.taken) {
        medLabel.strikethrough = YES;
        chemLabel.strikethrough = YES;
        timeLabel.strikethrough = YES;
    }
    medication = med;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // ensure the gradient layers occupies the full bounds
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - horizontal pan gesture methods
- (void)setPannable {
    // Set the Gesture
    panRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePan:)];
    panRecognizer.delegate = self;
    [mainView addGestureRecognizer:panRecognizer];
}

- (void)removePannable {
    for (UIGestureRecognizer *recognizer in mainView.gestureRecognizers) {
        [mainView removeGestureRecognizer:recognizer];
    }
}

- (BOOL)gestureRecognizerShouldBegin:
(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:mainView];
    // Check for horizontal gesture
    if (fabs(translation.x) > fabs(translation.y)) {
        return YES;
    }
    return NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    // Use velocity to detect direction
    CGPoint velocity = [recognizer velocityInView:mainView];
    
    // Lets check if our item has been marked complete
    markCompleteOnDragRelease =
    mainView.frame.origin.x > mainView.frame.size.width / 8;
    if (markCompleteOnDragRelease) {
        [info setHidden:YES];
        [undo setHidden:YES];
        [postpone setHidden:YES];
        if (!medication.taken) {
            [self complete];
        }
    }
    
    if (velocity.x <= 0 &&
        mainView.frame.origin.x < 0.31 * [Constants window_width]) {
        [info setHidden:NO];
        [undo setHidden:NO];
        [postpone setHidden:NO];
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // if the gesture has just started, record the current center location
        originalCenter = mainView.center;
        if (originalCenter.x <= -0.18 * [Constants window_width]) {
            closeMenu = YES;
        } else {
            closeMenu = NO;
        }
    }
    
    // 2
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        // translate the center
        CGPoint translation = [recognizer translationInView:mainView];
        mainView.center =
        CGPointMake(originalCenter.x + translation.x, originalCenter.y);
        // determine whether the item has been dragged far enough to initiate a
        // close or open menu
        if (!closeMenu) {
            openMenu = mainView.frame.origin.x < -mainView.frame.size.width / 6;
        } else {
            [info setHidden:NO];
            [undo setHidden:NO];
            [postpone setHidden:NO];
            if (mainView.center.x < originalCenter.x) {
                closeGesture = NO;
                openMenu = YES;
                
            } else {
                openMenu = NO;
                closeGesture = mainView.frame.origin.x < -mainView.frame.size.width / 6;
            }
        }
    }
    
    // 3
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        CGRect originalFrame =
        CGRectMake(0, mainView.frame.origin.y, mainView.bounds.size.width,
                   mainView.bounds.size.height);
        marked = NO;
        if (!openMenu) {
            // if the menu is not being opened, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 mainView.frame = originalFrame;
                             }
                             completion:^(BOOL finished) {
                                 if (finished) {
                                     [info setHidden:NO];
                                     [undo setHidden:NO];
                                     [postpone setHidden:NO];
                                 }
                             }];
            
        } else if (openMenu || closeGesture) {
            // If the close gesture is activated or open is not, shut the menu
            [UIView animateWithDuration:0.2
                             animations:^{
                                 
                                 mainView.frame =
                                 CGRectMake(-0.69 * mainView.frame.size.width,
                                            mainView.frame.origin.y,
                                            mainView.bounds.size.width,
                                            mainView.bounds.size.height);
                             }];
        }
    }
}

- (void)complete {
    // mark the item as complete and update the UI state
    medication.taken = YES;
    [medication commit];
    [EventLogger logAction:@"taken"
             andMedication:medication.coreMed
                   andTime:medication.time];
    [NotificationScheduler alterNotificationsForTakenMed:medication];
    [self uiComplete];
}

- (void)uiComplete {
    medLabel.strikethrough = YES;
    timeLabel.strikethrough = YES;
    chemLabel.strikethrough = YES;
    [self.delegate strikeDelegate:self];
    //[undo setTitle:@"Undo" forState:UIControlStateNormal];
}

- (void)closeCell {
    [UIView animateWithDuration:0.2
                     animations:^{
                         
                         mainView.frame =
                         CGRectMake(0, 0, mainView.bounds.size.width,
                                    mainView.bounds.size.height);
                     }];
}

- (void)undo {
    medication.taken = NO;
    [medication commit];
    [EventLogger logAction:@"undo"
             andMedication:medication.coreMed
                   andTime:medication.time];
    [self uiUndo];
}

- (void)uiUndo {
    medLabel.strikethrough = NO;
    timeLabel.strikethrough = NO;
    chemLabel.strikethrough = NO;
    [undo setTitle:@"Taken" forState:UIControlStateNormal];
}

- (void)roundCornersOnView:(UIView *)view
                 onTopLeft:(BOOL)tl
                  topRight:(BOOL)tr
                bottomLeft:(BOOL)bl
               bottomRight:(BOOL)br
                    radius:(float)radius {
    
    if (tl || tr || bl || br) {
        UIRectCorner corner = 0; // holds the corner
        // Determine which corner(s) should be changed
        if (tl) {
            corner = corner | UIRectCornerTopLeft;
        }
        if (tr) {
            corner = corner | UIRectCornerTopRight;
        }
        if (bl) {
            corner = corner | UIRectCornerBottomLeft;
        }
        if (br) {
            corner = corner | UIRectCornerBottomRight;
        }
        
        UIBezierPath *maskPath =
        [UIBezierPath bezierPathWithRoundedRect:view.bounds
                              byRoundingCorners:corner
                                    cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = view.bounds;
        maskLayer.path = maskPath.CGPath;
        view.layer.mask = maskLayer;
    }
}

@end
