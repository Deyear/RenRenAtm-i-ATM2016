//
//  FuJinFuWuViewController.m
//  RenRenATM
//
//
//
//服务者




#define APIKEY  (@"ea69d48202fe213e54212233cb95c759")// 公司的key
//#define APIKEY  (@"6bec592d15603e556999915510e4bd6e")//个人的key

#import "FuJinFuWuViewController.h"

#import <MAMapKit/MAMapKit.h>              //高德地图

#import <AMapSearchKit/AMapSearchKit.h>    //附近搜索

#import "AFNetworking/AFNetworking.h"     //http请求

#import "CustomAnnotationView.h"         //气泡

#import "httpATM.h"                       //得到atm

#import "JHChainableAnimations.h"        //动态view


@interface FuJinFuWuViewController ()

@end


@interface FuJinFuWuViewController ()<AMapSearchDelegate,MAMapViewDelegate,AMapNearbySearchManagerDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    AMapNearbySearchManager *_nearbyManager;                   //搜索
    
    AMapNearbySearchResponse *responsInGaoDe;                           //高德上的个体
    
    MAPointAnnotation *pointAnnotation,*pointAnnotation1,*pointAnnotation2;//商铺，银行atm，个体
    
    UIView *labelsV;                                          //点击气泡生成的服务者列表view
    
    UILabel *_label;                                          //显示提供服务的条款
    
    NSString *user_id;                                        //用户id

    float currentLatitude,currentLongtitude;                  //当前的纬度经度
    
    NSString *service;                                        //用户服务者类型

    BFPaperButton *showYinHangAtm;                            //显示银行和Atm
    
    UIButton *_locationButton;                                //定位
    
    UIControl *mapBackView1;                                  //背景
    
    UIView *showListAboutAtmView ,*lineView;                  //显示服务者列表视图,两个按钮下的线条
    
    UIView *ownBackView, *serviesBackView;                    //个体、店铺服务者的背景视图
    
    UIImageView *instructImage,*instructDownImage;            //向上、向下指示图片
    
    UITableView *ownListTabView, *serviesListTabView;         //个体、店铺服务者
    
    UILabel *userNameLabel;                                   //电话号码

    NSTimer *oneSecondsTimer,*downOneSecondsTimer;            //向上，向下计时器
    
    NSArray *ownArray ,*userArray ,*tableArray;                          //店铺。个体服务者
    
    NSMutableArray *userIDsMutableArray, *infosMutableArray;  //存储个体服务者的id,个体的位置

    UIView *addV;                                             //服务者view

}

@property (nonatomic, strong) MAMapView *mapView;                     //地图

@property (nonatomic, strong) AMapSearchAPI *search;                  //搜索对象

@end

@implementation FuJinFuWuViewController

#pragma mark - view生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self beforeInit];             //加载后的配置
    
    [self initTopView];            //导航栏
    
    [self addMapView];             //添加地图
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_nearbyManager stopAutoUploadNearbyInfo];
    _nearbyManager.delegate = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Config
//加载后的配置
-(void)beforeInit{
    
    [MAMapServices sharedServices].apiKey = APIKEY;
    [AMapSearchServices sharedServices].apiKey = APIKEY;
    
    _search = [[AMapSearchAPI alloc] init];            //初始化检索对象
    _search.delegate = self;
    
    _nearbyManager = [AMapNearbySearchManager sharedInstance];
    _nearbyManager.delegate = self;
    
    //本地获取的值
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    user_id = [userDefault objectForKey:@"user_id"];
    currentLatitude = [userDefault floatForKey:@"currentLatitude"];
    currentLongtitude = [userDefault floatForKey:@"currentLongtitude"];
    service = [userDefault objectForKey:@"serviceType"];
    
    NSLog(@"\n%@\n\n",service);
    

    [self initUpTimer];                                      //向上计时器计时器
    
//    [self initDownTimer];                                   //向下计时器计时器
    
    if ( [service isEqualToString:@"个体服务者"] ) {
        
        [self setGeTiServiceInfo];                             //上传个体服务者

    }

}

//上传个体服务者的id和位置信息
- (void)setGeTiServiceInfo
{
    if (_nearbyManager.isAutoUploading)
    {
        [_nearbyManager stopAutoUploadNearbyInfo];
    }
    else
    {
        [_nearbyManager startAutoUploadNearbyInfo];
    }
    
}


