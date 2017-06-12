//
//  LocationModel.h
//  ARDemo
//
//  Created by liuRuiLong on 2017/6/8.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>

#define SCREEN_ANGLE 30.0


@interface ARLocationModel : NSObject

/**
 @b 相对于正北边的角度, 顺时针为正
 */
@property (assign, nonatomic) CGFloat angle;

@property (assign, nonatomic)  CGFloat viewRadius;

@property (assign, nonatomic) CGFloat radius;

@property (strong, nonatomic) CLLocation *location;

@property (assign, nonatomic) CLLocation *center;

@property (assign, nonatomic) CGFloat distance;

@property (assign, nonatomic) CGPoint point;

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) CGPoint origin;

-(CGPoint)getCameraPoint;

@end
