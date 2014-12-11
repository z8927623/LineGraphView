//
//  YYPlot.h
//  LineGraphView
//
//  Created by wildyao on 14/12/3.
//  Copyright (c) 2014年 Wild Yaoyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYLineGraphViewConstants.h"

// 点信息类

@interface YYPlot : NSObject

// 该折线图坐标点数据
@property (nonatomic, strong) NSArray *plottingValues;

// 坐标点被点击时候popView上显示内容
@property (nonatomic, strong) NSArray *plottingPointsLabels;

// 指向CGPoint的指针
@property (nonatomic) CGPoint *points;

// 圆点的主题
@property (nonatomic) NSDictionary *plotThemeAttributes;

// 是否显示圆点
@property (nonatomic, assign) BOOL showCircle;

@end