//向上计时器计时器
-(void)initUpTimer{
    
    oneSecondsTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(oneSeconds)
                                                     userInfo:nil
                                                      repeats:YES];
    
}

//向下计时器计时器
-(void)initDownTimer{
    
    downOneSecondsTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(downOneSeconds)
                                                         userInfo:nil
                                                          repeats:YES];
    
}


//获取周边搜索
-(void)initGetNearbyManager{

    //获取附近的个体信息
    AMapNearbySearchRequest *request = [[AMapNearbySearchRequest alloc] init];
    request.center = [AMapGeoPoint locationWithLatitude:currentLatitude longitude:currentLongtitude];
    [self.search AMapNearbySearch:request];


}
#pragma mark - init Views
//上面的导航栏
-(void)initTopView{
    
    UIView *topView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] ;
    [self.view addSubview:topView];
    
    //服务者Label
    UILabel *serviesLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, 20, 100, 44)];
    serviesLabel.text = @"服务者";
    serviesLabel.textColor = [UIColor whiteColor];
    serviesLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:serviesLabel];
    
}

//添加高德地图
-(void)addMapView{
    
     _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-self.tabBarController.tabBar.frame.size.height-64)];                                    //初始化地图
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    
    //地图上两个图标的位置
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x,22);
 
    MACoordinateSpan span = MACoordinateSpanMake(0.008913, 0.053695);
    MACoordinateRegion region = MACoordinateRegionMake(_mapView.centerCoordinate, span);
    _mapView.region = region;
    
   
    _mapView.showsUserLocation = YES;                           //打开定位功能
    _mapView.userTrackingMode = MAUserTrackingModeFollow;       //跟随用户位置移动，并将定位点设置成地图中心点
    [self.view addSubview:_mapView];
    
    
    [self initControls];            //地图上左右按钮
    
    [self initGeTiAndDianFuView];   //初始化服务者视图上的view
    
    [self addATM];                  //添加商铺服务者图标
    
    [self addGeTi];                 //添加个体服务者图标

    
 }

//地图下方左右按钮
- (void)initControls
{
    
    //显示银行atm的按钮
    showYinHangAtm = [[BFPaperButton alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_mapView.bounds) - 80, 150, 30)];
    showYinHangAtm.backgroundColor = [UIColor whiteColor] ;
    showYinHangAtm.shadowColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] ;
    [showYinHangAtm setTitle:@"显示银行和ATM" forState:UIControlStateNormal];
    showYinHangAtm.layer.cornerRadius =15;
    showYinHangAtm.layer.borderWidth = 1;
    showYinHangAtm.layer.borderColor = [[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] CGColor];
    showYinHangAtm.tapCircleColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] ;
    showYinHangAtm.cornerRadius = 15;
    [showYinHangAtm setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [showYinHangAtm setTag:1];
    [showYinHangAtm addTarget:self action:@selector(showAction:)
             forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:showYinHangAtm];
    
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow)
    {   //改变定位模式,追踪用户的location更新
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    }
    
    //定位按钮
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(SCREEN_WIDTH - 60,  CGRectGetHeight(_mapView.bounds) - 80, 44, 44);
    _locationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    //    _locationButton.backgroundColor = [UIColor redColor];
    _locationButton.layer.cornerRadius = 5;
    //地图不在当前位置时，重新获取当前位置
    [_locationButton addTarget:self action:@selector(locateAction)
              forControlEvents:UIControlEventTouchUpInside];
    [_locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    [_mapView addSubview:_locationButton];
    
    //显示服务者视图
    showListAboutAtmView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_mapView.bounds) - 56, SCREEN_WIDTH, _mapView.frame.size.height+10)];
    showListAboutAtmView.backgroundColor = [UIColor clearColor];
    [_mapView addSubview:showListAboutAtmView];
    
    //添加上滑事件
    UISwipeGestureRecognizer *shangHua = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(huaDongAction:)];
    shangHua.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *xiaHua = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(huaDongAction:)];
    xiaHua.direction = UISwipeGestureRecognizerDirectionDown;
    
    
    [showListAboutAtmView addGestureRecognizer:shangHua];
    [showListAboutAtmView addGestureRecognizer:xiaHua];
    
}

