//
//  LocationCalculator.m
//  ARDemo
//
//  Created by liuRuiLong on 2017/6/8.
//  Copyright © 2017年 codeWorm. All rights reserved.
//

#import "ARLocationCalculator.h"

#import <UIKit/UIKit.h>

@implementation ARLocationCalculator

+(ARLocationModel *)getPointWithCenterLocation:(CLLocation *)center radius:(CGFloat)radius viewRadius:(CGFloat)viewRadius aroundLocation:(CLLocation *)aroundLocation{
    
    double distance = [self getDistanceWithlon1:center.coordinate.longitude lat1:center.coordinate.latitude lon2:aroundLocation.coordinate.longitude lat2:aroundLocation.coordinate.latitude];
    
    CGPoint offset = CGPointMake(aroundLocation.coordinate.longitude - center.coordinate.longitude, aroundLocation.coordinate.latitude - center.coordinate.latitude);
    //    double distance = [self getDistanceWithlon1:center.coordinate.longitude lat1:center.coordinate.latitude lon2:aroundLocation.coordinate.longitude lat2:aroundLocation.coordinate.latitude];
    NSArray *locations = [self getAround1WithLat:center.coordinate.latitude lon:center.coordinate.longitude radius:radius];
    
    double minLatitude = [locations[0] doubleValue];
    double minLongitude = [locations[1] doubleValue];
    double maxLatitude = [locations[2] doubleValue];
    double maxLongitude = [locations[3] doubleValue];
    
    ARLocationModel *locationModel = [[ARLocationModel alloc] init];
    double pi_angle = atan((aroundLocation.coordinate.longitude - center.coordinate.longitude)/(aroundLocation.coordinate.latitude - center.coordinate.latitude));
    double angle = pi_angle * 180/M_PI;
    
    
    
    CGPoint point;
    if (offset.x > 0) {
        if(offset.y > 0){   //第一象限
            point = CGPointMake(offset.x/(maxLongitude - center.coordinate.longitude) * viewRadius,  offset.y/(maxLatitude - center.coordinate.latitude) * viewRadius);
        }else{  //第四象限
            point = CGPointMake(offset.x/(maxLongitude - center.coordinate.longitude) * viewRadius, offset.y/(center.coordinate.latitude - minLatitude) * viewRadius);
            angle = 180 + angle;
        }
    }else{   //第二象限
        if (offset.y > 0) {
            point = CGPointMake(offset.x/(center.coordinate.longitude - minLongitude) * viewRadius, offset.y/(maxLatitude - center.coordinate.latitude) * viewRadius);
            angle = 360 + angle;
        }else{  //第三象限
            point = CGPointMake(offset.x/(center.coordinate.longitude - minLongitude) * viewRadius, offset.y/(center.coordinate.latitude - minLatitude) * viewRadius);
            angle = 180 + angle;
        }
    }
    locationModel.point = point;
    locationModel.location = aroundLocation;
    locationModel.center = center;
    locationModel.angle = angle;
    locationModel.viewRadius = viewRadius;
    locationModel.radius = radius;
    locationModel.distance = distance;
        
    return locationModel;
    
}







static double EARTH_RADIUS = 6378137;
static double rad(double d){
    return d * M_PI / 180.0;
}

/**
 * 基于余弦定理求两经纬度距离
 * @param lon1 第一点的精度
 * @param lat1 第一点的纬度
 * @param lon2 第二点的精度
 * @param lat2 第二点的纬度
 * @return 返回的距离，单位m
 * */
