//
//  zhongJianView.m
//  RenRenATM
//
//
//  
//
//服务者的界面



#import "zhongJianView.h"
#import "AFNetworking/AFNetworking.h"
#import <CoreLocation/CoreLocation.h>
@interface zhongJianView ()<CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    IBOutlet UIView *topView;
    
    CLLocationManager *_locationManager;
    CLLocation *locationInfo;
    
    NSArray *userArray,*result1,*result2;
    NSString *fileName1,*fileName2;
    NSMutableArray *array1,*array2;
    NSUserDefaults *userDefaults;
    UILabel *userNameLabel;
    float currentLatitude,currentLongtitude;
    NSDictionary * dict;
    NSArray *servicesArr;
    UIView *xianShiView;
    
}
@end

@implementation zhongJianView

- (void)viewDidLoad {
    [super viewDidLoad];
   topView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    
//    userDefaults = [NSUserDefaults standardUserDefaults];
//    currentLatitude = [userDefaults floatForKey:@"currentLatitude"];
//    currentLongtitude = [userDefaults floatForKey:@"currentLongtitude"];
////        NSLog(@"==========%lf\n%lf===",currentLatitude,currentLongtitude);
//    NSLog(@"%@",userArray);
    xianShiView = [[UIView alloc]init];\
    xianShiView.backgroundColor = [UIColor greenColor];
    [self initTab];                   //初始化_tableView
    [self initializeLocationService]; //初始化定位设置
}


//初始化_tableView
-(void)initTab{
    _tableView.delegate = self;
    _tableView.dataSource = self;
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


//初始化定位设置
- (void)initializeLocationService {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.distanceFilter = 50;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}


//获取当前的地理坐标
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (locationInfo == nil) {
        locationInfo = locations.lastObject;
//                NSLog(@"--------latitude------%f",locationInfo.coordinate.latitude);
    }
    
    if (userArray ==nil) {
 
        
        NSString *str = [NSString stringWithFormat:@"http://114.215.203.95:82/v1/atm?relation=services"];
        //        114.215.203.95:82/v1/atms?relation=services&longitude=114.315065&latitude=30.600915&radius=1000000
        
        NSString *longitudelongitude = [NSString stringWithFormat:@"%f",locationInfo.coordinate.longitude];
        NSString *latitudelatitude = [NSString stringWithFormat:@"%f",locationInfo.coordinate.latitude];
        NSDictionary *paratemetrs = @{@"longitude":longitudelongitude,
                                      @"latitude":latitudelatitude,
                                      @"radius":@"1000000"};
        
        //                NSLog(@"========%@",paratemetrs);
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        
        [session GET:str parameters:paratemetrs progress:^(NSProgress * _Nonnull downloadProgress)
         
         {
             //        NSLog(@"%@",downloadProgress);
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSLog(@"------responseObject-------%@",responseObject);
             userArray = responseObject;
             //             同步数据到_collectionView
             [_tableView reloadData];
             
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
         }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//每行CELL的高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
//    return  320*ydp;
//    return 100;
    NSDictionary *Dic = userArray[indexPath.row];
    NSArray *servicesArr = Dic[@"services"];
    NSInteger _int = servicesArr.count;
    
    return  100 +_int*25;
}


//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 return userArray.count;
}


//自定义cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString * str =@"cell";
    UITableViewCell  *cell =[tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil]objectAtIndex:0];
//        cell.backgroundColor = [UIColor greenColor];
        
        //左边的头像
        UIImageView *leftAvatarView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, 44, 44)];
        leftAvatarView.image = [UIImage imageNamed:@"home_user"];
        [cell addSubview:leftAvatarView];
        
//        显示服务时间
        UILabel *time = [[UILabel alloc]initWithFrame:CGRectMake(16,70,100, 20)];
