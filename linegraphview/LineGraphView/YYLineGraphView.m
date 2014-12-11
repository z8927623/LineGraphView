//
//  YYLineGraphView.m
//  LineGraphView
//
//  Created by wildyao on 14/12/3.
//  Copyright (c) 2014年 Wild Yaoyao. All rights reserved.
//

#import "YYLineGraphView.h"
#import <objc/runtime.h>
#import "YYPlot.h"
#import "YYXAixsLabel.h"
//#import "PopoverView.h"


@interface YYLineGraphView ()
{
    float _leftMarginToLeave;
    float _plotWidth;
    float _labelMaxWidth;
}

@property (nonatomic, strong) CAShapeLayer *firstCircleLayer;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end


@implementation YYLineGraphView

- (instancetype)init
{
    if ((self = [super init])) {
    
        [self loadDefaultTheme];
        [self setConfiguration];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self loadDefaultTheme];
    [self setConfiguration];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self loadDefaultTheme];
        [self setConfiguration];
    }
    
    return self;
}

- (void)setConfiguration
{
    self.customYAixs = NO;
    
    _labelMaxWidth = 0;
}

// setters
- (void)setThemeAttributes:(NSDictionary *)themeAttributes
{
    _themeAttributes = themeAttributes;
    
    _leftMarginToLeave = [_themeAttributes[kYAxisLabelSideMarginsKey] doubleValue];
    _plotWidth = (self.bounds.size.width - _leftMarginToLeave);
}


- (void)loadDefaultTheme
{
    _themeAttributes = @{
                         kXAxisDateLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                         kXAxisDateLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                         kXAxisWeekLabelColorKey :[UIColor colorWithRed:113.0/255.0 green:173.0/255.0 blue:112.0/255.0 alpha:1.0],   // x轴week label的颜色
                         kXAxisWeekLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],   // x轴week label的字体
                         kYAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                         kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                         kYAxisLabelSideMarginsKey : @10,
                         kPlotBackgroundLineColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                         kDotSizeKey : @10.0,
                         kBigCircleSizeKey : @6.0,
                         kSmallCircleSizeKey : @3.0
                         };
}

- (void)addPlot:(YYPlot *)newPlot
{
    if (newPlot == nil) {
        return;
    }
    
    if (_plots == nil) {
        _plots = [NSMutableArray array];
    }
    
    [_plots addObject:newPlot];
}


- (void)setupTheView
{
    // 为每个折线模型分别画图
    for (YYPlot *plot in _plots) {
        
        if ([_plots indexOfObject:plot] == 0) {
            // 绘制y轴
            
            if (!self.customYAixs) {
                [self drawYLabels_Default:plot];
            } else {
                [self drawYLabels_BloodPressure:plot];
            }
            
//            [self drawYLabels:plot];
            
            
            // 绘制x轴
            [self drawXLabels:plot];
            // 绘制背景线
            [self drawLines:plot];
            // 绘制y轴小圆点
            if (self.customYAixs) {
                [self drawListPoints:plot];
            }
            
            [self drawPlot:plot padding:YES];
            
        } else {
            
            [self setupPointsWithPlot:plot];
            
            [self drawPlot:plot padding:NO];
        }
    }
    
//    if (_plots.count > 1) {
//        // 绘制公共部分
//        [self drawInsection];
//    }
}

//#pragma mark - Actual Plot Drawing Methods
//
//- (void)drawPlotWithPlot:(YYPlot *)plot
//{
//    [self drawYLabels:plot];
//    
//    [self drawXLabels:plot];
//    
//    [self drawLines:plot];
//    
//    [self drawPlot:plot padding:YES];
//    
//    if (self.customYAixs) {
//        [self drawListPoints:plot];
//    }
//}


- (int)getIndexForValue:(NSNumber *)value forPlot:(YYPlot *)plot
{
    for (int i = 0; i < _xAxisValues.count; i++) {
        
        NSDictionary *d = [_xAxisValues objectAtIndex:i];
        __block BOOL foundValue = NO;
        
        [d enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            NSNumber *k = (NSNumber *)key;
            
            if ([k doubleValue] == [value doubleValue]) {
                // If the block sets *stop to YES, the enumeration stops.
                foundValue = YES;
                *stop = foundValue;
            }
        }];
        
        if (foundValue) {
            return i;
        }
    }
    
    return -1;
}