+(double)getDistanceWithlon1:(double)lon1 lat1:(double)lat1 lon2:(double)lon2 lat2:(double)lat2{
    double radLat1 = rad(lat1);
    double radLat2 = rad(lat2);
    double radLon1 = rad(lon1);
    double radLon2 = rad(lon2);
    if (radLat1 < 0)
        radLat1 = M_PI / 2 + fabs(radLat1);// south
    if (radLat1 > 0)
        radLat1 = M_PI / 2 - fabs(radLat1);// north
    if (radLon1 < 0)
        radLon1 = M_PI * 2 - fabs(radLon1);// west
    if (radLat2 < 0)
        radLat2 = M_PI / 2 + fabs(radLat2);// south
    if (radLat2 > 0)
        radLat2 = M_PI / 2 - fabs(radLat2);// north
    if (radLon2 < 0)
        radLon2 = M_PI * 2 - fabs(radLon2);// west
    double x1 = EARTH_RADIUS * cos(radLon1) * sin(radLat1);
    double y1 = EARTH_RADIUS * sin(radLon1) * sin(radLat1);
    double z1 = EARTH_RADIUS * cos(radLat1);
    
    double x2 = EARTH_RADIUS * cos(radLon2) * sin(radLat2);
    double y2 = EARTH_RADIUS * sin(radLon2) * sin(radLat2);
    double z2 = EARTH_RADIUS * cos(radLat2);
    
    double d = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)+ (z1 - z2) * (z1 - z2));
    //余弦定理求夹角
    double theta = acos((EARTH_RADIUS * EARTH_RADIUS + EARTH_RADIUS * EARTH_RADIUS - d * d) / (2 * EARTH_RADIUS * EARTH_RADIUS));
    double dist = theta * EARTH_RADIUS;
    return dist;
}



//@see http://snipperize.todayclose.com/snippet/php/SQL-Query-to-Find-All-Retailers-Within-a-Given-Radius-of-a-Latitude-and-Longitude--65095/
//The circumference of the earth is 24,901 miles.
//24,901/360 = 69.17 miles / degree



/**
 @b 获取指定距离经纬度范围
 
 @param lat 纬度
 @param lon 经度
 @param radius 半径
 @return 最小经度, 最小纬度, 最大经度, 最大纬度
 */
+(NSArray<NSNumber *> *)getAroundWithLat:(double)lat lon:(double)lon radius:(int)radius{
    double latitude = lat;
    double longitude = lon;
    
    double degree = (24901*1609)/360.0;
    double raidusMile = radius;
    
    double dpmLat = 1/degree;
    double radiusLat = dpmLat*raidusMile;
    double minLat = latitude - radiusLat;
    double maxLat = latitude + radiusLat;
    
    double mpdLng = degree*cos(latitude * (M_PI/180));
    double dpmLng = 1 / mpdLng;
    double radiusLng = dpmLng*raidusMile;
    double minLng = longitude - radiusLng;
    double maxLng = longitude + radiusLng;
    NSArray *arr =  @[@(minLat),@(minLng),@(maxLat),@(maxLng)];
    return arr;
}

+(NSArray<NSNumber *> *)getAround1WithLat:(double)lat lon:(double)lon radius:(int)radius{
    
    /*
     
     //当前经纬度
     $Lat = '30.01254012452224'; //纬度
     $Lng = '121.01244544525456456478797';//经度
     
     
     $range = 180 / pi() * 1 / 6372.797;    //里面的 1 就代表搜索 1km 之内，单位km
     $lngR = $range / cos($Lat * pi() / 180);
     
     
     $maxLat= $Lat + $range;//最大纬度
     $minLat= $Lat - $range;//最小纬度
     $maxLng = $Lng + $lngR;//最大经度
     $minLng = $Lng - $lngR;//最小经度
     
     $list = array('maxLat'=>$maxLat,'minLat'=>$minLat,'maxLng'=>$maxLng,'minLng'=>$minLng);
     print_r($list);
     
     */
    double range = 180/M_PI*radius/EARTH_RADIUS;
    double lngR = range/cos(lat * M_PI/180);
    
    double maxLat = lat + range;
    double minLat = lat - range;
    double maxLon = lon + lngR;
    double minLon = lon - lngR;
    
    NSArray *arr =  @[@(minLat),@(minLon),@(maxLat),@(maxLon)];
    
    return arr;
}


@end
