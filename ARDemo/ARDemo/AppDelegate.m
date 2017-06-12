//
//  AppDelegate.m
//  ARDemo
//
//  Created by liuRuiLong on 17/6/8.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString * APIKey = @"a50d16e758a6523f388c1fbdc357cbed";
    [AMapServices sharedServices].apiKey = APIKey;
    return YES;
}

@end
