//
//  LocationModel.m
//  ARDemo
//
//  Created by liuRuiLong on 2017/6/8.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

#import <objc/runtime.h>
#import "ARLocationModel.h"

@implementation ARLocationModel

-(CGPoint)getCameraPoint{
    CGFloat count = 360/SCREEN_ANGLE;
    CGRect screen = [UIScreen mainScreen].bounds;
    return CGPointMake((self.angle + SCREEN_ANGLE/2)/360.0 * count * screen.size.width, screen.size.height/2);
}

-(NSString *)description{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self.class, &count);
    NSMutableString *str = [NSMutableString string];
    for (int i = 0; i < count; ++i) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *proName = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:proName];
        
        [str appendFormat:@"<%@ : %@> \n", proName, value];
    }
    free(ivars);
    return str;
}

@end
