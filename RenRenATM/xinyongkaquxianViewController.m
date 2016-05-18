//
//  xinyongkaquxianViewController.m
//  RenRenATM
//
//
//
//
#import "xinyongkaquxianViewController.h"
#define NUMBERS @"0123456789"
#define TopViewHeight ((SCREEN_HEIGHT -44)/10*3)
#define modelViewHeight ((SCREEN_HEIGHT -44)/12 )

#import "AFNetworking.h"
#import "MustLogin.h"


@interface xinyongkaquxianViewController ()<UITextFieldDelegate,CLLocationManagerDelegate>{
    
    CLLocationManager *_locationManager;
    UIImageView *AllImageView;
    UIButton *rightButton;
    UIImageView *modelView;
    UITextField *howMuchMoney,*qiTaJinEValue;
    UITextField *NeedMoney,*TotalMoney,*qitajinejutizhilabel,*xiaoshiField,*fenzhongField;
    NSString *dengluqianhou;
    UILabel *dengLuLabel,*placeField;
    UIButton *shiwuyuanButton,*wuyuanButton,*shiyuanButton;
    
    UITextView *infoView;
    UITextField *daishoukuanrenField,*daishoukuanRenHaoMaField;

}
@end

@implementation xinyongkaquxianViewController

@synthesize success,type;


#pragma mark - view
-(void)viewWillAppear:(BOOL)animated{
    
    [self initDengLuLabelShow];         //是否登录
    
}

#pragma mark - init  Value
//定位
- (void)initializeLocationService {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    [_locationManager startUpdatingLocation];
    
}

#pragma mark - init  View
-(void)initDengLuLabelShow{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    NSString *phoneNumber = [userDefault objectForKey:@"user_name"];
    
    if (access_token==nil) {
        
        dengLuLabel.text =@"点击登录人人ATM";
        
    }
    else{
        
        dengLuLabel.text = phoneNumber;
        
    }
    
}
#pragma mark - Button Click Action

#pragma mark - Other Action

