//
//  CameraView.m
//  ARDemo
//
//  Created by liuRuiLong on 2017/6/8.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

#import "ARLocationCameraView.h"

#define VecEdege 50
#define MaxWidth 250
#define TopBegin 150

@implementation ARLocationCameraView

-(void)transformWithAngle:(CGFloat)angle{
    CGFloat x = - angle/SCREEN_ANGLE * [UIScreen mainScreen].bounds.size.width;
    self.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, x, 0);
}

-(void)addLocation:(ARLocationModel *)location{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(location.origin.x, location.origin.y, 0, 0)];
    if (self.style) {
        label.backgroundColor = self.style.backgroundColor;
        label.font = self.style.textFont;
        label.textColor = self.style.textColor;
        label.alpha = self.style.alpha;
    }else{
        label.backgroundColor = [UIColor blackColor];
        label.textColor = [UIColor whiteColor];
        label.alpha = 0.5;
    }
    label.numberOfLines = 0;
    label.text = [NSString stringWithFormat:@"%@ - %.0lfm", location.name, location.distance];
    [self addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *conX = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:location.origin.x - MaxWidth/2];
    
    NSLayoutConstraint *conY = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:location.origin.y];

    NSLayoutConstraint *con = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:MaxWidth];
    [self addConstraints:@[conX, conY, con]];
    
}

-(void)addLocations:(NSArray<ARLocationModel *> *)locations{
    NSMutableArray<ARLocationModel *> *sortedLocations = locations.mutableCopy;
    [sortedLocations sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return ((ARLocationModel *)obj1).angle < ((ARLocationModel *)obj2).angle;
    }];
    
    for (int i = 0; i < sortedLocations.count; ++i) {
        ARLocationModel *location = sortedLocations[i];
        location.origin = [location getCameraPoint];
        if (i + 1 < sortedLocations.count) {
            ARLocationModel *nearLocation = sortedLocations[i + 1];
            if ([location getCameraPoint].x - [nearLocation getCameraPoint].x > MaxWidth) {
                continue;
            }else{
                location.origin = CGPointMake([location getCameraPoint].x, TopBegin);
                nearLocation.origin = CGPointMake([location getCameraPoint].x, location.origin.y + VecEdege);
                for (int j = i + 1; j < sortedLocations.count; ++j) {
                    ARLocationModel *closeLocation = sortedLocations[j];
                    if (j + 1 < sortedLocations.count) {
                        ARLocationModel *nextLocation = sortedLocations[j + 1];
                        if ([closeLocation getCameraPoint].x - [nextLocation getCameraPoint].x <= MaxWidth) {
                            if (closeLocation.origin.y + VecEdege > self.bounds.size.height) {
                                nextLocation.origin = CGPointMake([nextLocation getCameraPoint].x, closeLocation.origin.y - 1.5 * VecEdege);
                            }else if (closeLocation.origin.y - VecEdege < 0){
                                nextLocation.origin = CGPointMake([nextLocation getCameraPoint].x, closeLocation.origin.y + VecEdege);
                            }else{
                                nextLocation.origin = CGPointMake([nextLocation getCameraPoint].x, closeLocation.origin.y + VecEdege);
                            }
                            
                        }else{
                            i = j;
                            break;
                        }
                    }else{
                        i = j;
                        break;
                    }
                }
            }
        }
    }
    
    for (ARLocationModel *location in locations) {
        [self addLocation:location];
    }
}

-(void)clear{
    for (int i = 0; i < self.subviews.count; ) {
        UIView *view = self.subviews[i];
        [view removeFromSuperview];
    }
}

@end
