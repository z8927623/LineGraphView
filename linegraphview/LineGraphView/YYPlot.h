//
//  YYPlot.h
//  LineGraphView
//
//  Created by wildyao on 14/12/3.
//  Copyright (c) 2014年 Wild Yaoyao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYLineGraphViewConstants.h"

@interface YYPlot : NSObject

// 该折线图坐标点数据
@property (nonatomic, strong) NSArray *plottingValues;

// 坐标点被点击时候popView上显示内容
@property (nonatomic, strong) NSArray *plottingPointsLabels;

@property (nonatomic) CGPoint *points;

@property (nonatomic) NSDictionary *plotThemeAttributes;

@property (nonatomic, assign) BOOL showCircle;

@end
