//
//  ThreeViewController.m
//  RenRenATM
//
//  Created by 方少言 on 15/12/22.
//  Copyright © 2015年 com.fsy. All rights reserved.

//6bec592d15603e556999915510e4bd6e
//
#import "ThreeViewController.h"
#import "SettingViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "CustomAnnotationView.h"
#import <AMapSearchKit/AMapSearchKit.h>

//立体按钮————第三方
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"



@interface ThreeViewController ()<CLLocationManagerDelegate,AMapSearchDelegate>
{
    AMapSearchAPI *search;
    UIButton *rightButton;
    HTPressableButton *showYinHangAtm;
    NSString *fileName;
    NSArray *userArray;
    NSMutableArray *mArr;
    MAPointAnnotation *pointAnnotation;
    
}
@property(strong,nonatomic)AMapLocationManager *locationManager;
@end
@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self initMapView];//初始化地图
    [self initControls];//初始化定位地图及右下角定位按钮
    
    
    //配置用户的Key
    [AMapLocationServices sharedServices].apiKey =@"6bec592d15603e556999915510e4bd6e";
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;


//    //初始化检索对象
//    [self initSearch];
//   mArr = [[NSMutableArray alloc]init];
    
    
  
    
   
}


//初始化用户位置移动地图
- (void)initMapView
{
    //2D栅格地图配置用户Key       ea69d48202fe213e54212233cb95c759
//    [AMapSearchServices sharedServices].apiKey = @"ea69d48202fe213e54212233cb95c759";
//    [MAMapServices sharedServices].apiKey = @"ea69d48202fe213e54212233cb95c759";
    [AMapSearchServices sharedServices].apiKey = @"6bec592d15603e556999915510e4bd6e";
    [MAMapServices sharedServices].apiKey = @"6bec592d15603e556999915510e4bd6e";
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.tabBarController.tabBar.frame.size.height)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    
    //地图上两个图标的位置
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x,22);
    //    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);
    
    
    MACoordinateSpan span = MACoordinateSpanMake(0.008913, 0.053695);
    MACoordinateRegion region = MACoordinateRegionMake(_mapView.centerCoordinate, span);
    _mapView.region = region;
    [self.view addSubview:_mapView];
    
    //打开定位功能
    _mapView.showsUserLocation = YES;
    //跟随用户位置移动，并将定位点设置成地图中心点。
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}


//初始化定位地图及右下角定位按钮
- (void)initControls
{
    CGRect frame = CGRectMake(0, CGRectGetHeight(_mapView.bounds) - 50, 150, 30);
    showYinHangAtm = [[HTPressableButton alloc] initWithFrame:frame buttonStyle:HTPressableButtonStyleRect];
    showYinHangAtm.buttonColor = [UIColor whiteColor] ;
    showYinHangAtm.shadowColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] ;
    [showYinHangAtm setTitle:@"Rect" forState:UIControlStateNormal];
    showYinHangAtm.layer.cornerRadius = 5;
//    showYinHangAtm.backgroundColor = [UIColor redColor];
    [showYinHangAtm setTitle:@"显示银行和ATM" forState:UIControlStateNormal];
    [showYinHangAtm setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    showYinHangAtm.titleLabel.font = [UIFont systemFontOfSize:17];
    showYinHangAtm.layer.borderWidth = 1;
    showYinHangAtm.layer.borderColor = [[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] CGColor];
    showYinHangAtm.layer.cornerRadius = 12;
    showYinHangAtm.layer.masksToBounds = YES;
    [showYinHangAtm setTag:1];
    [showYinHangAtm addTarget:self action:@selector(showAction:)
              forControlEvents:UIControlEventTouchUpInside];
     [_mapView addSubview:showYinHangAtm];
    
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow)
    {   //改变定位模式,追踪用户的location更新
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
    
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(SCREEN_WIDTH - 60, CGRectGetHeight(_mapView.bounds) - 60, 44, 44);
    _locationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    //    _locationButton.backgroundColor = [UIColor redColor];
    _locationButton.layer.cornerRadius = 5;
    //地图不在当前位置时，重新获取当前位置
    [_locationButton addTarget:self action:@selector(locateAction)
              forControlEvents:UIControlEventTouchUpInside];
    [_locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    [_mapView addSubview:_locationButton];
}


//显示银行和ATM的跳转
-(void)showAction:(UIButton *)sender
{
    if (sender.tag == 1) {
        [sender setTag:2];
        [sender setTitle:@"隐藏银行和ATM" forState:UIControlStateNormal];
//        NSLog(@"-------%ld",(long)sender.tag);
    }else{
        [sender setTag:1];
        [sender setTitle:@"显示银行和ATM" forState:UIControlStateNormal];
//        NSLog(@"-------%ld",(long)sender.tag);
    }
    
}


//地图跟着位置移动
- (void)locateAction
{
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow)
    {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
}


//当定位模式被改变的时候进行的操作
- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:
(BOOL)animated
{
    // 修改定位按钮状态
    if (mode == MAUserTrackingModeNone)
    {
        //location没有更新的图片
        [_locationButton setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
}
else
{
        //location更新的图片
        [_locationButton setImage:[UIImage imageNamed:@""]
                     forState:UIControlStateNormal];
}
}


- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    //    NSLog(@"");
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //    NSLog(@"------------%@",response.pois);
    
    //通过 AMapPOISearchResponse 对象处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    
    
    //    NSLog(@"%@",response.pois);
    for (AMapPOI *p in response.pois) {
        
        
        //        NSLog(@"================name of back %@",p.name);
        
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
        MAPointAnnotation *pointAnnotation1 = [[MAPointAnnotation alloc] init];
        CGFloat latitude = p.location.latitude;
        CGFloat longitude = p.location.longitude;
        //取得所有商铺位置坐标
        pointAnnotation1.coordinate = CLLocationCoordinate2DMake(latitude ,longitude);
        pointAnnotation1.title = p.name;
        //                pointAnnotation.subtitle = @"信用卡取现\n银行卡取现";
        NSString *strZiZhuBank = @"ATM";
        if ([p.name rangeOfString:strZiZhuBank].location != NSNotFound)  {
            pointAnnotation1.subtitle = @"ATM";
        }else{
            pointAnnotation1.subtitle = @"银行";
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showYinHangAtm.tag == 2) {
                [_mapView addAnnotation:pointAnnotation1];
                //                 NSLog(@"加载图标后tag%ld",(long)showYinHangAtm.tag);
            }else if (showYinHangAtm.tag == 1)
            {
                for (MAPointAnnotation *an  in _mapView.annotations) {
                    if ([an.subtitle isEqualToString:pointAnnotation1.subtitle]) {
                        [_mapView removeAnnotations:_mapView.annotations];
                        [_mapView addAnnotation:pointAnnotation];
                    }
                }
                
                
            }
        });
    }
}


