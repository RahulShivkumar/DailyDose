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
    
    self.complianceGraph.enablePopUpReport = YES;
    self.complianceGraph.enableTouchReport = YES;
    
    [graphView addSubview:self.complianceGraph];
    
    [self setupData];
    
 //   [EventLogger getComplianceAnalyzerMetrics];
    //Display the top 5 meds UI
}


- (void)setupData{
    data = [[NSMutableArray alloc] init];
    topMeds = [[NSMutableDictionary alloc] init];
    data = [EventLogger getGraphMetrics];
    
    //This line is dubious - Check it out
    data = (NSMutableArray*)[[data reverseObjectEnumerator] allObjects];
    
    [self.complianceGraph setDataSource:self];
    [self.complianceGraph setDelegate:self];
    
    //Setup Top 5 Meds
    topMeds = [EventLogger getTopFiveMissedMeds];
    tmt = [[TopMedsTable alloc] initWithFrame:CGRectMake(0, [Constants window_height] * 0.42 - 44, [Constants window_width], [Constants window_height] * 0.58 - 44) andData:topMeds];
    [self.view addSubview:tmt];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark  - Graph Delegate Methods 
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return [data count]; // Number of points in the graph.
}


- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    GraphData *gd = [data objectAtIndex:index];
    return gd.compliance;
}


- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    GraphData *gd = [data objectAtIndex:index];
    return gd.date;
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    // Here you could change the text of a UILabel with the value of the closest index for example.
}



@end