//初始化服务者视图上的view
-(void)initGeTiAndDianFuView{
    
    //箭头指示图片
    instructImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-40)/2, 10, 40, 20)];
    instructImage.image = [UIImage imageNamed:@"指示"];
    [showListAboutAtmView addSubview:instructImage];
    
    //“个人”和“服务者”Button
    BFPaperButton *ownListOfOrdersButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH/2, 44)];
    [ownListOfOrdersButton addTarget:self action:@selector(geTiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    ownListOfOrdersButton.shadowColor = [UIColor clearColor];
    ownListOfOrdersButton.backgroundColor = [UIColor whiteColor] ;
    [ownListOfOrdersButton setTitle:@"个体服务者" forState:UIControlStateNormal];
    [ownListOfOrdersButton setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    ownListOfOrdersButton.tapCircleDiameter = 3;
    ownListOfOrdersButton.tapCircleColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [showListAboutAtmView addSubview:ownListOfOrdersButton];
    
    BFPaperButton *serviesListOfOrdersButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 10, SCREEN_WIDTH/2, 44)];
    [serviesListOfOrdersButton addTarget:self action:@selector(serviesListOfOrdersButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    serviesListOfOrdersButton.shadowColor = [UIColor clearColor];
    serviesListOfOrdersButton.backgroundColor = [UIColor whiteColor] ;
    [serviesListOfOrdersButton setTitle:@"店铺服务者" forState:UIControlStateNormal];
    [serviesListOfOrdersButton setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    serviesListOfOrdersButton.tapCircleDiameter = 3;
    serviesListOfOrdersButton.tapCircleColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [showListAboutAtmView addSubview:serviesListOfOrdersButton];
    
    //向下箭头
    instructDownImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-40)/2, 10, 40, 20)];
    instructDownImage.alpha = 0;
    instructDownImage.image = [UIImage imageNamed:@"向下指示箭头"];
    [showListAboutAtmView addSubview:instructDownImage];
    
    //线
    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2,2)];
    lineView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    
    UIView *_lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH,2)];
    _lineView.backgroundColor = [UIColor whiteColor];
    
    [_lineView addSubview:lineView];
    [showListAboutAtmView addSubview:_lineView];
    
    //两个背景View
    ownBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, showListAboutAtmView.frame.size.height - 42)];
    ownBackView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:239.0f/255.0f blue:245.0f/255.0f alpha:1];
    ownBackView.alpha = 1;
    
    serviesBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 56, SCREEN_WIDTH, showListAboutAtmView.frame.size.height - 42)];
    serviesBackView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:239.0f/255.0f blue:245.0f/255.0f alpha:1];
    serviesBackView.alpha = 0;
    
    [showListAboutAtmView addSubview:ownBackView];
    [showListAboutAtmView addSubview:serviesBackView];
    
    [self initTwoListTabView];           //两个TabView
    
}

//两个TabView
-(void)initTwoListTabView{
    
    //个人列表
    ownListTabView = [[UITableView alloc]initWithFrame:CGRectMake(0,5, SCREEN_WIDTH,ownBackView.frame.size.height-5) style:UITableViewStylePlain];
    ownListTabView.backgroundColor = [UIColor redColor];
    ownListTabView.delegate =self;
    ownListTabView.dataSource = self;
    ownListTabView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:239.0f/255.0f blue:245.0f/255.0f alpha:1];
    ownListTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ownListTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [ownBackView addSubview:ownListTabView];
    
    //服务者列表
    serviesListTabView = [[UITableView alloc]initWithFrame:CGRectMake(0,5, SCREEN_WIDTH,ownBackView.frame.size.height-5) style:UITableViewStylePlain];
    serviesListTabView.backgroundColor = [UIColor redColor];
    serviesListTabView.delegate =self;
    serviesListTabView.dataSource = self;
    serviesListTabView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:239.0f/255.0f blue:245.0f/255.0f alpha:1];
    serviesListTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    serviesListTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [serviesBackView addSubview:serviesListTabView];
    
}

#pragma mark - Button Click Action
//自动拨号功能
-(void)callPhone :(UIButton *)sender {
    
    UIView *cell = sender.superview;
    UILabel *phoneLabel = cell.subviews.lastObject;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneLabel.text]];
    [[UIApplication sharedApplication] openURL:url];
    
}