#pragma mark - locationManager 代理
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

            placeField.text = [NSString stringWithFormat:@"%@%@%@%@",string1,string2,string3,string4];
            
        }
        
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    NSString *phoneNumber = [userDefault objectForKey:@"user_name"];
    if (access_token==nil) {
        dengluqianhou =@"点击登录人人ATM";
    }
    else
    {
        dengluqianhou =phoneNumber;
    }
    // Do any additional setup after loading the view from its nib.
    //全局背景图片
    AllImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ];
    AllImageView.image = [UIImage imageNamed:@"RenRenGray"];
    [self.view addSubview:AllImageView];
    
    //顶部图片
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
    topImageView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    AllImageView.userInteractionEnabled = YES;
    [self.view addSubview:topImageView];
    
    //创建返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back-Small"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(BackView) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:backButton];
    //顶部人人图标
    UIImageView *topAvatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -TopViewHeight/2)/2, TopViewHeight/4, TopViewHeight/2, TopViewHeight/2)];
    topAvatarImageView.image = [UIImage imageNamed:@"individual_user"];
    
    UITapGestureRecognizer * TapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Login)];
    
    topImageView.userInteractionEnabled = YES;
    topAvatarImageView.userInteractionEnabled = YES;
    [topAvatarImageView addGestureRecognizer:TapGestureRecognizer];
    [topImageView addSubview:topAvatarImageView];
    //点击登录人人ATM
    dengLuLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, TopViewHeight/4*3, 150, TopViewHeight/4)];
    dengLuLabel.textColor = [UIColor whiteColor];
    dengLuLabel.backgroundColor = [UIColor clearColor];
    dengLuLabel.textAlignment =NSTextAlignmentCenter;
    dengLuLabel.text =dengluqianhou;
    [topImageView addSubview:dengLuLabel];
    
    //白色view
    UIImageView *baiSeBeiJingView = [[UIImageView alloc]init];
    baiSeBeiJingView.backgroundColor = [UIColor whiteColor];
    [AllImageView addSubview:baiSeBeiJingView];
    
    
    //信用卡取现label
    UILabel *daishoukuanLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/4)/2, 0 , SCREEN_WIDTH/4, modelViewHeight/4*3)];
    daishoukuanLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    
    daishoukuanLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    if ([type isEqualToString:@"1"]) {
        daishoukuanLabel.text =@"信用卡取现";
    }
    else if ([type isEqualToString:@"2"]) {
        daishoukuanLabel.text =@"银行卡取现";
    }
    else if ([type isEqualToString:@"3"]) {
        daishoukuanLabel.text =@"代收款取现";
    }
    else if ([type isEqualToString:@"5"]) {
        daishoukuanLabel.text =@"我要存钱";
    }
    else if ([type isEqualToString:@"6"]) {
        daishoukuanLabel.text =@"我要转账";
    }
    else if ([type isEqualToString:@"7"]) {
        daishoukuanLabel.text =@"我要换零钱";
    }
    else if ([type isEqualToString:@"8"]) {
        daishoukuanLabel.text =@"我要换整钱";
    }

    
    daishoukuanLabel.adjustsFontSizeToFitWidth = YES;
    [baiSeBeiJingView addSubview:daishoukuanLabel];
    
    //1分钟label
    UILabel *yifenzhongLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, daishoukuanLabel.frame.origin.y + daishoukuanLabel.frame.size.height ,SCREEN_WIDTH /5*3, modelViewHeight/2
                                                                        )];
    yifenzhongLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    
    yifenzhongLabel.adjustsFontSizeToFitWidth = YES;
    yifenzhongLabel.text =@"只需1分钟，快速发布交易信息";
    [baiSeBeiJingView addSubview:yifenzhongLabel];
    
    
    for (int i = 0 ; i< 7; i++) {
        if (i<5) {
            modelView = [[UIImageView alloc]initWithFrame:CGRectMake(15,5+ yifenzhongLabel.frame.origin.y + yifenzhongLabel.frame.size.height + i*modelViewHeight, SCREEN_WIDTH-30, modelViewHeight)];
            modelView.backgroundColor = [UIColor whiteColor];
//            modelView.backgroundColor = [UIColor greenColor];
            [baiSeBeiJingView addSubview:modelView];
            //左
            UILabel *zuoXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, modelViewHeight)];
            zuoXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
            [modelView addSubview:zuoXianLabel];
            //右
            UILabel *youXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(modelView.frame.size.width-1, 0, 1, modelViewHeight)];
            youXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
            [modelView addSubview:youXianLabel];
            if (i>0) {
                //上
                UILabel *shangXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, modelView.frame.size.width, 0.5)];
                shangXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:shangXianLabel];
            }
            else
            {
                //上
                UILabel *shangXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, modelView.frame.size.width, 1)];
                shangXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:shangXianLabel];
            }
            
            //下
            UILabel *xiaXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, modelView.frame.size.height -0.5, modelView.frame.size.width, 1)];
            xiaXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
            [modelView addSubview:xiaXianLabel];
            
            //左中
            UILabel *zuozhongXianLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4, modelViewHeight/4, 1, modelViewHeight/2)];
            zuozhongXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
            [modelView addSubview:zuozhongXianLabel];
            NSArray *array = [NSArray arrayWithObjects:@"所需金额",@"费用",@"给予赏金",@"所在位置",@"有效时间", nil];
            UILabel *fourZuoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 60, modelView.frame.size.height)];
            fourZuoLabel.text = array[i];
            fourZuoLabel.font = [UIFont systemFontOfSize:14];
            fourZuoLabel.numberOfLines =0;
            fourZuoLabel.adjustsFontSizeToFitWidth = YES;
            fourZuoLabel.textAlignment = NSTextAlignmentCenter;
            [modelView addSubview:fourZuoLabel];
            AllImageView.userInteractionEnabled = YES;
            baiSeBeiJingView.userInteractionEnabled = YES;
            
            //在第一个所需金额的框里
            if (i == 0) {
                
                //¥金额(SCREEN_WIDTH-30)/4 - 10
                UILabel *jinqianfuhaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+30, 0, 20, modelViewHeight)];
                jinqianfuhaoLabel.text =@"¥";
                jinqianfuhaoLabel.font = [UIFont systemFontOfSize:13];
                jinqianfuhaoLabel.textColor = [UIColor grayColor];
                [modelView addSubview:jinqianfuhaoLabel];
                //所需金额
                 howMuchMoney = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH /2-40, 0, 60, modelViewHeight)];