//添加大头针标志
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{

    //    //配置用户Key
        [AMapSearchServices sharedServices].apiKey = @"6bec592d15603e556999915510e4bd6e";
    //初始化检索对象
    search = [[AMapSearchAPI alloc] init];
    search.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
//        NSLog(@"+++++++++%F",request.location.longitude);
    request.keywords = @"银行";
//    request.types = @"餐饮服务|生活服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.radius = 1000;
    //发起周边搜索
    [search AMapPOIAroundSearch: request];

//    if (userArray ==nil) {
        //取出当前位置的坐标
//                NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    
        NSString *str = [NSString stringWithFormat:@"http://114.215.203.95:82/v1/atm?relation=servicesz"];
        //        114.215.203.95:82/v1/atms?relation=services&longitude=114.315065&latitude=30.600915&radius=1000000

        NSString *longitudelongitude = [NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];
        NSString *latitudelatitude = [NSString stringWithFormat:@"%f",userLocation.coordinate.latitude];
        NSDictionary *paratemetrs = @{@"longitude":longitudelongitude,
                                      @"latitude":latitudelatitude,
                                      @"radius":@"3000"};
//                NSLog(@"========%@",paratemetrs);
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        
        [session GET:str parameters:paratemetrs progress:^(NSProgress * _Nonnull downloadProgress) {
            //        NSLog(@"%@",downloadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                    NSLog(@"-------------%@",responseObject);
            
            userArray = responseObject;
//            NSLog(@"-------userArrayuserArrayuserArray%@",userArray);
       
            
            
                if (userArray.count>0) {
                for (int i = 0; i<userArray.count; i++) {
                    pointAnnotation = [[MAPointAnnotation alloc] init];
                    float latitude = [userArray[i][@"latitude"] floatValue];
                    CGFloat longitude = [userArray[i][@"longitude"] floatValue];
                    
//                    NSLog(@"latide=====%lf",latitude);
                    //取得所有商铺位置坐标
                    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude ,longitude);
                    pointAnnotation.title = userArray[i][@"username"];
                    NSString *str = userArray[i][@"username"];
                    
                    [mArr addObject:str];
                //                pointAnnotation.subtitle = @"信用卡取现\n银行卡取现";
                    pointAnnotation.subtitle = @"(服务商铺)";
                    
                    //添加大头针
                    [_mapView addAnnotation:pointAnnotation];
                }
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
//    }
//    else{
//        
//    }
}


//实现位置Annotation代理
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    //标注 Annotation
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
        }
    
        //添加商铺的图标
        BOOL b=[[annotation subtitle] isEqualToString:@"(服务商铺)"];
        BOOL c=[[annotation subtitle] isEqualToString:@"银行"];
        bool d=[[annotation subtitle] isEqualToString:@"ATM"];
        if(b){
            annotationView.image = [UIImage imageNamed:@"map_shoing"];
        }else if(c){
            annotationView.image = [UIImage imageNamed:@"map_bank"];
        }else if (d){
            annotationView.image = [UIImage imageNamed:@"map_atm"];
        }
        
        // 不需要气泡弹出
        annotationView.canShowCallout = NO;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        return annotationView;
    }
    return nil;
}


//    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
//    NSLog(@"-------------Place: %@", result);
    






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