//显示服务类型
-(void)xianShi:(UIButton *)sender{
    
    UITableViewCell *cell = sender.superview;
    NSIndexPath *path = [ownListTabView indexPathForCell: cell];
    //    NSLog(@"-----------row--------%@",userArray[path.row]);
    
    NSDictionary *dic = tableArray[path.row];
    NSArray *Arr = dic[@"services"];
    UIControl *contr = [[UIControl alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    contr.backgroundColor = [UIColor blackColor];
    contr.alpha = 0.5;
    [contr addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contr ];
    
    addV = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, (SCREEN_HEIGHT-20*(Arr.count + 1))/2+10, 100, 20*(Arr.count + 1))];
    addV.backgroundColor = [UIColor whiteColor];
    addV.alpha = 0.8;
    addV.layer.borderWidth = 3;
    addV.layer.borderColor = [[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] CGColor];
    addV.layer.cornerRadius = 20*(Arr.count + 1)/4;
    //    addV.rotate(360).anchorTopLeft.thenAfter(0.5).rotate(360).anchorCenter.animate(0.5);
    addV.makeScale(1.2).spring.animate(2.0);
    [self.view addSubview:addV];
    
    for (int i=0; i<Arr.count; i++)
    {
        NSDictionary *dict = Arr[i];
        UILabel *servicesLabel = [[UILabel alloc]initWithFrame:CGRectMake(20,  (10+20*i)*1.2, 80, 20)];
        //        servicesLabel.backgroundColor = [UIColor blueColor];
        //服务者的订单状况
        servicesLabel.text = dict[@"name"];
        servicesLabel.font = [UIFont systemFontOfSize:13];
        servicesLabel.textColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
        servicesLabel.textAlignment = NSTextAlignmentCenter;
        [UIView animateKeyframesWithDuration:0.2 * i delay:2 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            servicesLabel.rotate(360).anchorTopLeft.thenAfter(0.1).rotate(360).anchorCenter.animate(0.2 * i);
        } completion:nil];
        [addV addSubview:servicesLabel];
        //
    }
    
}

//点击背景，黑色背景和服务者view消失
-(void)clickBack:(UIControl *)sender
{
    [UIView animateKeyframesWithDuration:3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        addV.hidden = YES;
        sender.hidden = YES;
        sender.enabled = NO;
    } completion:nil ];
}

//返回
-(void)backClick:(UIColor *)sender
{
    //    labelsV.hidden = YES;
    [labelsV removeFromSuperview];
    [mapBackView1 removeFromSuperview];
}


//显示银行和ATM的跳转
-(void)showAction:(UIButton *)sender{
    
    if (sender.tag == 1) {
        
        [sender setTag:2];
        [sender setTitle:@"隐藏银行和ATM" forState:UIControlStateNormal];
        
        
    }else{
        
        [sender setTag:1];
        [sender setTitle:@"显示银行和ATM" forState:UIControlStateNormal];
        
    }
    
    if (showYinHangAtm.tag == 2) {
        
        [_mapView addAnnotation:pointAnnotation];
        
    }else if (showYinHangAtm.tag == 1){
        
        //        for (MAPointAnnotation * an  in _mapView.annotations) {
        
        [_mapView removeAnnotations:_mapView.annotations];
        
        //        }
        
        [self addATM];
        
//        [self addGeTi];
        
    }
    
}

//地图跟着位置移动
- (void)locateAction{
    
    if (_mapView.userTrackingMode != MAUserTrackingModeFollow){
        
        [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        
    }
    
}



// 清除地理位置
- (void)clearUserInfoWithIDAction
{
    [_nearbyManager clearUserInfoWithID:user_id];
}

//附近个体服务者
- (void)geTiButtonAction:(UIButton *)sender {
    
    [self initGetNearbyManager];        //获取附近个体
 
//    [self clearUserInfoWithIDAction];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        lineView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 2);
        
        serviesBackView.alpha = 0;
        ownBackView.alpha = 1;
        
    }];
    
}

//服务者Click Action
-(void)serviesListOfOrdersButtonClick:(UIButton *)sender{
    
    [self addShangPu];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        lineView.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 2);
        
        serviesBackView.alpha = 1;
        ownBackView.alpha = 0;
        
    }];
    
}

#pragma mark - Other Action
//向上计时事件
-(void)oneSeconds{
    
    if (instructImage.alpha == 1) {
        
        [UIView animateWithDuration:1 animations:^{
            
            instructImage.alpha = 0;
            
            instructImage.frame = CGRectMake((SCREEN_WIDTH-40)/2, -30, 40, 20);
            
        }];
        
    }else{
        
        instructImage.alpha = 1;
        
        instructImage.frame = CGRectMake((SCREEN_WIDTH-40)/2, 10, 40, 20);
        
    }
    
}