- (void)setupPointsWithPlot:(YYPlot *)plot
{
    NSUInteger xIntervalCount = _xAxisValues.count;
    
    // 横坐标x平均间隔值
    double xIntervalInPx = _plotWidth / _xAxisValues.count;
    
    plot.points = calloc(sizeof(CGPoint), xIntervalCount);

    for (int i = 0; i < xIntervalCount; i++) {
        
        CGPoint currentLabelPoint = CGPointMake(xIntervalInPx*i+_leftMarginToLeave, self.bounds.size.height-BOTTOM_MARGIN_TO_LEAVE);
        CGRect xLabelFrame = CGRectMake(currentLabelPoint.x, currentLabelPoint.y, xIntervalInPx, BOTTOM_MARGIN_TO_LEAVE);
        // point在label中间
        plot.points[i] = CGPointMake((int)xLabelFrame.origin.x + xLabelFrame.size.width/2, (int)0);
    }
}

- (void)drawInsection
{
    NSUInteger totalCount = 0;

    for (YYPlot *plot in _plots) {
        totalCount += plot.plottingValues.count;
    }


    CAShapeLayer *insectionLayer = [CAShapeLayer layer];
    insectionLayer.frame = self.bounds;
    insectionLayer.fillColor = ([UIColor greenColor]).CGColor;
    insectionLayer.backgroundColor = [UIColor clearColor].CGColor;
    insectionLayer.strokeColor = [UIColor clearColor].CGColor;
    insectionLayer.lineWidth = 1;
    
    CGMutablePathRef insectionPath = CGPathCreateMutable();
    
    YYPlot *firstPlot = _plots[0];
    CGPathMoveToPoint(insectionPath, NULL, firstPlot.points[0].x, firstPlot.points[0].y);
    
    for (YYPlot *plot in _plots) {
        
        NSArray *plottingValues = plot.plottingValues;
        CGPoint *points = plot.points;
        
        if ([_plots indexOfObject:plot] == 0) {
            for (int j = 0; j < plottingValues.count; j++) {
                CGPathAddLineToPoint(insectionPath, NULL, points[j].x, points[j].y);
            }
        } else {

            for (NSUInteger j = plottingValues.count-1; j+1 >= 1; j--) {
                
                CGPathAddLineToPoint(insectionPath, NULL, points[j].x, points[j].y);
                
                if (j == 0) {
                    break;
                }
            }
        }
    }
    
    CGPathCloseSubpath(insectionPath);
    
    insectionLayer.path = insectionPath;
    
    [self.layer insertSublayer:insectionLayer below:self.firstCircleLayer];
}


