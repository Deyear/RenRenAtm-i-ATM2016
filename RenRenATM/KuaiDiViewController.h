//
//  KuaiDiViewController.h
//  RenRenATM
//
//  Created by 牛牛 on 16/5/10.
//  Copyright © 2016年 com.fsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>

@interface KuaiDiViewController : UIViewController
<AMapSearchDelegate,MAMapViewDelegate>
{
    AMapSearchAPI *_search;
    MAMapView *_mapView;
    NSString *success,*type;
}

@property(strong,nonatomic) NSString *success,*type;

@end