//                        time.backgroundColor = [UIColor blueColor];
        time.textAlignment = NSTextAlignmentCenter;
        time.font = [UIFont systemFontOfSize:14];
        time.adjustsFontSizeToFitWidth = YES;
        //        moneyLabel.text = @"fsy 信用卡取现 2.0¥";
        [cell addSubview:time];
        
        //服务者
        userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2 + 60,12,100, 24)];
//                moneyLabel.backgroundColor = [UIColor blueColor];
        [userNameLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
        userNameLabel.textAlignment = NSTextAlignmentCenter;
        userNameLabel.adjustsFontSizeToFitWidth = YES;
        //        moneyLabel.text = @"fsy 信用卡取现 2.0¥";
        [cell addSubview:userNameLabel];
        
//        彩条
        UIImageView *caiTiao = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-310)/2 + 60, 36, 250, 10)];
        caiTiao.image = [UIImage imageNamed:@"caitiao"];
//        caiTiao.backgroundColor = [UIColor whiteColor];
        [cell addSubview:caiTiao];
//         距离
        UILabel *meterLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-160)/2, 50,200, 10)];
        meterLabel.font = [UIFont systemFontOfSize:14];
        meterLabel.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:meterLabel];
//            meterLabel.backgroundColor = [UIColor whiteColor];
        
//        电话
        //拨打电话
        UIButton *callPhoneButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 70, 20, 20)];
        [callPhoneButton setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
        [callPhoneButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:callPhoneButton];
        
////        显示服务者
//        UIButton *xianShi = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-50, 70, 50, 20)];
//        [xianShi setTitle:@"服务" forState:UIControlStateNormal];
//        xianShi.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
////        [xianShi setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
//        [xianShi addTarget:self action:@selector(xianShi:) forControlEvents:UIControlEventTouchUpInside];
//        [cell addSubview:xianShi];
        
        for (int i = 0; i<userArray.count; i++) {
            NSDictionary *Dic = userArray[indexPath.row];
            userNameLabel.text =  Dic[@"username"];
            
            float _latitude = [Dic[@"latitude"] floatValue];
//            NSLog(@"=====opening_time=========%@",Dic[@"opening_time"]);
            float _longtitude = [Dic[@"longitude"] floatValue];
            //                NSLog(@"======latitude%lf=========_longtitude%lf",_latitude,_longtitude);
            CLLocation *current=[[CLLocation alloc] initWithLatitude:currentLatitude longitude:currentLongtitude];
            //第二个坐标
            CLLocation *before=[[CLLocation alloc] initWithLatitude:_latitude longitude:_longtitude];
            //         计算距离
            CLLocationDistance meters=[current distanceFromLocation:before];
            float _meter = meters/1000;
            //        NSLog(@"=======distance%f=====_meter%f===",distance,_meter);
            meterLabel.text = [NSString stringWithFormat:@"相距：%.2f km",_meter];
            
             servicesArr = Dic[@"services"];
            for (int i=0; i<servicesArr.count; i++)
            {
                
                dict = servicesArr[i];
                UILabel *   servicesLabel = [[UILabel alloc]initWithFrame:CGRectMake(16,  105+25*i, SCREEN_WIDTH/2-10, 25)];
//                servicesLabel.backgroundColor = [UIColor blueColor];
                //服务者的订单状况
                servicesLabel.text = dict[@"name"];
                servicesLabel.font = [UIFont systemFontOfSize:14];
                //                NSLog(@"=========text=======%@",servicesLabel.text);
                [cell addSubview:servicesLabel];
            }
        }
 
 
    }
    return cell;
}


//自动拨号功能
-(void)callPhone:(UIButton *)sender
{
    NSString *phoneNum = [[NSString alloc]initWithString:userNameLabel.text];// 电话号码
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    [[UIApplication sharedApplication] openURL:url];
}


-(void)xianShi:(UIButton *)sender{
//    NSLog(@"===========servicesArr=======%ld",servicesArr.count);
    [self.view addSubview:xianShiView];
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