// 画y轴
- (void)drawYLabels:(YYPlot *)plot
{
    double yRange = [_yAxisRange doubleValue];
    // 纵坐标y平均间隔值
    double yIntervalValue = yRange / INTERVAL_COUNT;
    // 纵坐标y平均间隔大小
    double intervalInPx = (self.bounds.size.height-BOTTOM_MARGIN_TO_LEAVE) / (INTERVAL_COUNT+1);
    
    NSMutableArray *labelArray = [NSMutableArray array];
    
    if (!self.customYAixs) {
        
        for (int i = INTERVAL_COUNT+1; i >= 0; i--) {
            
            // y轴0开始往上画
            CGPoint currentLinePoint = CGPointMake(_leftMarginToLeave, i * intervalInPx);
            
            CGRect labelFrame = CGRectMake(0, currentLinePoint.y-(intervalInPx/2), 100, intervalInPx);
            
            if (i != 0) {
                
                UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:labelFrame];
                
                yAxisLabel.backgroundColor = [UIColor clearColor];
                yAxisLabel.font = (UIFont *)_themeAttributes[kYAxisLabelFontKey];
                yAxisLabel.textColor = (UIColor *)_themeAttributes[kYAxisLabelColorKey];
                yAxisLabel.textAlignment = NSTextAlignmentCenter;
                
                float val = yIntervalValue * (INTERVAL_COUNT+1-i);
                
                if (val > 0) {
                    yAxisLabel.text = [NSString stringWithFormat:@"%.1f%@", val, _yAxisSuffix];
                } else {
                    yAxisLabel.text = [NSString stringWithFormat:@"%.0f", val];
                }
                
                [yAxisLabel sizeToFit];
                
                // y轴中间对齐线段
                CGRect newLabelFrame = CGRectMake(0, currentLinePoint.y-(yAxisLabel.layer.frame.size.height/2), yAxisLabel.frame.size.width, yAxisLabel.layer.frame.size.height);
                yAxisLabel.frame = newLabelFrame;
                
                // 最大宽度
                if (newLabelFrame.size.width > _labelMaxWidth) {
                    _labelMaxWidth = newLabelFrame.size.width;
                }
                
                [labelArray addObject:yAxisLabel];
                [self addSubview:yAxisLabel];
            }
        }
        
        // _leftMarginToLeave等于宽度+margin
        _leftMarginToLeave = _labelMaxWidth + [_themeAttributes[kYAxisLabelSideMarginsKey] doubleValue];
        _plotWidth = (self.bounds.size.width - _leftMarginToLeave);
        
    } else {                    // 自定义
        
        for (int i = INTERVAL_COUNT; i >= 0; i--) {
            
            // y轴0开始往上画
            CGPoint currentLinePoint = CGPointMake(_leftMarginToLeave, i * intervalInPx);
            
            CGRect labelFrame = CGRectMake(0, currentLinePoint.y-(intervalInPx/2), 100, intervalInPx);
            
            if (i != 0) {
                
                UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:labelFrame];
                
                yAxisLabel.backgroundColor = [UIColor clearColor];
                yAxisLabel.font = (UIFont *)_themeAttributes[kYAxisLabelFontKey];
                yAxisLabel.textColor = (UIColor *)_themeAttributes[kYAxisLabelColorKey];
                yAxisLabel.textAlignment = NSTextAlignmentCenter;
                
                if (INTERVAL_COUNT-i > _yAxisLabels.count-1 || INTERVAL_COUNT-i < 0) {
                    yAxisLabel.text = @"";
                } else {
                    yAxisLabel.text = _yAxisLabels[INTERVAL_COUNT-i];
                }
                
                [yAxisLabel sizeToFit];
                
                // y轴中间对齐线段
                
                CGRect newLabelFrame = CGRectMake(0, currentLinePoint.y+(intervalInPx-yAxisLabel.layer.frame.size.height)/2, yAxisLabel.frame.size.width, yAxisLabel.layer.frame.size.height);
                yAxisLabel.frame = newLabelFrame;
                
                // 最大宽度
                if (newLabelFrame.size.width > _labelMaxWidth) {
                    _labelMaxWidth = newLabelFrame.size.width;
                }
                
                [labelArray addObject:yAxisLabel];
                [self addSubview:yAxisLabel];
            }
        }
        
        // _leftMarginToLeave等于宽度+margin
        _leftMarginToLeave = _labelMaxWidth + [_themeAttributes[kYAxisLabelSideMarginsKey] doubleValue]*2;
        _plotWidth = (self.bounds.size.width - _leftMarginToLeave);
    }
}

