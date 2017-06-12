//
//  LocationCalculator.h
//  ARDemo
//
//  Created by liuRuiLong on 2017/6/8.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

#import "ARLocationModel.h"
#import <Foundation/Foundation.h>

@interface ARLocationCalculator : NSObject

+(ARLocationModel *)getPointWithCenterLocation:(CLLocation *)center radius:(CGFloat)radius viewRadius:(CGFloat)viewRadius aroundLocation:(CLLocation *)aroundLocation;

@end