//                howMuchMoney.backgroundColor = [UIColor yellowColor];
                howMuchMoney.placeholder = @"20000";
                howMuchMoney.font = [UIFont systemFontOfSize: 13];
                howMuchMoney.textAlignment = NSTextAlignmentCenter;
                howMuchMoney.delegate = self;
                [modelView addSubview:howMuchMoney];
                
                
                modelView.userInteractionEnabled = YES;
                howMuchMoney.userInteractionEnabled = YES;
                
 
            }
            if (i==1) {
//                服务跑腿费
                UILabel *fuWuPaoLuFei = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + 10, 0, 80, modelViewHeight)];
                fuWuPaoLuFei.text =@"服务跑腿费";
                fuWuPaoLuFei.font = [UIFont systemFontOfSize:13];
                fuWuPaoLuFei.textColor = [UIColor grayColor];
                [modelView addSubview:fuWuPaoLuFei];
                //服务跑腿费
                 NeedMoney = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH- 30)/2 - 12+10, 0, (SCREEN_WIDTH -30)/4+12 +40 , modelViewHeight)];
                //                NeedMoney.backgroundColor = [UIColor greenColor];
//                NeedMoney.text = [NSString stringWithFormat:@"¥"];
                NeedMoney.textColor = [UIColor grayColor];
                NeedMoney.font = [UIFont systemFontOfSize:12];
                NeedMoney.userInteractionEnabled  =NO;
                NeedMoney.textAlignment = NSTextAlignmentLeft;
                NeedMoney.adjustsFontSizeToFitWidth = YES;
                [modelView addSubview:NeedMoney];
                
                
                //总共金额
               TotalMoney = [[UITextField alloc]initWithFrame:CGRectMake(modelView.frame.size.width-((SCREEN_WIDTH-30)/4 + 10)-40, 0, (SCREEN_WIDTH -30)/4+40, modelViewHeight)];
                TotalMoney.text =[NSString stringWithFormat:@" 合计 ¥"];
                TotalMoney.textAlignment = NSTextAlignmentRight;
                TotalMoney.userInteractionEnabled = NO;
                TotalMoney.font = [UIFont systemFontOfSize:12];
                TotalMoney.textColor = [UIColor grayColor];
                TotalMoney.adjustsFontSizeToFitWidth = YES;
                [modelView addSubview:TotalMoney];
                modelView.userInteractionEnabled = YES;
                howMuchMoney.userInteractionEnabled = YES;
            }
            //打赏金额
            if (i==2) {
                modelView.userInteractionEnabled = YES;
                //选中五元的
                wuyuanButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5/5, (modelViewHeight -10)/2, 10, 10)];
                wuyuanButton.layer.borderWidth=1;
                wuyuanButton.layer.cornerRadius = 5;
                wuyuanButton.userInteractionEnabled = YES;
                [wuyuanButton addTarget:self action:@selector(wuyuan) forControlEvents:UIControlEventTouchUpInside];
                wuyuanButton.layer.borderColor = [[UIColor blueColor] CGColor];
                [modelView addSubview:wuyuanButton];
                
                //五元Label
                UILabel *wuyuanlabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5/5*3, (modelViewHeight  - 20)/2, 20, 20)];
                wuyuanlabel.text = @"5¥";
                wuyuanlabel.font = [UIFont systemFontOfSize:12];
                wuyuanlabel.adjustsFontSizeToFitWidth  = YES;
                [modelView addSubview:wuyuanlabel];
                
                //选中十元的
                shiyuanButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5 , (modelViewHeight -10)/2, 10, 10)];
                shiyuanButton.layer.borderWidth=1;
                [shiyuanButton addTarget:self action:@selector(shiyuan) forControlEvents:UIControlEventTouchUpInside];
                shiyuanButton.layer.cornerRadius = 5;
                shiyuanButton.layer.borderColor = [[UIColor blueColor] CGColor];
                [modelView addSubview:shiyuanButton];
                
                //十元Label
                UILabel *shiyuanlabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5 +(SCREEN_WIDTH-30)/4*3/5/5*2, (modelViewHeight  - 20)/2, 20, 20)];
                shiyuanlabel.text = @"10¥";
                shiyuanlabel.font = [UIFont systemFontOfSize:13];
                shiyuanlabel.adjustsFontSizeToFitWidth  = YES;
                [modelView addSubview:shiyuanlabel];
                
                //选中十五元的
                shiwuyuanButton = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*2 , (modelViewHeight -10)/2, 10, 10)];
                shiwuyuanButton.backgroundColor = [UIColor blueColor];
                shiwuyuanButton.layer.borderWidth=1;
                shiwuyuanButton.layer.cornerRadius = 5;
                [shiwuyuanButton addTarget:self action:@selector(shiwuyuan) forControlEvents:UIControlEventTouchUpInside];
                shiwuyuanButton.layer.borderColor = [[UIColor blueColor] CGColor];
                [modelView addSubview:shiwuyuanButton];
                
                //十五元Label
                UILabel *shiwuyuanlabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*2 +(SCREEN_WIDTH-30)/4*3/5/5*2, (modelViewHeight  - 20)/2, 20, 20)];
                shiwuyuanlabel.text = @"0¥";
                shiwuyuanlabel.font = [UIFont systemFontOfSize:13];
                shiwuyuanlabel.adjustsFontSizeToFitWidth  = YES;
                [modelView addSubview:shiwuyuanlabel];
                
                //其它金额button
                CGRect frame = CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*3 -15, (modelViewHeight  - 20)/2,  (SCREEN_WIDTH-30)/4*3/5 + 10, 20);
                BFPaperButton *qitajineButton = [[BFPaperButton alloc] initWithFrame:frame];
                qitajineButton.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
                [qitajineButton setTitle:@"其他金额" forState:UIControlStateNormal];
                qitajineButton.titleLabel.font = [UIFont systemFontOfSize:11];
                [qitajineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [qitajineButton addTarget:self action:@selector(qiTaJinEClick:) forControlEvents:UIControlEventTouchUpInside];
                [modelView addSubview:qitajineButton];
                
                //其它金额具体指Label
                qitajinejutizhilabel = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*4-20, (modelViewHeight  - 20)/2,  (SCREEN_WIDTH-30)/4*3/5/5*4+20, 20)];
                qitajinejutizhilabel.textAlignment = NSTextAlignmentCenter;
                qitajinejutizhilabel.text = @"0";
                qitajinejutizhilabel.enabled = NO;
                qitajinejutizhilabel.delegate = self;
                qitajinejutizhilabel.placeholder = @"0";
                qitajinejutizhilabel.font = [UIFont systemFontOfSize:12];
                qitajinejutizhilabel.adjustsFontSizeToFitWidth  = YES;
                [modelView addSubview:qitajinejutizhilabel];
                
                //其它金额符号Label
                UILabel *jinqianfuhaolabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*4 + (SCREEN_WIDTH-30)/4*3/5/5*4-10, (modelViewHeight  - 20)/2,  (SCREEN_WIDTH-30)/4*3/5/5, 20)];
                jinqianfuhaolabel.text = @"¥";
                jinqianfuhaolabel.font = [UIFont systemFontOfSize:12];
                jinqianfuhaolabel.adjustsFontSizeToFitWidth  = YES;
                [modelView addSubview:jinqianfuhaolabel];
                
            }
            if (i ==3) {
                //所在位置
                placeField = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, (SCREEN_WIDTH -140), modelViewHeight)];
                placeField.text = [NSString stringWithFormat:@"所在位置"];
                placeField.numberOfLines = 0;
                placeField.textColor = [UIColor grayColor];