//向下计时器事件
-(void)downOneSeconds{
    
    if (instructDownImage.alpha == 0) {
        
        [UIView animateWithDuration:1 animations:^{
            
            instructDownImage.alpha = 1;
            
            instructDownImage.frame = CGRectMake((SCREEN_WIDTH-40)/2, 20, 40, 20);
            
        }];
        
    }else{
        
        instructDownImage.alpha = 0;
        
        instructDownImage.frame = CGRectMake((SCREEN_WIDTH-40)/2, 0, 40, 20);
        
    }
    
}

//添加服务者气泡
-(void)addATM{
    
    [httpATM setint:^(NSArray *dic) {
        
        userArray = dic;
        
        tableArray = dic;
        
        if (userArray.count>0) {
            
            for (int i = 0; i<userArray.count; i++) {
                
                pointAnnotation = [[MAPointAnnotation alloc] init];
                float latitude = [userArray[i][@"latitude"] floatValue];
                CGFloat longitude = [userArray[i][@"longitude"] floatValue];
                //取得所有商铺位置坐标
                pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude ,longitude);
                pointAnnotation.title = userArray[i][@"username"];
                pointAnnotation.subtitle = @"(服务商铺)";
                
                //添加大头针
                [_mapView addAnnotation:pointAnnotation];
                
            }
            
        }
        
    }];
    
}

//添加个体服务者图标
-(void)addGeTi{
    
    infosMutableArray = [[NSMutableArray alloc ] init];
 
    if ([pointAnnotation2.subtitle  isEqual: @"（服务个体）"]) {
        
        [self.mapView removeAnnotations:self.mapView.annotations];  //删除地图上的图标
        
        [self addATM];              //添加店铺服务者

    }

    for (AMapNearbyUserInfo *info in responsInGaoDe.infos)
    {

        [userIDsMutableArray addObject:info.userID];
        
        [infosMutableArray addObject:[NSString stringWithFormat:@"%f",info.distance] ];

    }
    
        [httpATM setUserid:userIDsMutableArray setGeTiXinxi:^(NSArray *geTiInFoArray) {
    
//            if ([service  isEqual: @"店铺服务者"]) {
    
                tableArray = geTiInFoArray;
    
            ownArray = geTiInFoArray;
            
                if (tableArray.count>0) {
    
                    for (int i = 0; i<tableArray.count; i++) {
                        
                        for (AMapNearbyUserInfo *info in responsInGaoDe.infos){
                            
                            if ( [ [NSString stringWithFormat:@"%@",tableArray[i][@"id"] ] isEqualToString: info.userID ] ) {
                                
                                pointAnnotation2 = [[MAPointAnnotation alloc] init];
                                pointAnnotation2.title = [NSString stringWithFormat:@"%@", tableArray[i][@"username"]];
                                //                            pointAnnotation2.subtitle = [[NSDate dateWithTimeIntervalSince1970:info.updatetime] descriptionWithLocale:[NSLocale currentLocale]];
                                pointAnnotation2.subtitle = @"（服务个体）";
                                
                                pointAnnotation2.coordinate = CLLocationCoordinate2DMake(info.location.latitude, info.location.longitude);
                                
                                [self.mapView addAnnotation:pointAnnotation2];

                            }

                        }
      
                    }
    
                }

             [ownListTabView reloadData];
     
        }];

    
    
}

-(void)addShangPu{
    
    [httpATM setint:^(NSArray *dic) {
        
        
        tableArray = dic;
            
        
        [serviesListTabView reloadData];
        
    }];
    
}

#pragma mark - GestureRecognizer action
//上滑下滑手势事件
-(void)huaDongAction:(UISwipeGestureRecognizer *)sender{
    
    if (sender.direction == UISwipeGestureRecognizerDirectionUp) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            showListAboutAtmView.frame = CGRectMake(0 , -10, SCREEN_WIDTH,  _mapView.frame.size.height+10);
            
        } completion:nil];
        
        [oneSecondsTimer invalidate];        //向上结束计时
        
        [self initDownTimer];                //向下开始计时
        
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionDown) {
        
        [self initUpTimer];                    //向上开始计时
        
        instructDownImage.alpha = 0;
        
        [downOneSecondsTimer invalidate];    //向下开始计时
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             
                             showListAboutAtmView.frame = CGRectMake(0 , CGRectGetHeight(_mapView.bounds) - 56, SCREEN_WIDTH, _mapView.frame.size.height+10);
                             
                         } completion:nil];
        
    }
    
}


