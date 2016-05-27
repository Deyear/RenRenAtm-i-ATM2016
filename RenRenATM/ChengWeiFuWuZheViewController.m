
//
//  ChengWeiFuWuZheViewController.m
//  RenRenATM
//
//
//
//成为服务者

#import "ChengWeiFuWuZheViewController.h"
#import "ActionSheetPicker.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>


@interface ChengWeiFuWuZheViewController ()<AMapSearchDelegate,UITextFieldDelegate,CLLocationManagerDelegate>{

    BFPaperButton *submitButton;

    NSString *ONE,*TWO,*THREE,*FOUR,*FIVE,*SIX,*SEVEN,*EIGHT;  //1~0
    
    NSString *phoneNumber,*access_token;                      //用户手机号
    
    NSMutableArray *servics_idsArr;                           //用于存储服务类型
    
    CLLocationManager *_locationManager;                      //定位

    NSString *ownRole ,*yingYeTime ,*xieYeTime;               //服务者身份,营业，歇业
    
    AMapGeoPoint *strGeocodes;                                //反编码的地理坐标
    
    NSString *_apiKey;                                        //_apiKey
    
    AMapSearchAPI *_search;                                   //搜索对象

    IBOutlet UIButton *geRenButton;
}

@property (nonatomic, strong) NSDate *selectedTime;

@property (nonatomic, strong) NSString *LocationString;

@property (strong, nonatomic) IBOutlet UIView *timeAndLocationBackView;

@property (strong, nonatomic) IBOutlet UIButton *geTiButton;

@property (strong, nonatomic) IBOutlet UIButton *dianPuButton;

@property (strong, nonatomic) IBOutlet UILabel *openTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *closeTimeLabel;

@property (strong, nonatomic) IBOutlet UITextField *LocationName;

@end

@implementation ChengWeiFuWuZheViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializeLocationService];  //定位
   
    [self initButton];                 //初始化确定按钮
    
    [self initValue];                  //初始值
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

#pragma mark - init

//定位
- (void)initializeLocationService {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager startUpdatingLocation];
    
}

-(void)initValue{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    phoneNumber = [userDefault objectForKey:@"user_name"];
    access_token = [userDefault objectForKey:@"access_token"];
    
    servics_idsArr = [[NSMutableArray alloc]init];
    
    //八个功能选择
    ONE=@"1";
    TWO=@"2";
    THREE =@"3";
    FOUR = @"4";
    FIVE =@"5";
    SIX = @"6";
    SEVEN =@"7";
    EIGHT = @"8";
    
    self.selectedTime = [NSDate date];    //时间选择器
    
    
    self.LocationName.delegate = self;


}
-(void)initButton{

    submitButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(40, SCREEN_HEIGHT *480/568, SCREEN_WIDTH - 80, SCREEN_HEIGHT * 40/568)];
    submitButton.titleLabel.numberOfLines = 0;
    submitButton.layer.cornerRadius =20;
    submitButton.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    submitButton.cornerRadius = SCREEN_HEIGHT * 22/568;
    [submitButton setTitle:@"确定" forState:UIControlStateNormal];
     [submitButton setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.f]];
    [submitButton addTarget:self action:@selector(queDing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];

}

//正向地理编码
-(void)searchGeocode{
    
    _apiKey = @"6bec592d15603e556999915510e4bd6e";    //高德地图apiKey
    
    [AMapSearchServices sharedServices].apiKey = _apiKey;             //配置用户Key
    
    _search = [[AMapSearchAPI alloc] init];                           //初始化检索对象
    _search.delegate = self;
    
    //构造AMapGeocodeSearchRequest对象，address为必选项，city为可选项
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    //    self.locationTextView.text = @"浙江杭州西湖西溪500号";
    
    _LocationString = _LocationName.text;
    //    NSLog(@"\n\n-------------_LocationString--------\n\n%@",_LocationString);
    
    geo.address = _LocationString;
    
    [_search AMapGeocodeSearch: geo];         //发起正向地理编码
    
    
}

