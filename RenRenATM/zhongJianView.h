//
//  zhongJianView.h
//  RenRenATM
//
//  Created by 牛牛 on 16/3/31.
//  Copyright © 2016年 com.fsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface zhongJianView : UIViewController<MAMapViewDelegate,AMapNearbySearchManagerDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
{
    IBOutlet UITableView *_tableView;

    MAMapView *_mapView;
    UIButton *_locationButton;
    AMapNearbySearchManager *_nearbyManager;
    CLLocation *_currentLocation;
    AMapSearchAPI *_search;
}
@end
