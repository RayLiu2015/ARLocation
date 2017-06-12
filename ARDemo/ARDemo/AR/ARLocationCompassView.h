//
//  SYCompassView.h
//  SYCompassDemo
//
//  Created by codeWorm on 16/6/27.
//  Copyright © 2016年 codeWorm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLocationCalculator.h"

@interface ARLocationCompassView : UIView

/**
 *  初始化
 *
 *  @param radius 半径（最小不小于50，最大不大于控件短边的一半）
 *
 *  @return 返回罗盘对象
 */
+ (instancetype)sharedWithRect:(CGRect)rect radius:(CGFloat)radius;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *calibrationColor;
@property (nonatomic, strong) UIColor *northColor;
@property (nonatomic, strong) UIColor *horizontalColor;

- (void)updateHeading:(CLLocationDirection)theHeading;
@end
