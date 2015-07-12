//
//  AnalyzeViewController.m
//  MyMeds
//
//  Created by Rahul Shivkumar on 1/26/15.
//  Copyright (c) 2015 test. All rights reserved.
//

#import "AnalyzeViewController.h"
#import "Constants.h"


@interface AnalyzeViewController ()

@end

#define kBGColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]
#define kGraphColor [UIColor colorWithRed:229/255.0 green:98/255.0 blue:92/255.0 alpha:1.0]

@implementation AnalyzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [self.view setBackgroundColor:[UIColor colorWithRed:122/255.0 green:0/255.0 blue:38/255.0 alpha:1.0]];


}

- (void)viewWillAppear:(BOOL)animated {
    [self setupViews];
}

- (void)setupViews {
    [Constants setupNavbar:self];
    [self.view setBackgroundColor:kBGColor];
    
    UIView *graphView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, [Constants window_width] - 10, [Constants window_height] * 0.33)];
    [graphView setBackgroundColor:kGraphColor];
    [graphView.layer setCornerRadius:5];
    [self.view addSubview:graphView];
    
    // Create a gradient to apply to the bottom portion of the graph
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    

    
    self.complianceGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(5, 5, [Constants window_width] - 20, [Constants window_height] * 0.33 - 10)];
    
    // Apply the gradient to the bottom portion of the graph
    self.complianceGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    self.complianceGraph.colorTop = kGraphColor;
    self.complianceGraph.colorBottom = kGraphColor;
    self.complianceGraph.enableBezierCurve = NO;
    
    self.complianceGraph.colorXaxisLabel = [UIColor whiteColor];
    self.complianceGraph.colorBackgroundXaxis = kGraphColor;
    
    self.complianceGraph.enableYAxisLabel = YES;
    self.complianceGraph.autoScaleYAxis = YES;
    self.complianceGraph.colorYaxisLabel = [UIColor whiteColor];
    self.complianceGraph.colorBackgroundYaxis = kGraphColor;
    self.complianceGraph.widthLine = 3.0;
    
    self.complianceGraph.enableReferenceAxisFrame = YES;
    
    [self.complianceGraph setDataSource:self];
    [self.complianceGraph setDelegate:self];
    
    [graphView addSubview:self.complianceGraph];
    
 //   [EventLogger getComplianceAnalyzerMetrics];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark  - Graph Delegate Methods 
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return 7; // Number of points in the graph.
}


- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    if (index == 0){
        return 50;
    } else if (index == 1){
        return 70;
    } else if (index == 2) {
        return 80;
    }
    return 10; // The value of the point on the Y-Axis for the index.
}


- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    if ((index % 2) == 0) return @"Jul 22";
    else return @"";
}

@end
