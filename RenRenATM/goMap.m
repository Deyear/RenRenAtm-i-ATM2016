//
//goMap.m
//
//订单位置
//
//实现根据具体的地理位置名字进行查找该地名的地理坐标
//
//根据坐标在地图上添加图标
//
//以地名作为地图的中间位置



#import "goMap.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface goMap ()<AMapSearchDelegate,MAMapViewDelegate>
{
    NSString *_apiKey;                       // apiKey
    
    AMapSearchAPI *_search;                  //搜索对象
    AMapGeoPoint *strGeocodes;               //反编码的地理坐标
    
    MAMapView *_mapView;                     //地图
    
    MAPointAnnotation *pointAnnotation;      //图标
}

@end

@implementation goMap
@synthesize dic;

#pragma mark - view生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self beforeInit];             //加载后的配置
    [self searchGeocode];          //正向地理编码

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self addMapView];             //添加高德地图
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 配置信息
//加载后的配置
-(void)beforeInit{
    
    _apiKey = @"6bec592d15603e556999915510e4bd6e";    //高德地图apiKey
    
    _topView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];                       //最上面的view颜色
    
}

//正向地理编码
-(void)searchGeocode{

    [AMapSearchServices sharedServices].apiKey = _apiKey;             //配置用户Key
    
    _search = [[AMapSearchAPI alloc] init];                           //初始化检索对象
    _search.delegate = self;
    
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    if ([dic  isEqual: @"所在位置"]) {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];  //当前位置为中心
    }else{
        geo.address = dic;                                                     //地名
        [_mapView setCenterCoordinate:[pointAnnotation coordinate] animated:YES];//地名为中心
        
        [_search AMapGeocodeSearch: geo];         //发起正向地理编码
    }
    
}

//添加高德地图
-(void)addMapView{
    
    [MAMapServices sharedServices].apiKey = _apiKey;            //配置用户Key
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];                                     //初始化地图
    _mapView.delegate = self;
    
    pointAnnotation = [[MAPointAnnotation alloc] init];         //初始化当前位置图标
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(strGeocodes.latitude, strGeocodes.longitude);                                 //图标坐标
    pointAnnotation.title = dic;                                //图标气泡标题
    [_mapView addAnnotation:pointAnnotation];
    
    _mapView.showsUserLocation = YES;                           //开启定位
    [self.view addSubview:_mapView];
     [self initControls];                                       //初始化定位地图及右下角定位按钮

}

//初始化定位地图及右下角定位按钮
- (void)initControls
{
  
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow)
    {   //改变定位模式,追踪用户的location更新
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
    
    UIButton * _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-120, 44, 44);
    _locationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    _locationButton.layer.cornerRadius = 5;
    [_locationButton setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    [_locationButton addTarget:self action:@selector(locateAction)
              forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:_locationButton];

}

#pragma mark - 代理回调函数
//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    
    if(response.geocodes.count == 0)
    {
        return;
    }

    strGeocodes = [[AMapGeoPoint alloc]init];                     //初始化正编码的地理坐标
    for (AMapTip *p in response.geocodes) {
        //        strGeocodes = [NSString stringWithFormat:@"%@\ngeocode: %@", strGeocodes, p.location];
        strGeocodes = p.location;
    }
}

//弹出气泡的样式方法
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"6bec592d15603e556999915510e4bd6e";
        
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
       
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}


#pragma mark - 代码——button点击事件
//定位按钮点击事件
-(void)locateAction
{
    
    //定位到当前位置
    if ([dic  isEqual: @"所在位置"]) {
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }else{
        [_mapView setCenterCoordinate:[pointAnnotation coordinate] animated:YES];
        //发起正向地理编码
    }
    
}

#pragma mark - layout——按钮点击事件
//返回按钮的点击事件
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
