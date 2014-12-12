//
//  ViewController.m
//  LineGraphView
//
//  Created by wildyao on 14/12/3.
//  Copyright (c) 2014年 Wild Yaoyao. All rights reserved.
//

#import "ViewController.h"
#import "YYLineGraphView.h"
#import "YYPlot.h"

@interface ViewController ()

@property (nonatomic, strong) YYLineGraphView *lineGraphView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self  setupLineGraphView];
}

- (void)setupLineGraphView
{
    // 配置graphView
    YYLineGraphView *lineGraphView = [[YYLineGraphView alloc] initWithFrame:CGRectMake(0, 20, 320, 180)];
    self.lineGraphView = lineGraphView;
    
    lineGraphView.customYAixs = YES;
    lineGraphView.timeDimensionType = TimeDimensionTypeThreeMonth;
    
    
    NSDictionary *themeAttributes = @{
                                      kXAxisLabelColorKey : [UIColor colorWithRed:113.0/255.0 green:173.0/255.0 blue:112.0/255.0 alpha:1.0],
                                      kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:12],
                                      kXAxisDateLabelColorKey :[UIColor colorWithRed:113.0/255.0 green:173.0/255.0 blue:112.0/255.0 alpha:1.0],   // x轴date label的颜色
                                      kXAxisDateLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],   // x轴date label的字体
                                      kXAxisWeekLabelColorKey :[UIColor colorWithRed:113.0/255.0 green:173.0/255.0 blue:112.0/255.0 alpha:1.0],   // x轴week label的颜色
                                      kXAxisWeekLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],   // x轴week label的字体
                                      kYAxisLabelColorKey : [UIColor blackColor],  // y轴label的颜色
                                      kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:13],  // y轴label的字体
                                      kYAxisLabelSideMarginsKey : @8,   // y轴的margin（边缘）
                                      kPlotBackgroundLineColorKey : [UIColor colorWithRed:181.0/255.0 green:227.0/255.0 blue:197.0/255.0 alpha:0.5],  // 背景线的颜色
                                      kDotSizeKey : @5,  // 圆点大小
                                      kBigCircleSizeKey : @5.0,
                                      kSmallCircleSizeKey : @3.0
                                      };
    
    lineGraphView.themeAttributes = themeAttributes;
    
    
    lineGraphView.yAxisRange = @(YAXIS_RANGE);
    lineGraphView.yAxisSuffix =  @"K";
    
//    lineGraphView.xAxisValues = @[
//                                  @{ @1 : @"12-12" },
//                                  @{ @2 : @"12-13" },
//                                  @{ @3 : @"12-14" },
//                                  @{ @4 : @"12-15" },
//                                  @{ @5 : @"12-16" },
//                                  @{ @6 : @"12-17" },
//                                  @{ @7 : @"12-18" },
//                                  @{ @7 : @"12-20" },
//                                  @{ @7 : @"12-21" },
//                                  @{ @7 : @"12-22" },
//                                  @{ @7 : @"12-23" },
//                                  @{ @7 : @"12-24" },
//                                  ];
    
    lineGraphView.xAxisValues = @[
                                  @{ @1 : @"12-12" },
                                  @{ @2 : @"12-27" },
                                  @{ @3 : @"01-12" },
                                  @{ @4 : @"01-27" },
                                  @{ @5 : @"02-12" },
                                  @{ @6 : @"02-27" },
                                  @{ @7 : @"03-12" }
                                  ];

    
    lineGraphView.yAxisLabels = @[@"偏低", @"理想", @"正常", @"轻度", @"中度", @"重度"];
    lineGraphView.yAxisLabelColors = @[[UIColor blackColor], [UIColor blueColor], [UIColor cyanColor], [UIColor grayColor], [UIColor orangeColor], [UIColor redColor]];
    lineGraphView.plottingColors = @{
                                     @1 : [UIColor blackColor],
                                     @2 : [UIColor blueColor],
                                     @3 : [UIColor cyanColor],
                                     @4 : [UIColor grayColor],
                                     @5 : [UIColor orangeColor],
                                     @6 : [UIColor redColor]
                                     };
    
    
    // 配置折线1
    YYPlot *plot1 = [[YYPlot alloc] init];
    
    plot1.showCircle = YES;
    
    plot1.plottingValues = @[
                             @{ @1 : @13 },
                             @{ @2 : @20 },
                             @{ @3 : @90 },
                             @{ @4 : @33 },
                             @{ @5 : @79 },
                             @{ @6 : @67 },
                             @{ @7 : @47 },
                             ];


