//
//  ViewController.m
//  LineGraphView
//
//  Created by wildyao on 14/12/3.
//  Copyright (c) 2014年 Wild Yaoyao. All rights reserved.
//

#import "ViewController.h"
#import "YYLineGraphView.h"

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
//    lineGraphView.timeDimensionType = TimeDimensionTypeOneWeek;
//    lineGraphView.timeDimensionType = TimeDimensionTypeOneMonth;
    
    NSDictionary *themeAttributes = @{
                                    kXAxisLabelColorKey : [UIColor colorWithRed:113.0/255.0 green:173.0/255.0 blue:112.0/255.0 alpha:1.0],
                                    kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:12],
                            
                                    kYAxisLabelColorKey : [UIColor blackColor],
                                    kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:13],
                                    kPlotBackgroundLineColorKey : [UIColor colorWithRed:181.0/255.0 green:227.0/255.0 blue:197.0/255.0 alpha:0.5],    // 背景线的颜色
                                    kYAxisLabelSideMarginsKey : @8,     // y轴两边距离
                                    kYAxisLargeDotSizeKey : @5.0,       // y轴大点大小
                                    kYAxisLittleDotSizeKey : @3.0       // y轴小点大小
                                    };
    
    lineGraphView.themeAttributes = themeAttributes;
    
    
    lineGraphView.yAxisRange = @(YAXIS_RANGE);
    lineGraphView.yAxisSuffix =  @"K";
    
    // 这里1、2、3指示作用
    lineGraphView.xAxisValues = @[
                                  @{ @0 : @"12-12" },
                                  @{ @1 : @"12-27" },
                                  @{ @2 : @"01-12" },
                                  @{ @3 : @"01-27" },
                                  @{ @4 : @"02-12" },
                                  @{ @5 : @"02-27" },
                                  @{ @6 : @"03-12" }
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
                             @{ @0 : @13 },
                             @{ @1 : @20 },
                             @{ @2 : @90 },
                             @{ @3 : @33 },
                             @{ @4 : @79 },
                             @{ @60 : @67 },
                             ];

    
    NSArray *arr1 = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7"];
    // 选中点popView的label
    plot1.plottingPointsLabels = arr1;
    
    NSDictionary *plotThemeAttributes1 = @{
                                           kPlotStrokeWidthKey : @1,      // 线的宽度
                                           kPlotStrokeColorKey : [UIColor colorWithRed:175.0/255.0 green:174.0/255.0 blue:175.0/255.0 alpha:1], // 线的颜色
                                           kPlotPointFillColorKey : [UIColor whiteColor],  // 点的颜色
                                           kPlotDotSizeKey : @5,          // 折线圆点大小
                                           kPlotDotWidthKey : @1,         // 折线圆点宽度
                                           kPlotFillColorKey : [UIColor colorWithRed:181.0/255.0 green:227.0/255.0 blue:197.0/255.0 alpha:0.5],   // 填充颜色
                                           };
    
    plot1.plotThemeAttributes = plotThemeAttributes1;
    
    
    // 配置折线2
    YYPlot *plot2 = [[YYPlot alloc] init];
    
    plot2.showCircle = YES;
    
    plot2.plottingValues = @[
                             @{ @0 : @30 },
                             @{ @10 : @40 },
                             @{ @25 : @50 },
                             @{ @45  : @60 },
                             @{ @79 : @70 },
                             @{ @80 : @80 },
                             @{ @90 : @90 }
                             ];
    NSArray *arr2 = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7"];
    // 选中点popView的label
    plot2.plottingPointsLabels = arr2;
    
    NSDictionary *plotThemeAttributes2 = @{
                                           kPlotStrokeWidthKey : @1,      // 线的宽度
                                           kPlotStrokeColorKey : [UIColor colorWithRed:175.0/255.0 green:174.0/255.0 blue:175.0/255.0 alpha:1], // 线的颜色
                                           kPlotPointFillColorKey : [UIColor whiteColor],  // 点的颜色
                                           kPlotFillColorKey : [UIColor colorWithRed:181.0/255.0 green:227.0/255.0 blue:197.0/255.0 alpha:0.5],  // 填充颜色
                                           };
    
    plot2.plotThemeAttributes = plotThemeAttributes2;
    
    
    // 配置折线3
    YYPlot *plot3 = [[YYPlot alloc] init];
    
    plot3.plottingValues = @[
                             @{ @0 : @1.4 },
                             @{ @1 : @90 },
                             @{ @2 : @10 },
                             @{ @3 : @22 },
                             @{ @4 : @33 },
                             @{ @5 : @77 },
                             @{ @6 : @89 }
                             ];
    NSArray *arr3 = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7"];
    // 选中点popView的label
    plot3.plottingPointsLabels = arr3;
    
    NSDictionary *plotThemeAttributes3 = @{
                                           kPlotStrokeWidthKey : @1,      // 线的宽度
                                           kPlotStrokeColorKey : [UIColor colorWithRed:175.0/255.0 green:174.0/255.0 blue:175.0/255.0 alpha:1], // 线的颜色
                                           kPlotPointFillColorKey : [UIColor whiteColor],  // 点的颜色
                                           kPlotFillColorKey : [UIColor colorWithRed:181.0/255.0 green:227.0/255.0 blue:197.0/255.0 alpha:0.5],  // 填充颜色
                                           };
    
    plot3.plotThemeAttributes = plotThemeAttributes3;
    
    
    
    [lineGraphView addPlot:plot1];
//    [lineGraphView addPlot:plot2];
    //    [lineGraphView addPlot:plot3];
    
    // 建立折线图
    [lineGraphView setupTheView];
    
    [self.view addSubview:lineGraphView];
}

- (IBAction)animate:(id)sender {
    
    [self.lineGraphView removeFromSuperview];
    
    [self setupLineGraphView];
}
@end