- (void)drawYLabels_Default:(YYPlot *)plot
{
    double yRange = [_yAxisRange doubleValue];
    // 纵坐标y平均间隔值
    double yIntervalValue = yRange / INTERVAL_COUNT;
    // 纵坐标y平均间隔大小
    double intervalInPx = (self.bounds.size.height-BOTTOM_MARGIN_TO_LEAVE) / (INTERVAL_COUNT+1);
    
    NSMutableArray *labelArray = [NSMutableArray array];
    
    for (int i = INTERVAL_COUNT+1; i >= 0; i--) {
        
        // y轴0开始往上画
        CGPoint currentLinePoint = CGPointMake(_leftMarginToLeave, i * intervalInPx);
        
        CGRect labelFrame = CGRectMake(0, currentLinePoint.y-(intervalInPx/2), 100, intervalInPx);
        
        if (i != 0) {
            
            UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:labelFrame];
            
            yAxisLabel.backgroundColor = [UIColor clearColor];
            yAxisLabel.font = (UIFont *)_themeAttributes[kYAxisLabelFontKey];
            yAxisLabel.textColor = (UIColor *)_themeAttributes[kYAxisLabelColorKey];
            yAxisLabel.textAlignment = NSTextAlignmentCenter;
            
            float val = yIntervalValue * (INTERVAL_COUNT+1-i);
            
            if (val > 0) {
                yAxisLabel.text = [NSString stringWithFormat:@"%.1f%@", val, _yAxisSuffix];
            } else {
                yAxisLabel.text = [NSString stringWithFormat:@"%.0f", val];
            }
            
            [yAxisLabel sizeToFit];
            
            // y轴中间对齐线段
            CGRect newLabelFrame = CGRectMake(0, currentLinePoint.y-(yAxisLabel.layer.frame.size.height/2), yAxisLabel.frame.size.width, yAxisLabel.layer.frame.size.height);
            yAxisLabel.frame = newLabelFrame;
            
            // 最大宽度
            if (newLabelFrame.size.width > _labelMaxWidth) {
                _labelMaxWidth = newLabelFrame.size.width;
            }
            
            [labelArray addObject:yAxisLabel];
            [self addSubview:yAxisLabel];
        }
    }
    
    // _leftMarginToLeave等于宽度+margin
    _leftMarginToLeave = _labelMaxWidth + [_themeAttributes[kYAxisLabelSideMarginsKey] doubleValue];
    _plotWidth = (self.bounds.size.width - _leftMarginToLeave);
}

// 画y轴
- (void)drawYLabels_BloodPressure:(YYPlot *)plot
{
    // 纵坐标y平均间隔大小
    double intervalInPx = (self.bounds.size.height-BOTTOM_MARGIN_TO_LEAVE) / (INTERVAL_COUNT+1);
    
    NSMutableArray *labelArray = [NSMutableArray array];
    
    for (int i = INTERVAL_COUNT; i >= 0; i--) {
        
        // y轴0开始往上画
        CGPoint currentLinePoint = CGPointMake(_leftMarginToLeave, i * intervalInPx);
        
        CGRect labelFrame = CGRectMake(0, currentLinePoint.y-(intervalInPx/2), 100, intervalInPx);
        
        if (i != 0) {
            
            UILabel *yAxisLabel = [[UILabel alloc] initWithFrame:labelFrame];
            
            yAxisLabel.backgroundColor = [UIColor clearColor];
            yAxisLabel.font = (UIFont *)_themeAttributes[kYAxisLabelFontKey];
            yAxisLabel.textColor = (UIColor *)_themeAttributes[kYAxisLabelColorKey];
            yAxisLabel.textAlignment = NSTextAlignmentCenter;
            
            if (INTERVAL_COUNT-i > _yAxisLabels.count-1 || INTERVAL_COUNT-i < 0) {
                yAxisLabel.text = @"";
            } else {
                yAxisLabel.text = _yAxisLabels[INTERVAL_COUNT-i];
            }
            
            [yAxisLabel sizeToFit];
            
            // y轴中间对齐线段
            
            CGRect newLabelFrame = CGRectMake(0, currentLinePoint.y+(intervalInPx-yAxisLabel.layer.frame.size.height)/2, yAxisLabel.frame.size.width, yAxisLabel.layer.frame.size.height);
            yAxisLabel.frame = newLabelFrame;
            
            // 最大宽度
            if (newLabelFrame.size.width > _labelMaxWidth) {
                _labelMaxWidth = newLabelFrame.size.width;
            }
            
            [labelArray addObject:yAxisLabel];
            [self addSubview:yAxisLabel];
        }
    }
    
    // _leftMarginToLeave等于宽度+margin
    _leftMarginToLeave = _labelMaxWidth + [_themeAttributes[kYAxisLabelSideMarginsKey] doubleValue]*2;
    _plotWidth = (self.bounds.size.width - _leftMarginToLeave);
}


