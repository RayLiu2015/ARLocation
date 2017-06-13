//
//  ViewController.m
//  ARDemo
//
//  Created by liuRuiLong on 17/6/8.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

#import "ARLocationVC.h"
#import "ViewController.h"
#import "LocationManager.h"

@interface ViewController ()<ARLocationDelegate>

@property (strong, nonatomic) ARLocationDataModel *currentLocation;

@property (strong, nonatomic) NSMutableArray<ARLocationDataModel *> *locations;

@property (strong, nonatomic) ARLocationVC *locationVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locations = [[NSMutableArray alloc] init];
}

- (IBAction)arAct:(id)sender {
    self.locationVC = [[ARLocationVC alloc] initWithDelegate:self];
    [self presentViewController:self.locationVC animated:YES completion:nil];
    [self startPosition];
}

-(void)startPosition{
    [self.locations removeAllObjects];
    __weak __typeof(self) weakSelf = self;
    [[LocationManager sharedManager] searchAroundWithCompletionBlock:^(CLLocation *currentLocation, BOOL result, NSError *error, NSArray<AMapPOI *> *arounds) {
        if (error) {
            NSLog(@"定位失败 -- %@", error);
            return;
        }
        weakSelf.currentLocation = [[ARLocationDataModel alloc] init];
        weakSelf.currentLocation.name = @"当前位置";
        weakSelf.currentLocation.location = currentLocation;
        
        for (AMapPOI *poiM in arounds) {
            ARLocationDataModel *model = [[ARLocationDataModel alloc] init];
            model.name = poiM.name;
            CLLocation *location = [[CLLocation alloc] initWithLatitude:poiM.location.latitude longitude:poiM.location.longitude];
            model.location = location;
            [weakSelf.locations addObject:model];
        }
        [weakSelf.locationVC reloadData];
    }];
    
}

#pragma mark - ARLocationDelegate
-(ARLocationDataModel *)ARLocationCurrentLocation{
    return self.currentLocation;
}

-(NSArray <ARLocationDataModel *> *)ARLocationAroundLocations{
    return self.locations;
}

-(nullable ARLocationLabelStyle *)ARLocationLabelStyle{
    ARLocationLabelStyle *style = [[ARLocationLabelStyle alloc] init];
    style.backgroundColor = [UIColor blackColor];
    style.textColor = [UIColor whiteColor];
    style.alpha = 0.5;
    return style;
}

@end
