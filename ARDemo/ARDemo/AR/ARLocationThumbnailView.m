
//
//  ARMsgDataView.m
//  FeelfelCode
//
//  Created by 李策 on 2017/6/3.
//  Copyright © 2017年 李策. All rights reserved.
//

#import "ARLocationModel.h"
#import "ARLocationCalculator.h"
#import "ARLocationThumbnailView.h"

#import <CoreLocation/CoreLocation.h>

#import <CoreLocation/CoreLocation.h>

@interface ARLocationThumbnailView ()
@property (nonatomic, strong) CAShapeLayer *arcLayer;
@end


@implementation ARLocationThumbnailView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //        [self setNeedsDisplay];
        self.ringLayer = [[CAShapeLayer alloc]init];
        self.ringLayer.frame = self.bounds;
        self.ringLayer.lineWidth = 1;
        self.ringLayer.fillColor = [UIColor clearColor].CGColor;
        self.ringLayer.strokeColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:self.ringLayer];
        
        self.arcLayer = [[CAShapeLayer alloc]init];
        self.arcLayer.frame = self.bounds;
        self.arcLayer.lineWidth = 1;
        self.arcLayer.fillColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6].CGColor;
        self.arcLayer.strokeColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.6].CGColor;
        [self.layer addSublayer:self.arcLayer];
        
        [self drawRingLayer];
        [self drawArcLayer];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)drawArcLayer{
    CGRect rect = self.frame;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.size.width/2, rect.size.width/2)];
    [path addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.width/2) radius:rect.size.width/2 startAngle:- M_PI + M_PI/2 - M_PI/12 endAngle: -M_PI + M_PI/2 + M_PI/12 clockwise:true];
    self.arcLayer.path = path.CGPath;
}
- (void)drawRingLayer{
    CGRect rect = self.frame;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.width/2) radius:rect.size.width/2 startAngle:0 endAngle:M_PI * 2 clockwise:true];
    UIBezierPath *radius_1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.width/2) radius:rect.size.width/2/3 * 2 startAngle:0 endAngle:M_PI * 2 clockwise:true];
    [path appendPath:radius_1];
    UIBezierPath *radius_2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width/2, rect.size.width/2) radius:rect.size.width/2/3 startAngle:0 endAngle:M_PI * 2 clockwise:true];
    [path appendPath:radius_2];
    [path stroke];
    self.ringLayer.path = path.CGPath;
}

-(void)addDataWithLocationModel:(ARLocationModel *)model{
    CGRect rect = CGRectMake(model.viewRadius + model.point.x, model.viewRadius - model.point.y, 2, 2);
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = rect;
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.ringLayer addSublayer:layer];
}

-(void)updateHeading:(CGFloat)heading{
    self.ringLayer.transform = CATransform3DRotate(CATransform3DIdentity, heading/360.0 * 2 * M_PI, 0, 0, -1);
}

-(void)clear{
    for (int i = 0; i < self.ringLayer.sublayers.count;) {
        CALayer *layer = self.ringLayer.sublayers[i];
        [layer removeFromSuperlayer];
    }
}

@end
