
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CLHeading.h>
#import <CoreMotion/CoreMotion.h>

@interface ARLocationSensorManager : NSObject 

+ (instancetype)shared;
- (void)startSensor;
- (void)startGyroscope;
- (void)stopSensor;
- (void)stopGyroscope;

@property (nonatomic, copy) void (^didUpdateHeadingBlock)(CLLocationDirection theHeading);
@property (nonatomic, copy) void (^updateDeviceMotionBlock)(CMDeviceMotion *data);

@end