// 画x轴
- (void)drawXLabels:(YYPlot *)plot
{
    NSUInteger xIntervalCount = _xAxisValues.count;

    // 横坐标x平均间隔值
    double xIntervalInPx = _plotWidth / _xAxisValues.count;
    
    plot.points = calloc(sizeof(CGPoint), xIntervalCount);
    
    for (int i = 0; i < xIntervalCount; i++) {
        
        CGPoint currentLabelPoint = CGPointMake(xIntervalInPx*i+_leftMarginToLeave, self.bounds.size.height-BOTTOM_MARGIN_TO_LEAVE);
        CGRect xLabelFrame = CGRectMake(currentLabelPoint.x, currentLabelPoint.y, xIntervalInPx, BOTTOM_MARGIN_TO_LEAVE);
        
        // point在label中间
        plot.points[i] = CGPointMake((int)xLabelFrame.origin.x + xLabelFrame.size.width/2, (int)0);

        NSDictionary *dic = [_xAxisValues objectAtIndex:i];
        
        __block NSString *xLabel = nil;
        // 枚举字典
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            xLabel = (NSString *)obj;
        }];
        
        NSString *date = [NSString stringWithFormat:@"%@", xLabel];
        
        YYXAixsLabel *xAxisLabel = [[YYXAixsLabel alloc] initWithFrame:xLabelFrame dateLbl:date weekLbl:@"呵呵" andThemeAttributes:_themeAttributes];
        [self addSubview:xAxisLabel];
    }
}


// 画背景线
- (void)drawLines:(YYPlot *)plot
{
    CAShapeLayer *linesLayer = [CAShapeLayer layer];
    linesLayer.frame = self.bounds;
    linesLayer.fillColor = [UIColor clearColor].CGColor;
    linesLayer.strokeColor = ((UIColor *)_themeAttributes[kPlotBackgroundLineColorKey]).CGColor;
    linesLayer.backgroundColor = [UIColor clearColor].CGColor;
    linesLayer.lineWidth = 1;
    
    CGMutablePathRef linesPath = CGPathCreateMutable();
    double intervalInPx = (self.bounds.size.height-BOTTOM_MARGIN_TO_LEAVE) / (INTERVAL_COUNT+1);
    
    for (int i = INTERVAL_COUNT; i > 0; i--) {
    
        CGPoint currentLinePoint = CGPointMake(_leftMarginToLeave, i * intervalInPx);
        
        CGPathMoveToPoint(linesPath, NULL, currentLinePoint.x, currentLinePoint.y);
        CGPathAddLineToPoint(linesPath, NULL, currentLinePoint.x + _plotWidth, currentLinePoint.y);
    }
    
    linesLayer.path = linesPath;
    
    [self.layer addSublayer:linesLayer];
    
    
    CAShapeLayer *linesLayer_last = [CAShapeLayer layer];
    linesLayer_last.frame = self.bounds;
    linesLayer_last.fillColor = [UIColor clearColor].CGColor;
    linesLayer_last.strokeColor = ([UIColor colorWithRed:113.0/255.0 green:173.0/255.0 blue:112.0/255.0 alpha:1.0]).CGColor;
    linesLayer_last.backgroundColor = [UIColor clearColor].CGColor;
    linesLayer_last.lineWidth = 1;
    
    CGMutablePathRef linesPath_last = CGPathCreateMutable();

    CGPoint currentLinePoint = CGPointMake(_leftMarginToLeave, (INTERVAL_COUNT+1) * intervalInPx);
    
    CGPathMoveToPoint(linesPath_last, NULL, currentLinePoint.x, currentLinePoint.y);
    CGPathAddLineToPoint(linesPath_last, NULL, currentLinePoint.x + _plotWidth, currentLinePoint.y);
   
    linesLayer_last.path = linesPath_last;
    
    [self.layer addSublayer:linesLayer_last];
}

