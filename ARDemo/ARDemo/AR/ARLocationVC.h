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

/**
 @b 位置信息
 */
@property (strong, nonatomic)  CLLocation * _Nonnull location;

/**
 @b 位置名称
 */
@property (copy, nonatomic) NSString *_Nullable name;

@end

@interface ARLocationLabelStyle : NSObject

/**
 @b 所要显示文本的背景色
 */
@property (strong, nonatomic) UIColor *_Nonnull backgroundColor;

/**
 @b 所要显示文本的字体
 */
@property (strong, nonatomic) UIFont *_Nonnull textFont;

/**
 @b 所要显示文本的字体颜色
 */
@property (strong, nonatomic) UIColor *_Nonnull textColor;

/**
 @b 所要显示文本的透明度
 */
@property (assign, nonatomic) CGFloat alpha;

@end

@protocol ARLocationDelegate <NSObject>

/**
 @b 需要在这个代理方法指明当前位置

 @return 当前位置
 */
-(nullable ARLocationDataModel *)ARLocationCurrentLocation;

/**
 @b 指明你想显示的周围位置

 @return 周围位置
 */
-(nullable NSArray <ARLocationDataModel *> *)ARLocationAroundLocations;

@optional

/**
 @b 显示位置信息文本样式, 背景色默认为半透明黑色, 字体为白色

 @return 文本样式
 */
-(nullable ARLocationLabelStyle *)ARLocationLabelStyle;

@end

@interface ARLocationVC : UIViewController

-(nonnull instancetype)initWithDelegate:(nullable id<ARLocationDelegate>)delegate;

/**
 @b 实例化方法, 当前位置信息和周围位置信息也可以通过代理回调

 @param location 当前位置
 @param locations 周围位置信息
 @param delegate 代理
 @return 实力化的对象
 */
-(nonnull instancetype)initWithCurrentLocation:(nullable CLLocation *)location aroundLocations:(nullable NSArray<CLLocation *> *)locations delegate:(nullable id<ARLocationDelegate>)delegate;

@property (weak, nonatomic) _Nullable id<ARLocationDelegate> delegate;

/**
 @b 当数据有变化可以调用这个更新数据, 调用完这个方法之后, 内部会调用代理回调获取位置, 样式等信息
 */
-(void)reloadData;

@end