#pragma mark -  UITabView ———— 代理
//每行CELL的高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    return  100 ;
    
}

//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return tableArray.count;
//    NSLog(@"\n\n\ntableArray.count  %lu",(unsigned long)tableArray.count);
    //    return 2;
    
}

////自定义cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * str =@"cell";
    UITableViewCell  *cell =[tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil]objectAtIndex:0];
        
        
        
        //左边的头像
        UIImageView *leftAvatarView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, 44, 44)];
        leftAvatarView.image = [UIImage imageNamed:@"home_user"];
        [cell addSubview:leftAvatarView];
        
        //        // 显示服务时间
        //        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(16,70,100, 20)];
        //        //                        time.backgroundColor = [UIColor blueColor];
        //        time.textAlignment = NSTextAlignmentCenter;
        //        time.font = [UIFont systemFontOfSize:14];
        //        time.adjustsFontSizeToFitWidth = YES;
        //        //        moneyLabel.text = @"fsy 信用卡取现 2.0¥";
        //        [cell addSubview:time];
        
        
        //彩条
        UIImageView *caiTiao = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-310)/2 + 60, 36, 250, 10)];
        caiTiao.image = [UIImage imageNamed:@"caitiao"];
        [cell addSubview:caiTiao];
        
        //距离
        UILabel *meterLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, 50,200, 10)];
        meterLabel.font = [UIFont systemFontOfSize:14];
        meterLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:meterLabel];
        
        //拨打电话
        UIButton *callPhoneButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-56, 12, 20, 24)];
        [callPhoneButton setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
        [callPhoneButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
        callPhoneButton.tag = [userNameLabel.text intValue];
        [cell addSubview:callPhoneButton];
        
        //显示服务者
        BFPaperButton *xianShi = [[BFPaperButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 55, 80, 40) raised:NO];
        xianShi.rippleFromTapLocation = NO;
        xianShi.rippleBeyondBounds = YES;
        xianShi.tapCircleDiameter = MAX(xianShi.frame.size.width, xianShi.frame.size.height) * 1.3;
        xianShi.backgroundColor = [UIColor whiteColor];
        xianShi.cornerRadius = 8;
        //        xianShi.shadowColor = [UIColor whiteColor];
        xianShi.tapCircleColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
        [xianShi setTitle:@"服务内容" forState:UIControlStateNormal];
        [xianShi setTitleColor: [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1]forState:UIControlStateNormal];
        xianShi.backgroundColor = [UIColor whiteColor];
        [xianShi setTag:1];
        [xianShi addTarget:self action:@selector(xianShi:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:xianShi];
        
        //上面的灰色
        UIImageView *topGrayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        topGrayView.image = [UIImage imageNamed:@"RenRenGray"];
        [cell addSubview:topGrayView];
        
        //服务者
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2 + 60,12,100, 24)];
        //                moneyLabel.backgroundColor = [UIColor blueColor];
        [userNameLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        [cell addSubview:userNameLabel];
        
        
        ownBackView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:239.0f/255.0f blue:245.0f/255.0f alpha:1];
        
        //    选中单元格的颜色
        UIColor* color=[UIColor whiteColor];//通过RGB来定义颜色
        cell.selectedBackgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        cell.selectedBackgroundView.backgroundColor=color;
        
        if (tableView == serviesListTabView) {
            
            for (int i = 0; i<tableArray.count; i++) {
                
                NSDictionary *Dic = tableArray[indexPath.row];
                
                userNameLabel.text =  Dic[@"username"];
                
                float _latitude = [Dic[@"latitude"] floatValue];
                float _longtitude = [Dic[@"longitude"] floatValue];
                CLLocation *current=[[CLLocation alloc] initWithLatitude:currentLatitude longitude:currentLongtitude];
                CLLocation *before=[[CLLocation alloc] initWithLatitude:_latitude longitude:_longtitude];
                //计算距离
                CLLocationDistance meters=[current distanceFromLocation:before];
                float _meter = meters/1000;
                meterLabel.text = [NSString stringWithFormat:@"相距：%.2f 米",_meter];
                
            }
            
        }else{
            
             for (int i = 0; i<tableArray.count; i++) {
                
                NSDictionary *Dic = tableArray[indexPath.row];
                userNameLabel.text =  Dic[@"username"];
                
                NSString *_meter = infosMutableArray[indexPath.row];
                 float distance = [_meter floatValue];
                meterLabel.text = [NSString stringWithFormat:@"%.2f米",distance];
 
            }
            
        }
        
    }
    
    return cell;
    
}


