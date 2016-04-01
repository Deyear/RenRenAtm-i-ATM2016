//
//  ThreeViewController.h
//  RenRenATM
//
//  Created by 方少言 on 15/12/22.
//  Copyright © 2015年 com.fsy. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface ThreeViewController : UIViewController<MAMapViewDelegate,AMapNearbySearchManagerDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
{
    MAMapView *_mapView;
    UIButton *_locationButton;
    AMapNearbySearchManager *_nearbyManager;
    CLLocation *_currentLocation;
    AMapSearchAPI *_search;
}

@end
