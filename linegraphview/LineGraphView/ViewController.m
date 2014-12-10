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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    // 配置graphView
    YYLineGraphView *lineGraph = [[YYLineGraphView alloc] initWithFrame:CGRectMake(0, 20, 320, 180)];
    
    lineGraph.customYAixs = YES;
    
    NSDictionary *themeAttributes = @{
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
    
    lineGraph.themeAttributes = themeAttributes;
    
    
    lineGraph.yAxisRange = @(YAXIS_RANGE);
    lineGraph.yAxisSuffix =  @"K";
    
    lineGraph.xAxisValues = @[
                               @{ @1 : @"周五" },
                               @{ @2 : @"周六" },
                               @{ @3 : @"周日" },
                               @{ @4 : @"周一" },
                               @{ @5 : @"周二" },
                               @{ @6 : @"周三" },
                               @{ @7 : @"周四" },
                               ];
    lineGraph.yAxisLabels = @[@"偏低", @"理想", @"正常", @"轻度", @"中度", @"重度"];
    lineGraph.yAxisLabelColors = @[[UIColor blackColor], [UIColor blueColor], [UIColor cyanColor], [UIColor grayColor], [UIColor orangeColor], [UIColor redColor]];
    lineGraph.plottingColors = @{
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
                              @{ @7 : @47 }
                              ];
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
    
    
    
    [lineGraph addPlot:plot1];
//    [lineGraph addPlot:plot2];
//    [lineGraph addPlot:plot3];
    
    // 建立折线图
    [lineGraph setupTheView];
    
    [self.view addSubview:lineGraph];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
