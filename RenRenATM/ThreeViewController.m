//
//  ThreeViewController.m
//  RenRenATM
//
//
//

//6bec592d15603e556999915510e4bd6e
//
#import "ThreeViewController.h"
#import "SettingViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "CustomAnnotationView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "httpATM.h"
#import "JHChainableAnimations.h"

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
//    NSMutableArray *mArr;
    MAPointAnnotation *pointAnnotation,*pointAnnotation1;
    UILabel *_label;
    UIControl *mapBackView1;
    UIView *labelsV;
}
@property(strong,nonatomic)AMapLocationManager *locationManager;
@end
@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMapView];//初始化地图
    [self initControls];//初始化定位地图及右下角定位按钮
    
    labelsV = [[UIView alloc]init];
    //配置用户的Key
    [AMapLocationServices sharedServices].apiKey =@"6bec592d15603e556999915510e4bd6e";
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    
    //    //初始化检索对象
    //    [self initSearch];
    //   mArr = [[NSMutableArray alloc]init];
    
    
    
    //    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = @"6bec592d15603e556999915510e4bd6e";
    //初始化检索对象
    search = [[AMapSearchAPI alloc] init];
    search.delegate = self;
    
    if (showYinHangAtm.tag == 1) {
        [self addATM];
    }
  
 
    
    
    
    
    
    
    
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
//        NSLog(@"------------%@",response.pois);
    
    
    if(response.pois.count == 0)
    {
        return;
    }
    //通过 AMapPOISearchResponse 对象处理搜索结果
//    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
//    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    
    
    //    NSLog(@"%@",response.pois);
    for (AMapPOI *p in response.pois) {
//        NSLog(@"================name of back %@",p.name);
        
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
        pointAnnotation1 = [[MAPointAnnotation alloc] init];
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
        if (showYinHangAtm.tag == 2) {
            [_mapView addAnnotation:pointAnnotation1];
        }

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
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    float currentLatitude = [userDefaults floatForKey:@"currentLatitude"];
    float currentLongtitude = [userDefaults floatForKey:@"currentLongtitude"];
    request.location = [AMapGeoPoint locationWithLatitude:currentLatitude longitude:currentLongtitude];
    //        NSLog(@"+++++++++%F",request.location.longitude);
    request.keywords = @"银行";
    //    request.types = @"餐饮服务|生活服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.radius = 1000;
    //发起周边搜索
    [search AMapPOIAroundSearch: request];
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



//显示银行和ATM的跳转
-(void)showAction:(UIButton *)sender
{
    if (sender.tag == 1) {
        [sender setTag:2];
        [sender setTitle:@"隐藏银行和ATM" forState:UIControlStateNormal];
        //                NSLog(@"-------%ld",(long)sender.tag);
    }else{
        [sender setTag:1];
        [sender setTitle:@"显示银行和ATM" forState:UIControlStateNormal];
        //                NSLog(@"-------%ld",(long)sender.tag);
    }
    
    
    if (showYinHangAtm.tag == 2) {
        [_mapView addAnnotation:pointAnnotation];
    }else if (showYinHangAtm.tag == 1)
    {
        for (MAPointAnnotation *an  in _mapView.annotations) {
            [_mapView removeAnnotations:_mapView.annotations];

        }
 
            [self addATM];
     
    }
    
    
    
}



-(void)addATM{

    [httpATM setphone:@"" setint:^(NSDictionary *dic) {
        userArray = dic;
//                NSLog(@"%@",dic);
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
//                NSLog(@"-------userArray-------%@",userArray[i][@"services"]);
                
                NSArray *servicesArr = userArray[i][@"services"];
                
                
                
//                [mArr addObject:str];
                pointAnnotation.subtitle = @"(服务商铺)";
            
                //添加大头针
                [_mapView addAnnotation:pointAnnotation];
//                NSLog(@"%@",pointAnnotation);
            }
        }
    }];
}


//点击气泡事件
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
//    NSLog(@"be clicked");
    
   
   
 
    
    
    

    
    CustomCalloutView *cu;
    cu = view.subviews.firstObject;
    UILabel *currenLabel = cu.subviews.firstObject;
    
 
    
    if (userArray.count>0) {
        
        for (int i = 0; i<userArray.count; i++) {
            
            if (currenLabel.text == userArray[i][@"username"]) {
                NSArray *servicesArr = userArray[i][@"services"];
//                NSLog(@"-------superview-------------%@",servicesArr );
                labelsV = [[UIView alloc]initWithFrame:CGRectMake(-80,10 , 80, 40+12* servicesArr.count)];
                labelsV.backgroundColor = [UIColor whiteColor];
                
                labelsV.layer.borderColor = [[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] CGColor];
                labelsV.layer.cornerRadius = 6;
                //    边框颜色
                labelsV.layer.shadowColor = [[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] CGColor];
                labelsV.layer.shadowOpacity = 1.0;
                labelsV.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
                labelsV.makeScale(1.1).spring.animate(2.0);
                
                UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(0, 11,88, 10)];
                type.text = @"服务内容：";
                type.textAlignment = NSTextAlignmentCenter;
                type.textAlignment = NSTextAlignmentCenter;
                type.backgroundColor = [UIColor whiteColor];
                type.font = [UIFont systemFontOfSize:13];
                type.textColor = [UIColor blackColor];
                [labelsV addSubview:type];

                
                //有点击事件的背景view的
                mapBackView1=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                mapBackView1.backgroundColor=[UIColor whiteColor];
                mapBackView1.alpha=0.1;
                [mapBackView1 addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview: mapBackView1];
                
                for (int i=0; i<servicesArr.count; i++)
                {
                    
                    NSDictionary *nameDic = servicesArr[i];
                    NSString *name = nameDic[@"name"];
                    
                    _label = [[UILabel alloc]initWithFrame:CGRectMake(0, (30+12*i)*1.1, 88, 10)];
                    _label.text = name;
                    _label.textAlignment = NSTextAlignmentCenter;
                    _label.backgroundColor = [UIColor whiteColor];
                    _label.font = [UIFont systemFontOfSize:12];
                    _label.textColor = [UIColor colorWithRed: 0 green:0 blue:0 alpha:0.5];
                    [labelsV addSubview:_label];
                    labelsV.hidden = NO;
                    
                    
                    [view addSubview:labelsV];
                }
              
            }else{
//                [labelsV removeFromSuperview];
            }
            
        }
        
       
        
    }
    
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backClick:(UIColor *)sender
{
//    labelsV.hidden = YES;
    [labelsV removeFromSuperview];
    [mapBackView1 removeFromSuperview];
}

 

@end
