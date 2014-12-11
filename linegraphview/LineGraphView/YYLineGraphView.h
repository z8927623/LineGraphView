//
//  YYLineGraphView.h
//  LineGraphView
//
//  Created by wildyao on 14/12/3.
//  Copyright (c) 2014年 Wild Yaoyao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYPlot;

@interface YYLineGraphView : UIView

// x坐标数据
@property (nonatomic, strong) NSArray *xAxisValues;

// y坐标数据
@property (nonatomic, strong) NSArray *yAxisValues;

// y轴上的label
@property (nonatomic, strong) NSArray *yAxisLabels;

// y轴label的颜色
@property (nonatomic, strong) NSArray *yAxisLabelColors;

// 点的颜色字典
@property (nonatomic, strong) NSDictionary *plottingColors;

// y坐标大小范围
@property (nonatomic, strong) NSNumber *yAxisRange;

// y坐标后缀，多用于单位
@property (nonatomic, strong) NSString *yAxisSuffix;

// 折线图模型数组，多个plot就代表多个折线
@property (nonatomic, readonly, strong) NSMutableArray *plots;

// 主题字典
@property (nonatomic, strong) NSDictionary *themeAttributes;

// 是否自定义y轴
@property (nonatomic, assign) BOOL customYAixs;

- (void)addPlot:(YYPlot *)plot;

- (void)setupTheView;

@end