#pragma mark -  AMapPOISearch ———— 代理
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    
    //    NSLog(@"error%@",error);
    
}

//实现POI搜索对应的回调函数
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    
    if(response.pois.count == 0){
        
        return;
        
    }
    NSString *strPoi = @"";
    
    //    NSLog(@"%@",response.pois);
    for (AMapPOI *p in response.pois) {
        
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
        pointAnnotation1 = [[MAPointAnnotation alloc] init];
        CGFloat latitude = p.location.latitude;
        CGFloat longitude = p.location.longitude;
        //取得所有商铺位置坐标
        pointAnnotation1.coordinate = CLLocationCoordinate2DMake(latitude ,longitude);
        pointAnnotation1.title = p.name;

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

#pragma mark - NearbySearch 代理函数
//上传个体服务者
- (AMapNearbyUploadInfo *)nearbyInfoForUploading:(AMapNearbySearchManager *)manager
{
    AMapNearbyUploadInfo *info = [[AMapNearbyUploadInfo alloc] init];
    info.userID = user_id;
    info.coordinate = CLLocationCoordinate2DMake(currentLatitude, currentLongtitude);
    
//    [self initGetNearbyManager];        //获取附近个体
    return info;
}

- (void)onUserInfoClearedWithError:(NSError *)error
{
    if (error)
    {
        NSLog(@"clear error: %@", error);
    }
    else
    {
        NSLog(@"clear OK");
    }
}

//判断是否上传
- (void)onNearbyInfoUploadedWithError:(NSError *)error
{
    if (error)
    {
        NSLog(@"upload error: %@", error);
    }
    else
    {
        NSLog(@"");
    }
}

//获取附近个体服务者的信息
- (void)onNearbySearchDone:(AMapNearbySearchRequest *)request response:(AMapNearbySearchResponse *)response{
 
    NSLog( @"%@",[response formattedDescription] );
    userIDsMutableArray = [[NSMutableArray alloc ] init];      //存储id
    
    responsInGaoDe = response;
    [self addGeTi];

}

#pragma mark -  MAMapView ———— 代理
//当定位模式被改变的时候进行的操作
- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:
(BOOL)animated{
    
    // 修改定位按钮状态
    if (mode == MAUserTrackingModeNone){
        
        //location没有更新的图片
        [_locationButton setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
        
    }
    else{
        
        //location更新的图片
        [_locationButton setImage:[UIImage imageNamed:@""]
                         forState:UIControlStateNormal];
        
    }
    
}

//实现位置Annotation代理
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    //标注 Annotation
    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        
        if (annotationView == nil){
            
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
            
        }
        
        //添加商铺的图标
        //        BOOL a=[[annotation subtitle] isEqualToString:@"(个体)"];
        BOOL b=[[annotation subtitle] isEqualToString:@"(服务商铺)"];
        BOOL c=[[annotation subtitle] isEqualToString:@"银行"];
        bool d=[[annotation subtitle] isEqualToString:@"ATM"];
        
        if(b){
            
            annotationView.image = [UIImage imageNamed:@"店铺图标"];
            
        }else if(c){
            
            annotationView.image = [UIImage imageNamed:@"银行图标"];
            
        }else if (d){
            
            annotationView.image = [UIImage imageNamed:@"ATM图标"];
            
        }else{
            
            annotationView.image = [UIImage imageNamed:@"个体服务者图标"];
            
        }
        
        // 不需要气泡弹出
        annotationView.canShowCallout = NO;
        
        // 设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        
        return annotationView;
        
    }
    
    return nil;
    
}