#pragma mark - Button Click Action
//返回
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//打勾的按钮事件
- (IBAction)daGouButton:(UIButton *)sender {
 
    if (sender.tag == 10) {
        
        ownRole = @"个体服务者";
        
        [_geTiButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        
        [_dianPuButton setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
        
        _timeAndLocationBackView.hidden = YES;
        
    }else if (sender.tag == 20){
        
        ownRole = @"店铺服务者";
        
        [_geTiButton setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
        
        [_dianPuButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        
        _timeAndLocationBackView.hidden = NO;

    }else{
        
        [sender setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        NSString *tagStr = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        if (servics_idsArr.count >0) {
            
            for (int i = 0; i < servics_idsArr.count; i++) {
                
                NSString *str  = servics_idsArr[i];
                if (str == tagStr) {
                    
                    [servics_idsArr removeObject:str];
                    
                }else{
                    
                    [servics_idsArr addObject:tagStr];
                    
                }
            }

        }else{
        
            
        }
        
        [servics_idsArr addObject:tagStr];

    }

 
}

//成为服务者
-(void)queDing{
    
    NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    [self searchGeocode];
    
    //服务类型
    NSMutableString *service_item_ids;
    if (servics_idsArr.count == 0) {
        
        UIAlertView *notiAlert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"请选择服务项目"
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil, nil];
        [notiAlert show];
        
    }else{
        
        service_item_ids = [[NSMutableString alloc]init];
        for (int i = 0; i<servics_idsArr.count; i++) {
            if (i == 0) {
                
                [service_item_ids appendString:[NSString stringWithFormat:@"%@",servics_idsArr[i] ] ];
                
            }else{
                
                [service_item_ids appendString:[NSString stringWithFormat:@",%@",servics_idsArr[i] ] ];
                
            }
            
        }
        
        //服务时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSDate *date = [dateFormatter dateFromString:_openTimeLabel.text];
        NSDate *closeDate = [dateFormatter dateFromString:_closeTimeLabel.text];
        if (date == nil || closeDate == nil) {
            
        }else{
            
            unsigned int unitFlags = NSCalendarUnitMinute|NSCalendarUnitHour;
            NSDateComponents *d = [cal components:unitFlags fromDate:date];
            NSDateComponents *d1 = [cal components:unitFlags fromDate:closeDate];
            
            NSInteger openHour = [d hour];
            NSInteger openMin = [d minute];
            NSInteger open = openHour * 3600000 + openMin * 60000;
            yingYeTime = [NSString stringWithFormat:@"%ld",(long)open];
            
            NSInteger closeHour = [d1 hour];
            NSInteger closeMin = [d1 minute];
            NSInteger close = closeHour * 3600000 + closeMin * 60000;
            xieYeTime = [NSString stringWithFormat:@"%ld",(long)close];
            
        }
        
        if ([ownRole  isEqual: @"个体服务者"]) {
            
//            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//            
            NSDictionary *parameters = @{@"username":phoneNumber,
                                          @"role":ownRole,
                                         @"service_item_ids":service_item_ids};
            
//            NSLog(@"\n\n\%@",parameters);

            NSString * str = [NSString stringWithFormat:@"http://114.215.203.95:82/v1/user/server-update"];
            
            [session POST:str
               parameters:parameters
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      
                      UIAlertView *notiAlert = [[UIAlertView alloc]
                                                initWithTitle:nil
                                                message:@"欢迎成为服务者！"
                                                delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
                      
                      [notiAlert show];
                      [self dismissViewControllerAnimated:YES completion:nil];
                      
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      NSLog(@"\n\n%@",error);
                      
                      UIAlertView *notiAlert = [[UIAlertView alloc]
                                                initWithTitle:nil
                                                message:@"网络错误！"
                                                delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
                      
                      [notiAlert show];
                      
                  }];
            
            
        }else{
            if (date == nil || closeDate == nil) {
                
                UIAlertView *notiAlert = [[UIAlertView alloc]
                                          initWithTitle:nil
                                          message:@"请选择服务时间段！"
                                          delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
                
                [notiAlert show];
                
            }else{
                
                if (strGeocodes.latitude == 0.000000 && strGeocodes.latitude == 0.000000 ) {
                    
                    UIAlertView *notiAlert = [[UIAlertView alloc]
                                              initWithTitle:nil
                                              message:@"请填写地理位置！"
                                              delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
                    
                    [notiAlert show];
                    
                }else{
                    
                    NSString *tiJiaolatitude = [NSString stringWithFormat:@"%f",strGeocodes.latitude];
                    NSString *tiJiaolongitude = [NSString stringWithFormat:@"%f",strGeocodes.longitude];
                    
                    NSDictionary *parameters = @{@"username":phoneNumber,
                                                 @"role":ownRole,
                                                 @"opening_time":yingYeTime,
                                                 @"closing_time":xieYeTime,
                                                 @"service_item_ids":service_item_ids,
                                                 @"longitude":tiJiaolongitude,
                                                 @"latitude":tiJiaolatitude,
                                                 @"address":_LocationName.text};
//                    NSLog(@"\n\n\%@",parameters);

                    NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/user/server-update"];
                    
                    [session POST:str
                       parameters:parameters
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              
                              UIAlertView *notiAlert = [[UIAlertView alloc]
                                                        initWithTitle:nil
                                                        message:@"欢迎成为服务者！"
                                                        delegate:nil
                                                        cancelButtonTitle:@"确定"
                                                        otherButtonTitles:nil, nil];
                              
                              [notiAlert show];
                              [self dismissViewControllerAnimated:YES completion:nil];
                              
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              
                              NSLog(@"%@",error);
                              UIAlertView *notiAlert = [[UIAlertView alloc]
                                                        initWithTitle:nil
                                                        message:@"网络错误！"
                                                        delegate:nil
                                                        cancelButtonTitle:@"确定"
                                                        otherButtonTitles:nil, nil];
                              
                              [notiAlert show];
                              
                          }];
                    
                }
                
            }
            
        }
        
    }
    
 }

//营业歇业时间选择器
- (IBAction)closeTimeClick:(UIButton *)sender {
    
    NSInteger minuteInterval = 1;
    
    NSInteger referenceTimeInterval = (NSInteger)[self.selectedTime timeIntervalSinceReferenceDate];
    NSInteger remainingSeconds = referenceTimeInterval % (minuteInterval *60);
    NSInteger timeRoundedTo5Minutes = referenceTimeInterval - remainingSeconds;
    if(remainingSeconds>((minuteInterval*60)/2)) {
        
        timeRoundedTo5Minutes = referenceTimeInterval +((minuteInterval*60)-remainingSeconds);
        
    }
    
    self.selectedTime = [NSDate dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)timeRoundedTo5Minutes];
    
    ActionSheetDatePicker *datePicker ;
    if (sender.tag == 1) {
        
        
        datePicker = [[ActionSheetDatePicker alloc]
                      initWithTitle:@"请选择营业时间"
                      datePickerMode:UIDatePickerModeTime
                      selectedDate:self.selectedTime
                      target:self
                      action:@selector(timeWasSelectedOne:element:)
                      origin:sender];
        
        
    }else{
        
        datePicker = [[ActionSheetDatePicker alloc]
                      initWithTitle:@"请选择歇业时间"
                      datePickerMode:UIDatePickerModeTime
                      selectedDate:self.selectedTime
                      target:self
                      action:@selector(timeWasSelected:element:)
                      origin:sender];
        
        
    }
    
    
    
    datePicker.minuteInterval = minuteInterval;
    
    UIButton *okButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateNormal];
    [okButton setFrame:CGRectMake(0, 0, 32, 32)];
    [datePicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:okButton]];
    
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"cha"] forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(0, 0, 32, 32)];
    [datePicker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    [datePicker showActionSheetPicker];
    
}

//歇业时间
-(void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    
    self.selectedTime = selectedTime;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"h:mm a"];
    
    self.closeTimeLabel.text = [dateFormatter stringFromDate:selectedTime];
    
}

//营业时间
-(void)timeWasSelectedOne:(NSDate *)selectedTime element:(id)element {
    
    self.selectedTime = selectedTime;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"h:mm a"];
    
    self.openTimeLabel.text = [dateFormatter stringFromDate:selectedTime];
    
}

