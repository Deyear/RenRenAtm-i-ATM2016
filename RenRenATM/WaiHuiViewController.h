//
//  WaiHuiViewController.h
//  RenRenATM
//
//  Created by 方少言 on 16/2/25.
//  Copyright © 2016年 com.fsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
@interface WaiHuiViewController : UIViewController
<AMapSearchDelegate,MAMapViewDelegate>
{
    AMapSearchAPI *_search;
    MAMapView *_mapView;
    NSString *success,*type;
}

@property(strong,nonatomic) NSString *success,*type;
@end
