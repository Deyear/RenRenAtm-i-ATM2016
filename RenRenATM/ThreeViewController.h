//
//  ThreeViewController.h
//  RenRenATM
//
//
//
//
#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface ThreeViewController : UIViewController<MAMapViewDelegate,AMapLocationManagerDelegate>
{
    MAMapView *_mapView;
    UIButton *_locationButton;
    CLLocation *_currentLocation;
   
//    NSArray *atmArray;
}
@property(nonatomic,strong) NSArray *serviceArray;

@property(nonatomic,strong) AMapNearbySearchResponse *geTiresponse;



@end