//    plot1.plottingValues = @[
//                             @{ @1.5 : @13 },
//                             @{ @2.5 : @20 },
//                             @{ @3.5 : @90 },
//                             @{ @4.0 : @33 },
//                             @{ @5.5 : @79 },
//                             @{ @6.5 : @67 },
//                             @{ @7.0 : @47 }
//                             ];
    
//    plot1.plottingValues = @[
//                             @{ @1.0 : @13 },
//                             @{ @1.6 : @20 },
//                             @{ @1.9 : @90 },
//                             @{ @2.7 : @33 },
//                             @{ @2.9 : @79 },
//                             @{ @3.3 : @67 },
//                             @{ @7.0 : @47 }
//                             ];
    
    
    NSArray *arr1 = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7"];
    // 选中点popView的label
    plot1.plottingPointsLabels = arr1;
    
    NSDictionary *plotThemeAttributes1 = @{
                                           kPlotFillColorKey : [UIColor colorWithRed:181.0/255.0 green:227.0/255.0 blue:197.0/255.0 alpha:0.5],  // 填充颜色
                                           kPlotStrokeWidthKey : @1,   // 线的宽度
                                           kPlotStrokeColorKey : [UIColor colorWithRed:175.0/255.0 green:174.0/255.0 blue:175.0/255.0 alpha:1], // 线的颜色
                                           kPlotPointFillColorKey : [UIColor whiteColor],  // 点的颜色
                                           kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
                                           };
    
    plot1.plotThemeAttributes = plotThemeAttributes1;
    
    
    // 配置折线2
    YYPlot *plot2 = [[YYPlot alloc] init];
    
    plot2.showCircle = NO;
    
    plot2.plottingValues = @[
                             @{ @1 : @30 },
                             @{ @2 : @40 },
                             @{ @3 : @50 },
                             @{ @4 : @60 },
                             @{ @5 : @70 },
                             @{ @6 : @80 },
                             @{ @7 : @90 }
                             ];
    NSArray *arr2 = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7"];
    // 选中点popView的label
    plot2.plottingPointsLabels = arr2;
    
    NSDictionary *plotThemeAttributes2 = @{
                                           kPlotFillColorKey : [UIColor colorWithRed:181.0/255.0 green:227.0/255.0 blue:197.0/255.0 alpha:0.5],  // 填充颜色
                                           kPlotStrokeWidthKey : @1,   // 线的宽度
                                           kPlotStrokeColorKey : [UIColor colorWithRed:175.0/255.0 green:174.0/255.0 blue:175.0/255.0 alpha:1], // 线的颜色
                                           kPlotPointFillColorKey : [UIColor whiteColor],  // 点的颜色
                                           kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
                                           };
    
    plot2.plotThemeAttributes = plotThemeAttributes2;
    
    
    // 配置折线3
    YYPlot *plot3 = [[YYPlot alloc] init];
    
    plot3.plottingValues = @[
                             @{ @1 : @1.4 },
                             @{ @2 : @90 },
                             @{ @3 : @10 },
                             @{ @4 : @22 },
                             @{ @5 : @33 },
                             @{ @6 : @77 },
                             @{ @7 : @89 }
                             ];
    NSArray *arr3 = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7"];
    // 选中点popView的label
    plot3.plottingPointsLabels = arr3;
    
    NSDictionary *plotThemeAttributes3 = @{
                                           kPlotFillColorKey : [UIColor colorWithRed:181.0/255.0 green:227.0/255.0 blue:197.0/255.0 alpha:0.5],  // 填充颜色
                                           kPlotStrokeWidthKey : @1,   // 线的宽度
                                           kPlotStrokeColorKey : [UIColor colorWithRed:175.0/255.0 green:174.0/255.0 blue:175.0/255.0 alpha:1], // 线的颜色
                                           kPlotPointFillColorKey : [UIColor whiteColor],  // 点的颜色
                                           kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
                                           };
    
    plot3.plotThemeAttributes = plotThemeAttributes3;
    
    
    
    [lineGraphView addPlot:plot1];
    //    [lineGraph addPlot:plot2];
    //    [lineGraph addPlot:plot3];
    
    // 建立折线图
    [lineGraphView setupTheView];
    
    [self.view addSubview:lineGraphView];
}

- (IBAction)animate:(id)sender {
    
    [self.lineGraphView removeFromSuperview];
    
    [self setupLineGraphView];
}
@end
