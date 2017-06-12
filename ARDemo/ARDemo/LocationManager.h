//
//  LocationManager.h
//  ARDemo
//
//  Created by liuRuiLong on 2017/6/12.
//  Copyright © 2017年 codeWorm. All rights reserved.
//


#import <MAMapKit/MAMapKit.h>
#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface LocationManager : NSObject

+(instancetype)sharedManager;

@property (strong, nonatomic) CLLocation *currentLocation;

-(void)searchAroundWithCompletionBlock:(void (^)(CLLocation *currentLocation, BOOL result, NSError *error, NSArray<AMapPOI *> *around))completion;

@end