- (void)drawListPoints:(YYPlot *)plot
{
    // 小点
    CAShapeLayer *circleLayer1 = [CAShapeLayer layer];
    circleLayer1.frame = self.bounds;
    circleLayer1.fillColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    circleLayer1.strokeColor = [UIColor clearColor].CGColor;
    circleLayer1.backgroundColor = [UIColor clearColor].CGColor;
    circleLayer1.lineWidth = 1;
    
    CGMutablePathRef circlePath1 = CGPathCreateMutable();
    
    double intervalInPx = (self.bounds.size.height-BOTTOM_MARGIN_TO_LEAVE) / (INTERVAL_COUNT+1);
    int smallCircleSize = [_themeAttributes[kSmallCircleSizeKey] intValue];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = INTERVAL_COUNT+1; i > 0; i--) {
        [tempArr addObject:@(i)];
    }
    
    for (float i = INTERVAL_COUNT+1; i > 0; i -= 1.0/SMALL_CIRCLE_COUNT) {
        CGPoint currentLinePoint = CGPointMake(_leftMarginToLeave, i * intervalInPx);
        
        if ((i >= 1 && ![tempArr containsObject:@(i)]) || ([tempArr containsObject:@(i)] && [tempArr indexOfObject:@(i)] == tempArr.count-1)) {
            
            CGPathAddEllipseInRect(circlePath1, NULL, CGRectMake(currentLinePoint.x-(_leftMarginToLeave-_labelMaxWidth)/2-smallCircleSize/2, currentLinePoint.y-smallCircleSize/2, smallCircleSize, smallCircleSize));
        }
    }
    circleLayer1.path = circlePath1;
    
    [self.layer addSublayer:circleLayer1];
    
    
    // 大点
    int bigCircleSize = [_themeAttributes[kBigCircleSizeKey] intValue];
    
    for (int i = INTERVAL_COUNT; i > 0; i--) {
        
        CGPoint currentLinePoint = CGPointMake(_leftMarginToLeave, (i+1) * intervalInPx);
        
        CAShapeLayer *circleLayer2 = [CAShapeLayer layer];
        circleLayer2.frame = CGRectMake(currentLinePoint.x-(_leftMarginToLeave-_labelMaxWidth)/2-bigCircleSize/2, currentLinePoint.y-bigCircleSize/2, bigCircleSize, bigCircleSize);
        circleLayer2.fillColor = [UIColor clearColor].CGColor;
        circleLayer2.strokeColor = [UIColor clearColor].CGColor;
        circleLayer2.backgroundColor = [UIColor clearColor].CGColor;
        circleLayer2.lineWidth = 1;
        
        CGMutablePathRef circlePath2 = CGPathCreateMutable();
        
        if (i != 0) {
            
            if (INTERVAL_COUNT-i > _yAxisLabels.count-1 || INTERVAL_COUNT-i < 0) {
                circleLayer2.fillColor = [UIColor clearColor].CGColor;
            } else {
                circleLayer2.fillColor = ((UIColor *)_yAxisLabelColors[INTERVAL_COUNT-i]).CGColor;
            }
            
            CGPathAddEllipseInRect(circlePath2, NULL, CGRectMake(0, 0, bigCircleSize, bigCircleSize));
        }
        
        circleLayer2.path = circlePath2;
        
        [self.layer addSublayer:circleLayer2];
    }
}

