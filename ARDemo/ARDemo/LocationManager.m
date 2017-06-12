//
//  LocationManager.m
//  ARDemo
//
//  Created by liuRuiLong on 2017/6/12.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager()<AMapSearchDelegate>

@property (strong, nonatomic) AMapLocationManager *locManager;

@property (strong, nonatomic) AMapSearchAPI *searcher;

@property (copy, nonatomic) void (^searchBlock)(CLLocation *, BOOL, NSError *, NSArray<AMapPOI *> *);

@end

@implementation LocationManager
+(instancetype)sharedManager{
    static LocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LocationManager alloc] init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        self.locManager = [[AMapLocationManager alloc] init];
        self.locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locManager.pausesLocationUpdatesAutomatically = NO;
        self.locManager.allowsBackgroundLocationUpdates = YES;
        self.locManager.locationTimeout = 10;
        self.locManager.reGeocodeTimeout = 2;

        self.searcher = [[AMapSearchAPI alloc] init];
        self.searcher.delegate = self;
    }
    return self;
}

-(void)requestLocationWithCompletionBlock:(void(^)(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error))completionBlock{
    [self.locManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        self.currentLocation = location;
        completionBlock(location, regeocode, error);
    }];
}


-(void)searchAroundWithCompletionBlock:(void (^)(CLLocation *currentLocation, BOOL result, NSError *error, NSArray<AMapPOI *> *around))completion{
    self.searchBlock = completion;
    [self requestLocationWithCompletionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (location) {
            AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
            request.keywords = @"饭店";
            request.radius = 1000;
            request.location = [AMapGeoPoint locationWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
            request.sortrule = 0;
            request.requireExtension = YES;
            [self.searcher AMapPOIAroundSearch:request];
        }else{
            completion(nil, false, error, nil);
        }
    }];
}

-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if ([request isKindOfClass:[AMapPOIAroundSearchRequest class]]) {
        self.searchBlock(self.currentLocation, YES, nil, response.pois);
    }
}

@end
