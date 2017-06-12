//
//  CameraView.h
//  ARDemo
//
//  Created by liuRuiLong on 2017/6/8.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

#import "ARLocationVC.h"
#import "ARLocationModel.h"
#import <Foundation/Foundation.h>

@interface ARLocationCameraView : UIView

@property (strong, nonatomic) ARLocationLabelStyle *style;

-(void)addLocations:(NSArray<ARLocationModel *> *)locations;
-(void)transformWithAngle:(CGFloat)angle;
-(void)addLocation:(ARLocationModel *)location;
-(void)clear;

@end