- (void)drawPlot:(YYPlot *)plot padding:(BOOL)pad
{
    //      高  -------> 低
    // 层次：背景 > 折线 > 圆形
    
    NSDictionary *theme = plot.plotThemeAttributes;
    
    // 背景
    CAShapeLayer *backgroundLayer = [CAShapeLayer layer];
    
    backgroundLayer.frame = self.bounds;
    backgroundLayer.fillColor = ((UIColor *)theme[kPlotFillColorKey]).CGColor;
    backgroundLayer.backgroundColor = [UIColor clearColor].CGColor;
    backgroundLayer.strokeColor = [UIColor clearColor].CGColor;
    backgroundLayer.lineWidth = ((NSNumber *)theme[kPlotStrokeWidthKey]).intValue;
    
    CGMutablePathRef backgroundPath = CGPathCreateMutable();
    
    // 线段
    CAShapeLayer *graphLayer = [CAShapeLayer layer];
    graphLayer.frame = self.bounds;
    graphLayer.fillColor = [UIColor clearColor].CGColor;
    graphLayer.backgroundColor = [UIColor clearColor].CGColor;
    graphLayer.strokeColor = ((UIColor *)theme[kPlotStrokeColorKey]).CGColor;
    graphLayer.lineWidth = ((NSNumber *)theme[kPlotStrokeWidthKey]).intValue;
    
    CGMutablePathRef graphPath = CGPathCreateMutable();
    
    double yRange = [_yAxisRange doubleValue];
    
    // 纵坐标y平均间隔值
    double yIntervalValue = yRange / INTERVAL_COUNT;
    
    [plot.plottingValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *dic = (NSDictionary *)obj;
        
        __block NSNumber *_key = nil;
        __block NSNumber *_value = nil;
        
        // 获取key和value
        [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            _key = (NSNumber *)key;
            _value = (NSNumber *)obj;
        }];
        
        // 获得该key的index
        int xIndex = [self getIndexForValue:_key forPlot:plot];
        
        // x value
        double height = self.bounds.size.height - BOTTOM_MARGIN_TO_LEAVE;
        
        double y = height - ((height / ([_yAxisRange doubleValue] + yIntervalValue)) * [_value doubleValue]);
        
        plot.points[xIndex].x = ceil(plot.points[xIndex].x);
        plot.points[xIndex].y = ceil(y);
        
    }];
    
//    // 移到初始点
//    CGPathMoveToPoint(graphPath, NULL, _leftMarginToLeave, plot.points[0].y);
//    CGPathMoveToPoint(backgroundPath, NULL, _leftMarginToLeave, plot.points[0].y);
    
    NSUInteger count = _xAxisValues.count;

    CGPoint firstPoint = plot.points[0];
    CGPoint lastPoint = plot.points[count-1];
    
    for (int i = 0; i < count; i++) {
        
        CGPoint point = plot.points[i];
        
        if (i == 0) {
            CGPathMoveToPoint(graphPath, NULL, point.x, point.y);
            CGPathMoveToPoint(backgroundPath, NULL, point.x, point.y);
        }
        
        // 画线段
        CGPathAddLineToPoint(graphPath, NULL, point.x, point.y);
        // 画背景
        CGPathAddLineToPoint(backgroundPath, NULL, point.x, point.y);
    }
    
    // 额外的线段
//    CGPathAddLineToPoint(graphPath, NULL, _leftMarginToLeave + _plotWidth, plot.points[count-1].y);

    // 右边顶部