//                placeField.font = [UIFont systemFontOfSize: 15];
                placeField.textAlignment = NSTextAlignmentCenter;
                placeField.adjustsFontSizeToFitWidth = YES;
                
                [modelView addSubview:placeField];
                modelView.userInteractionEnabled = YES;
                placeField.userInteractionEnabled = YES;
            }
            if (i==4) {
//                //所需时间
                modelView.userInteractionEnabled = YES;
                //其它shiLabelLabel
                UILabel *shiLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*2, (modelViewHeight  - 20)/2,  20, 20)];
                shiLabel.text = @"时";
                shiLabel.font = [UIFont systemFontOfSize:15];
                shiLabel.adjustsFontSizeToFitWidth  = YES;
                [modelView addSubview:shiLabel];
                
                //其它shiLabelLabel
               xiaoshiField= [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*1.5, (modelViewHeight  - 20)/2,  49, 20)];
                xiaoshiField.placeholder =  @"1";
                xiaoshiField.delegate = self;
                xiaoshiField.userInteractionEnabled = YES;
                [modelView addSubview:xiaoshiField];
                
                //其它shiLabelLabel
                UILabel *fenLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*3 , (modelViewHeight  - 20)/2,  20, 20)];
                fenLabel.text = @"分";
                fenLabel.font = [UIFont systemFontOfSize:15];
                fenLabel.adjustsFontSizeToFitWidth  = YES;
                [modelView addSubview:fenLabel];
                
                //其它shiLabelLabel
                fenzhongField= [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*2.5, (modelViewHeight  - 20)/2,  40, 20)];
                fenzhongField.placeholder =  @"0";
                fenzhongField.delegate = self;
                fenzhongField.userInteractionEnabled = YES;
                [modelView addSubview:fenzhongField];

            }
            
        }
       else if (i == 5)
        {
            //先判断有否在做
            if ([success isEqualToString:@"1"]) {
                modelView = [[UIImageView alloc]initWithFrame:CGRectMake(15,5+ yifenzhongLabel.frame.origin.y + yifenzhongLabel.frame.size.height + 4*modelViewHeight, SCREEN_WIDTH-30, modelViewHeight)];
                modelView.backgroundColor = [UIColor whiteColor];
                [baiSeBeiJingView addSubview:modelView];
                
                //左
                UILabel *zuoXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, modelViewHeight)];
                zuoXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:zuoXianLabel];
                //右
                UILabel *youXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(modelView.frame.size.width-1, 0, 1, modelViewHeight)];
                youXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:youXianLabel];
                
                //上
                UILabel *shangXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, modelView.frame.size.width, 0.5)];
                shangXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:shangXianLabel];
                
                
                //下
                UILabel *xiaXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, modelView.frame.size.height -0.5, modelView.frame.size.width, 1)];
                xiaXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:xiaXianLabel];
                
                //左中
                UILabel *zuozhongXianLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4, modelViewHeight/4, 1, modelViewHeight/2)];
                zuozhongXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:zuozhongXianLabel];
                
                UILabel *daishoukuanrenLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, (SCREEN_WIDTH-30)/4 - 10, modelView.frame.size.height)];
                daishoukuanrenLabel.text = @"代收款人";
                daishoukuanrenLabel.adjustsFontSizeToFitWidth = YES;
                daishoukuanrenLabel.textAlignment = NSTextAlignmentCenter;
                [modelView addSubview:daishoukuanrenLabel];
                //待收款人
                daishoukuanrenField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, (SCREEN_WIDTH -110), modelViewHeight)];
                daishoukuanrenField.placeholder = [NSString stringWithFormat:@"收款人姓名"];
                daishoukuanrenField.font = [UIFont systemFontOfSize:15];
                daishoukuanrenField.textColor = [UIColor grayColor];
                daishoukuanrenField.textAlignment = NSTextAlignmentCenter;
                daishoukuanrenField.adjustsFontSizeToFitWidth = YES;
                [modelView addSubview:daishoukuanrenField];
                modelView.userInteractionEnabled = YES;
                daishoukuanrenField.userInteractionEnabled = YES;
            }
            else
            {
            }
        }else if (i == 6){
            
            //先判断有否在做
            if ([success isEqualToString:@"1"]) {
                modelView = [[UIImageView alloc]initWithFrame:CGRectMake(15,5+ yifenzhongLabel.frame.origin.y + yifenzhongLabel.frame.size.height + 5*modelViewHeight, SCREEN_WIDTH-30, modelViewHeight)];
                modelView.backgroundColor = [UIColor whiteColor];
                [baiSeBeiJingView addSubview:modelView];
                
                //左
                UILabel *zuoXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, modelViewHeight)];
                zuoXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:zuoXianLabel];
                //右
                UILabel *youXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(modelView.frame.size.width-1, 0, 1, modelViewHeight)];
                youXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:youXianLabel];
                
                //上
                UILabel *shangXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, modelView.frame.size.width, 0.5)];
                shangXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:shangXianLabel];
                
                
                //下
                UILabel *xiaXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, modelView.frame.size.height -0.5, modelView.frame.size.width, 1)];
                xiaXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:xiaXianLabel];
                
                //左中
                UILabel *zuozhongXianLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4, modelViewHeight/4, 1, modelViewHeight/2)];
                zuozhongXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
                [modelView addSubview:zuozhongXianLabel];
                
                UILabel *daishoukuanrenLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, (SCREEN_WIDTH-30)/4 - 10, modelView.frame.size.height)];
                daishoukuanrenLabel.text = @"收款号码";
                daishoukuanrenLabel.adjustsFontSizeToFitWidth = YES;
                daishoukuanrenLabel.textAlignment = NSTextAlignmentCenter;
                [modelView addSubview:daishoukuanrenLabel];
                  
            
                daishoukuanRenHaoMaField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, (SCREEN_WIDTH -110), modelViewHeight)];
                daishoukuanRenHaoMaField.placeholder = [NSString stringWithFormat:@"代收款人号码"];
                daishoukuanRenHaoMaField.font = [UIFont systemFontOfSize:15];
                daishoukuanRenHaoMaField.textColor = [UIColor grayColor];
                daishoukuanRenHaoMaField.textAlignment = NSTextAlignmentCenter;
                daishoukuanRenHaoMaField.adjustsFontSizeToFitWidth = YES;
                [modelView addSubview:daishoukuanRenHaoMaField];
                modelView.userInteractionEnabled = YES;
                daishoukuanRenHaoMaField.userInteractionEnabled = YES;
            }
            else
            {
            }

            
       
        }
        
    }
    //设置白色背景的尺寸
    baiSeBeiJingView.frame = CGRectMake(0, topImageView.frame.origin.y + topImageView.frame.size.height, SCREEN_WIDTH, modelView.frame.origin.y + modelViewHeight + 10) ;
    
    //最下面的发布button
    CGRect frame = CGRectMake(15, SCREEN_HEIGHT - modelViewHeight-20, SCREEN_WIDTH -30, modelViewHeight);
    BFPaperButton *fabuButton = [[BFPaperButton alloc] initWithFrame:frame];
    [fabuButton setTitle:@"Rounded" forState:UIControlStateNormal];
    fabuButton.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    fabuButton.layer.cornerRadius = modelViewHeight/2;
    fabuButton.cornerRadius = modelViewHeight/2;
    fabuButton.liftedShadowOffset = CGSizeMake(0, 5);
    fabuButton.loweredShadowOffset= CGSizeMake(0, 1.5);
    [fabuButton setTitle:@"发布" forState:UIControlStateNormal];
    [fabuButton addTarget:self action:@selector(fabu) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:fabuButton];
    
    [self initializeLocationService];
    
}
//让金额只能输入数字
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if (textField == howMuchMoney||textField ==fenzhongField||textField ||xiaoshiField) {
        NSCharacterSet*cs;
        
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
        NSString*filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入数字"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            
            [alert show];
            return NO;
            
        }
        return YES;
        
    }
    return YES;
}
//结束编辑调用的方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == howMuchMoney) {
        if ([howMuchMoney.text isEqualToString:@""]) {
          
            NeedMoney.text = @"0";
            NeedMoney.text = [NSString stringWithFormat:@"  ¥"];
            TotalMoney.text =[NSString stringWithFormat:@" 合计 ¥"];
        
        }
        else
        {
            float needMoney ;
//            NSLog(@"you");
            int howmuch= [howMuchMoney.text intValue];
            
            needMoney = 2 + [howMuchMoney.text floatValue]*0.005;

//            if ([type isEqualToString:@"1"]) {
//                if (howmuch<=500) {
//                    needMoney =  5 + 2 + [howMuchMoney.text floatValue]*0.0049;
//                }
//                else  if (howmuch<=5000) {
//                    needMoney =  10 + 2 + [howMuchMoney.text floatValue]*0.0049;
//                }
//                else if (howmuch<=20000)
//                {
//                    needMoney =  20 + 2 + [howMuchMoney.text floatValue]*0.0049;
//                }
//            }
//            else if ([type isEqualToString:@"2"]) {
//                if (howmuch<=500) {
//                    needMoney =  5 + 2 + [howMuchMoney.text floatValue]*0.0049;
//                }
//                else  if (howmuch<=5000) {
//                    needMoney =  10 + 2 + [howMuchMoney.text floatValue]*0.0049;
//                }
//                else if (howmuch<=20000)
//                {
//                    needMoney =  20 + 2 + [howMuchMoney.text floatValue]*0.0049;
//                }
//            }
//            else if ([type isEqualToString:@"3"]) {
//                if (howmuch<=500) {
//                    needMoney =  5;
//                }
//                else  if (howmuch<=5000) {
//                    needMoney =  10 ;
//                }
//                else if (howmuch<=20000)
//                {
//                    needMoney =  20 ;
//                }
//            }
//            else if ([type isEqualToString:@"5"]) {
//                if (howmuch<=500) {
//                    needMoney =  5;
//                }
//                else  if (howmuch<=5000) {
//                    needMoney =  10 ;
//                }
//                else if (howmuch<=20000)
//                {
//                    needMoney =  20 ;
//                }
//
//            }
//            else if ([type isEqualToString:@"6"]) {
//                if (howmuch<=500) {
//                    needMoney =  5 + 2 + [howMuchMoney.text floatValue]*0.0049;
//                }
//                else  if (howmuch<=5000) {
//                    needMoney =  10 + 2 + [howMuchMoney.text floatValue]*0.0049;
//                }
//                else if (howmuch<=20000)
//                {
//                    needMoney =  20 + 2 + [howMuchMoney.text floatValue]*0.0049;
//                }
//            }
//            else if ([type isEqualToString:@"7"]) {
//                if (howmuch<=500) {
//                    needMoney =  5;
//                }
//                else  if (howmuch<=5000) {
//                    needMoney =  10 ;
//                }
//                else if (howmuch<=20000)
//                {
//                    needMoney =  20 ;
//                }
//            }
//            else if ([type isEqualToString:@"8"]) {
//                if (howmuch<=500) {
//                    needMoney =  5;
//                }
//                else  if (howmuch<=5000) {
//                    needMoney =  10 ;
//                }
//                else if (howmuch<=20000)
//                {
//                    needMoney =  20 ;
//                }
//            }

             NeedMoney.text = [NSString stringWithFormat:@"%.2f",needMoney];
            TotalMoney.text = [NSString stringWithFormat:@"合计%.2f¥",needMoney + [howMuchMoney.text intValue]];
        }
      
    }
    if (textField == fenzhongField) {
        if ([fenzhongField.text intValue]>59)
        {
        fenzhongField.text =@"59";
        }
    }
    if (textField ==fenzhongField||textField==xiaoshiField) {

            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ;

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  点击背景键盘回收
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark  UITextField
//点击Return键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 回收键盘,取消第一响应者
    [textField resignFirstResponder]; return YES;
}
////跳转到设置界面
//-(void)setting
//{
//    SettingViewController *setting = [[SettingViewController alloc]init];
//    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:setting];
//    [self presentViewController:navi animated:NO completion:nil];
//    
//    
//}
//跳转到登录
-(void)Login
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    if (access_token==nil) {
//        NSLog(@"123");
        MustLogin *Login = [[MustLogin alloc]init];
        [self presentViewController:Login animated:NO completion:nil];
    }
    else
    {
        
    }
    
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == qitajinejutizhilabel) {
        wuyuanButton.backgroundColor = [UIColor clearColor];
        shiyuanButton.backgroundColor = [UIColor clearColor];
        shiwuyuanButton.backgroundColor = [UIColor clearColor];
    }
    if (textField ==xiaoshiField||textField == fenzhongField) {
        self.view.frame = CGRectMake(0, 0-150, SCREEN_WIDTH, SCREEN_HEIGHT) ;
    }


}
//发布订单
-(void)fabu
{
    NSString *str = howMuchMoney.text;
    int _int1 = [str intValue];
    int _int2 = 20000;
    if ( _int1 > _int2) {
        UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:@"所需金额不可大于20000！"
                                                        message:@"请重新输入金额"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        [_alert show];
        howMuchMoney.text = @"";
    }else{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    NSString *user_id = [userDefault objectForKey:@"user_id"];
    if (access_token==nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请先登录后发布" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if ([qitajinejutizhilabel.text isEqualToString:@""]) {
            qitajinejutizhilabel.text = @"0";
        }
        if ([fenzhongField.text isEqualToString:@""]) {
            fenzhongField.text = @"0";
        }
        if ([xiaoshiField.text isEqualToString:@""]) {
            xiaoshiField.text = @"1";
        }
        NSDate *date = [NSDate date];
//        NSLog(@"当前日期为:%@",date);
        NSTimeInterval timeStamp= [date timeIntervalSince1970];
//        NSLog(@"日期转换为时间戳 %@ = %f", date, timeStamp);
        int needTimeSecond = [xiaoshiField.text intValue]*3600 + [fenzhongField.text intValue]*60  + timeStamp + 8*60*60;
        NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
        
        NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
//        NSLog(@"encodeResult:%@",token);
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        session.requestSerializer = [AFJSONRequestSerializer serializer];
        session.responseSerializer = [AFJSONResponseSerializer serializer];
        [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
        if ([success isEqualToString:@"1"]) {
 
            NSDictionary *extra_fields = @{
                                           @"receiver":daishoukuanrenField.text,
                                           @"receiver_phone":daishoukuanRenHaoMaField.text
                                           };
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extra_fields options:NSJSONWritingPrettyPrinted error:&error];
            
            NSDictionary *parameters = @{@"money":howMuchMoney.text,
                                         @"dealt_at":placeField.text,
                                         @"sent_at":placeField.text,
                                         @"tip":qitajinejutizhilabel.text,
                                         @"service_item_id":type,
                                         @"time_limit":[NSString stringWithFormat:@"%d",needTimeSecond],
                                         @"status":@"101",
                                         @"service_charge":NeedMoney.text,
                                         @"sent_by":user_id,
                                         @"extra_fields":jsonData
                                        };
            NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/orders"];
            
            [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            } progress:^(NSProgress * _Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                 NSLog(@"===============responseObject===========%@",responseObject);
              
                [UIView animateKeyframesWithDuration:5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                } completion:nil];
                
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"发布成功"delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                
                [alert show];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //            NSLog(@"error%@",error);
            }];

        }else{
         NSDictionary *parameters = @{@"money":howMuchMoney.text,
                                     @"dealt_at":placeField.text,
                                     @"sent_at":placeField.text,
                                     @"tip":qitajinejutizhilabel.text,
                                     @"service_item_id":type,
                                     @"time_limit":[NSString stringWithFormat:@"%d",needTimeSecond],
                                     @"status":@"101",
                                     @"service_charge":NeedMoney.text,
                                     @"sent_by":user_id};
        NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/orders"];
            
            [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                //            NSLog(@"formData%@",formData);
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                //            NSLog(@"uploadProgress%@",uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [UIView animateKeyframesWithDuration:5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                } completion:nil];
                
                //            NSLog(@"===============responseObject===========%@",responseObject);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"发布成功"delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                
                [alert show];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //            NSLog(@"error%@",error);
            }];
            
        }
        
       
        
    
        
    }
    
    }
   
}


