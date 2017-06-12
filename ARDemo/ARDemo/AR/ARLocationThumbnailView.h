//
//  ARMsgDataView.h
//  FeelfelCode
//
//  Created by 李策 on 2017/6/3.
//  Copyright © 2017年 李策. All rights reserved.
//
#import "ARLocationModel.h"

#import <UIKit/UIKit.h>

@interface ARLocationThumbnailView : UIView

@property (nonatomic, strong) CAShapeLayer *ringLayer;

-(void)addDataWithLocationModel:(ARLocationModel *)model;
-(void)updateHeading:(CGFloat)heading;
-(void)clear;

@end