#pragma mark - AMapGeocode
//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    
    if(response.geocodes.count == 0){
        
        return;
        
    }
    
    //初始化正编码的地理坐标
    strGeocodes = [[AMapGeoPoint alloc]init];
    for (AMapTip *p in response.geocodes) {
        
        strGeocodes = p.location;
        
    }
    
}

#pragma mark  UITextField
//点击Return键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 回收键盘,取消第一响应者
    [textField resignFirstResponder];
    
    return YES;
    
}

//view上移
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateKeyframesWithDuration:1
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeLinear
                              animations:^{
                                  
                                  if (textField ==_LocationName) {
                                      self.view.frame = CGRectMake(0, 0-200, SCREEN_WIDTH, SCREEN_HEIGHT-64) ;
                                  }
                                  
                              } completion:nil];
    
}

//结束编辑调用的方法
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        if (textField == _LocationName) {
            
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) ;
            
        }
        
    } completion:nil];
    _LocationString = _LocationName.text;
    
    [self searchGeocode];               //地理反编码初始化
    
    
}

#pragma mark  点击背景键盘回收
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
    [_LocationName resignFirstResponder];
    
    _LocationString = _LocationName.text;
    
    [self searchGeocode];               //地理反编码初始化
    
}

#pragma mark - locationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    [_locationManager stopUpdatingLocation];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            
            NSString *string1,*string2,*string3,*string4;
            if (placemark.locality == nil){
                
                string1  = @"";
                
            }else{
                
                string1 = [NSString stringWithFormat:@"%@",placemark.locality];
                
            }
            
            if (placemark.subLocality == nil){
                
                string2  = @"";
                
            }else{
                
                string2 = [NSString stringWithFormat:@"%@",placemark.subLocality];
                
            }
            
            if (placemark.thoroughfare == nil){
                
                string3  = @"";
                
            }
            else{
                
                string3 = [NSString stringWithFormat:@"%@",placemark.thoroughfare];
                
            }
            
            if (placemark.subThoroughfare == nil){
                
                string4  = @"";
                
            }
            else{
                
                string4 = [NSString stringWithFormat:@"%@",placemark.subThoroughfare];
                
            }
            
            _LocationName.text = [NSString stringWithFormat:@"%@%@%@%@",string1,string2,string3,string4];
            
        }
        
    }];
    
}


@end
