//
//  YYPlot.m
//  LineGraphView
//
//  Created by wildyao on 14/12/3.
//  Copyright (c) 2014年 Wild Yaoyao. All rights reserved.
//

#import "YYPlot.h"

@implementation YYPlot

- (instancetype)init
{
    if (self = [super init]) {
        [self loadDefaultTheme];
    }
    
    return self;
}

- (void)loadDefaultTheme
{
    _plotThemeAttributes = @{
                             kPlotFillColorKey : [UIColor colorWithRed:0.47 green:0.75 blue:0.78 alpha:0.5],   // 填充颜色
                             kPlotStrokeWidthKey : @2,   // 线的宽度
                             kPlotStrokeColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],   // 线的颜色
                             kPlotPointFillColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],   // 点的颜色
                             kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:18]
                             };    // popView字体
    
    self.showCircle = YES;
}

// setters
- (void)setPlotThemeAttributes:(NSDictionary *)plotThemeAttributes
{
    _plotThemeAttributes = plotThemeAttributes;
}

@end
