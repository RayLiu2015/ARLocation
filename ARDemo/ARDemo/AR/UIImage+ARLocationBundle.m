//
//  UIImage+ARLocationBundle.m
//  ARDemo
//
//  Created by liuRuiLong on 2017/6/13.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

#import "UIImage+ARLocationBundle.h"

@implementation UIImage (ARLocationBundle)

+(UIImage *)imageMyBundleNamed:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:[@"ARLocation.bundle" stringByAppendingPathComponent:imageName]];
    if (image) {
        return image;
    } else {
        image = [UIImage imageNamed:[@"Frameworks/ARLocation.framework/ARLocation.bundle" stringByAppendingPathComponent:imageName]];
        if (!image) {
            image = [UIImage imageNamed:imageName];
        }
        return image;
    }
}

@end