//选择5元10元0元
-(void)wuyuan
{
    wuyuanButton.backgroundColor = [UIColor blueColor];
    shiyuanButton.backgroundColor = [UIColor clearColor];
    shiwuyuanButton.backgroundColor = [UIColor clearColor];
    qitajinejutizhilabel.text = @"5";
}
-(void)shiyuan
{
    shiyuanButton.backgroundColor = [UIColor blueColor];
    wuyuanButton.backgroundColor = [UIColor clearColor];
    shiwuyuanButton.backgroundColor = [UIColor clearColor];
    qitajinejutizhilabel.text = @"10";}
-(void)shiwuyuan
{
    shiwuyuanButton.backgroundColor = [UIColor blueColor];
    shiyuanButton.backgroundColor = [UIColor clearColor];
    wuyuanButton.backgroundColor = [UIColor clearColor];
    qitajinejutizhilabel.text = @"0";
}

-(void)wenhao
{
    [self.view addSubview:infoView];
}
-(void)guanbi
{
    [infoView removeFromSuperview];
}
//alert的按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    

        //NSLog(@"alert1 button index=%ld is clicked.....", (long)buttonIndex);
        if(buttonIndex == 0){
//            NSLog(@"0");
//            [self dismissViewControllerAnimated:NO completion:nil];
             qitajinejutizhilabel.text = qiTaJinEValue.text;
        }
        else
        {
//            NSLog(@"😳");
        }

}
#pragma mark 导航条返回事件
-(void)BackView
{
    [self dismissViewControllerAnimated:NO completion:nil];
}



-(void)qiTaJinEClick:(UIButton *)qiTaJinEClick
{
    //    NSLog(@"+++++++++clicked++++++++");
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"请输入其它金额"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    // 基本输入框，显示实际输入的内容
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //设置输入框的键盘类型
    qiTaJinEValue = [alert textFieldAtIndex:0];
    qiTaJinEValue.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
    
}






@end