//添加大头针标志
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    //    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = @"6bec592d15603e556999915510e4bd6e";
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    currentLatitude = [userDefaults floatForKey:@"currentLatitude"];
    currentLongtitude = [userDefaults floatForKey:@"currentLongtitude"];
    request.location = [AMapGeoPoint locationWithLatitude:currentLatitude longitude:currentLongtitude];
    request.keywords = @"银行";
    request.sortrule = 0;
    request.requireExtension = YES;
    request.radius = 1000;
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
    
}

//点击气泡事件
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
 
    CustomCalloutView *cu;
    cu = view.subviews.firstObject;
    UILabel *currenLabel = cu.subviews.firstObject;
    
//    NSLog(@"\n\n\n\n\%@\n\n\n\n",currenLabel.text);
    
    
    

    if ( ownArray.count > 0 ) {

        for ( int i = 0; i < ownArray.count; i ++) {
            
            if ( [ [NSString stringWithFormat:@"%@",currenLabel.text ] isEqualToString: ownArray[i][@"username"] ] ) {
               
                NSArray *servicesArr = ownArray[i][@"services"];
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
                
                for (int i=0; i<servicesArr.count; i++){
                    
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

    
    
    
//    [httpATM setUserid:userIDsMutableArray setGeTiXinxi:^(NSArray *geTiInFoArray) {
//        
//        if (geTiInFoArray.count > 0) {
//            
//            for (int i = 0; i < geTiInFoArray.count; i++) {
//                
//                if (currenLabel.text == geTiInFoArray[i][@"username"]) {
//                    
//                    UIView *bac = [[UIView alloc]initWithFrame:CGRectMake(40,100 , 80, 100)];
//                    bac.backgroundColor = [UIColor redColor];
//
//                    
//                    NSLog(@"\n-----------1-----------%@",currenLabel.text);
//                    NSLog(@"\n-------------2----------%@",geTiInFoArray[i][@"username"]);
//                    [view addSubview:bac];
//                    
////                    NSArray *servicesArr = geTiInFoArray[i][@"services"];
////                    //                NSLog(@"-------superview-------------%@",servicesArr );
////                    labelsV = [[UIView alloc]initWithFrame:CGRectMake(-80,10 , 80, 40+12* servicesArr.count)];
////                    labelsV.backgroundColor = [UIColor whiteColor];
////                    
////                    labelsV.layer.borderColor = [[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] CGColor];
////                    labelsV.layer.cornerRadius = 6;
////                    //    边框颜色
////                    labelsV.layer.shadowColor = [[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] CGColor];
////                    labelsV.layer.shadowOpacity = 1.0;
////                    labelsV.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
////                    labelsV.makeScale(1.1).spring.animate(2.0);
////                    
////                    UILabel *type = [[UILabel alloc]initWithFrame:CGRectMake(0, 11,88, 10)];
////                    type.text = @"服务内容：";
////                    type.textAlignment = NSTextAlignmentCenter;
////                    type.textAlignment = NSTextAlignmentCenter;
////                    type.backgroundColor = [UIColor whiteColor];
////                    type.font = [UIFont systemFontOfSize:13];
////                    type.textColor = [UIColor blackColor];
////                    [labelsV addSubview:type];
////                    
////                    //有点击事件的背景view的
////                    mapBackView1=[[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
////                    mapBackView1.backgroundColor=[UIColor whiteColor];
////                    mapBackView1.alpha=0.1;
////                    [mapBackView1 addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
////                    [self.view addSubview: mapBackView1];
////                    
////                    for (int i=0; i<servicesArr.count; i++){
////                        
////                        NSDictionary *nameDic = servicesArr[i];
////                        NSString *name = nameDic[@"name"];
////                        
////                        _label = [[UILabel alloc]initWithFrame:CGRectMake(0, (30+12*i)*1.1, 88, 10)];
////                        _label.text = name;
////                        _label.textAlignment = NSTextAlignmentCenter;
////                        _label.backgroundColor = [UIColor whiteColor];
////                        _label.font = [UIFont systemFontOfSize:12];
////                        _label.textColor = [UIColor colorWithRed: 0 green:0 blue:0 alpha:0.5];
////                        [labelsV addSubview:_label];
////                        labelsV.hidden = NO;
////                        
////                        [view addSubview:labelsV];
////                    }
//                    
//                }else{
//                    //                [labelsV removeFromSuperview];
//                }
//
//                }
//            }
//        
//     }];

    
    
    
    
    
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
                
                for (int i=0; i<servicesArr.count; i++){
                    
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



@end
