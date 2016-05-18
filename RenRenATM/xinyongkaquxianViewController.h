//
//  xinyongkaquxianViewController.h
//  RenRenATM
//
//
//
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
@interface xinyongkaquxianViewController : UIViewController
<AMapSearchDelegate,MAMapViewDelegate>{
    
    AMapSearchAPI *_search;
    MAMapView *_mapView;
    NSString *success,*type;

}

@property(strong,nonatomic) NSString *success,*type;
@end
