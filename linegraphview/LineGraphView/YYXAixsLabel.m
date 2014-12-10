//
//  YYXAixsLabel.m
//  LineGraphView
//
//  Created by wildyao on 14/12/5.
//  Copyright (c) 2014年 Wild Yaoyao. All rights reserved.
//

#import "YYXAixsLabel.h"
#import "YYLineGraphViewConstants.h"

#define TOP_MARGIN 2

@implementation YYXAixsLabel

- (id)initWithFrame:(CGRect)frame dateLbl:(NSString *)date weekLbl:(NSString *)week andThemeAttributes:(NSDictionary *)themeAttributes
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, TOP_MARGIN, frame.size.width, frame.size.height/2-TOP_MARGIN)];
        dateLbl.backgroundColor = [UIColor clearColor];
        dateLbl.textColor = [UIColor colorWithRed:113.0/255.0 green:173.0/255.0 blue:112.0/255.0 alpha:1.0];
        dateLbl.font = (UIFont *)themeAttributes[kXAxisDateLabelFontKey];
        dateLbl.textColor = (UIColor *)themeAttributes[kXAxisDateLabelColorKey];
        dateLbl.textAlignment = NSTextAlignmentCenter;
        dateLbl.text = date;
        [self addSubview:dateLbl];
        
        UILabel *weekLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2-TOP_MARGIN)];
        weekLbl.backgroundColor = [UIColor clearColor];
        weekLbl.font = (UIFont *)themeAttributes[kXAxisWeekLabelFontKey];
        weekLbl.textColor = (UIColor *)themeAttributes[kXAxisWeekLabelColorKey];
        weekLbl.textAlignment = NSTextAlignmentCenter;
        weekLbl.text = week;
        [self addSubview:weekLbl];
    }
    
    return self;
}


@end