//    CGPathAddLineToPoint(backgroundPath, NULL, _leftMarginToLeave + _plotWidth, plot.points[count-1].y);
    
    // 右边底部
    CGPathAddLineToPoint(backgroundPath, NULL, lastPoint.x, self.bounds.size.height-BOTTOM_MARGIN_TO_LEAVE-1);
    // 回到第一个点
    CGPathAddLineToPoint(backgroundPath, NULL, firstPoint.x, self.bounds.size.height-BOTTOM_MARGIN_TO_LEAVE-1);
    // 关闭path，形成封闭区域
    CGPathCloseSubpath(backgroundPath);
    
    backgroundLayer.path = backgroundPath;
    graphLayer.path = graphPath;
    
    // animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.delegate = self;
    animation.duration = 0.5;
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    [graphLayer addAnimation:animation forKey:@"strokeEnd"];
    
    
    if (pad) {                  // 填充折线图背景
        
        [self.layer addSublayer:backgroundLayer];
        
        // 渐变
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        self.gradientLayer = gradientLayer;
        
        gradientLayer.frame = backgroundLayer.bounds;
        //    gradientLayer.colors = @[[UIColor colorWithRed:0.251 green:0.232 blue:1.000 alpha:1.000],[UIColor colorWithRed:0.282 green:0.945 blue:1.000 alpha:1.000]];
        gradientLayer.colors = @[(id)[[UIColor orangeColor] CGColor], (id)[[UIColor whiteColor] CGColor]];
        // 起始点
        gradientLayer.startPoint = CGPointMake(0, 0);
        // 结束点
        gradientLayer.endPoint   = CGPointMake(0, 1);
        gradientLayer.mask = backgroundLayer;
//        [self.layer addSublayer:gradientLayer];

    }
   
    [self.layer addSublayer:graphLayer];
    
    if (plot.showCircle) {
        
        for (int i = 0; i < count; i++) {
            
            CGPoint point = plot.points[i];
            double yValue = [[plot.plottingValues[i] objectForKey:@(i+1)] doubleValue];
            
            // 纵坐标y平均间隔值
            double yIntervalValue = yRange / INTERVAL_COUNT;
            int y = yValue / yIntervalValue;
            
            CGFloat dotsSize = [_themeAttributes[kDotSizeKey] floatValue];
            
            // 圆点
            CAShapeLayer *circleLayer = [CAShapeLayer layer];
            circleLayer.frame = CGRectMake(point.x-dotsSize/2.0, point.y-dotsSize/2.0, dotsSize, dotsSize);
            circleLayer.fillColor = [UIColor whiteColor].CGColor;
            circleLayer.backgroundColor = [UIColor clearColor].CGColor;
            
            if ([_plottingColors objectForKey:@(y+1)] != nil) {
                circleLayer.strokeColor = ((UIColor *)[_plottingColors objectForKey:@(y+1)]).CGColor;
            } else {        // 超过限度，颜色等于最后一个颜色
                NSUInteger count = _plottingColors.count;
                circleLayer.strokeColor = ((UIColor *)[_plottingColors objectForKey:@(count)]).CGColor;
            }
            
            
            circleLayer.lineWidth = ((NSNumber *)theme[kPlotStrokeWidthKey]).intValue;
            
            CGMutablePathRef circlePath = CGPathCreateMutable();
            
            // 画点
            CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(0, 0, dotsSize, dotsSize));
            
            circleLayer.path = circlePath;
            [self.layer addSublayer:circleLayer];
            
            if (i == 0) {
                self.firstCircleLayer = circleLayer;
            }
        }
    }
    
    
    NSUInteger count2 = _xAxisValues.count;
    
    for (int i = 0; i < count2; i++) {
        CGPoint point = plot.points[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = i;
        btn.frame = CGRectMake(point.x-20, point.y-20, 40, 40);
        [btn addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // 关联btn与plot
        // 关联对象：btn，关联key：kAssociatedPlotObject，关联value：plot
        objc_setAssociatedObject(btn, kAssociatedPlotObject, plot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self addSubview:btn];
    }
}

#pragma mark - UIButton event methods

- (void)clicked:(id)sender
{
    @try {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        lbl.backgroundColor = [UIColor clearColor];
        
        UIButton *btn = (UIButton *)sender;
        NSUInteger tag = btn.tag;
        
        // 获取关联的plot
        YYPlot *_plot = objc_getAssociatedObject(btn, kAssociatedPlotObject);
        NSString *text = [_plot.plottingPointsLabels objectAtIndex:tag];
        
        lbl.text = text;
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = (UIFont *)_plot.plotThemeAttributes[kPlotPointValueFontKey];
        [lbl sizeToFit];
        lbl.frame = CGRectMake(0, 0, lbl.frame.size.width + 5, lbl.frame.size.height);
        
        CGPoint point = ((UIButton *)sender).center;
        point.y -= 15;
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [PopoverView showPopoverAtPoint:point inView:self withContentView:lbl delegate:nil];
        });
    }
    @catch (NSException *exception) {
        NSLog(@"plotting label is not available for this point");
    }
    
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeIn.fromValue = [NSNumber numberWithFloat:0.0];
    fadeIn.toValue = [NSNumber numberWithFloat:1.0];
    fadeIn.duration = 0.5;
    
    [self.gradientLayer addAnimation:fadeIn forKey:@"flashAnimation"];
    // 插入到点下面
    [self.layer insertSublayer:self.gradientLayer below:self.firstCircleLayer];
}

@end
