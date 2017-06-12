//
//  FLFTARNewMsgVC.h
//  FeelfelCode
//
//  Created by 李策 on 2017/5/29.
//  Copyright © 2017年 李策. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ARLocationDataModel : NSObject

@property (strong, nonatomic)  CLLocation * _Nonnull location;

@property (copy, nonatomic) NSString *_Nullable name;

@end

@interface ARLocationLabelStyle : NSObject

@property (strong, nonatomic) UIColor *_Nonnull backgroundColor;

@property (strong, nonatomic) UIFont *_Nonnull textFont;

@property (strong, nonatomic) UIColor *_Nonnull textColor;

@property (assign, nonatomic) CGFloat alpha;

@end

@protocol ARLocationDelegate <NSObject>

-(nullable ARLocationDataModel *)ARLocationCurrentLocation;

-(nullable NSArray <ARLocationDataModel *> *)ARLocationAroundLocations;

@optional
-(nullable ARLocationLabelStyle *)ARLocationLabelStyle;

@end

@interface ARLocationVC : UIViewController

-(nonnull instancetype)initWithDelegate:(nullable id<ARLocationDelegate>)delegate;

-(nonnull instancetype)initWithCurrentLocation:(nullable CLLocation *)location aroundLocations:(nullable NSArray<CLLocation *> *)locations delegate:(nullable id<ARLocationDelegate>)delegate;

@property (weak, nonatomic) _Nullable id<ARLocationDelegate> delegate;

-(void)reloadData;

@end
