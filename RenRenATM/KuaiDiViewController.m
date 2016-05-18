//
//  KuaiDiViewController.m
//  RenRenATM
//
//
//
//我的快递

#import "KuaiDiViewController.h"
#define NUMBERS @"0123456789"
#define TopViewHeight ((SCREEN_HEIGHT -44)/10*3)
#define modelViewHeight (SCREEN_HEIGHT/568 * 40)
#define currentWidth (SCREEN_WIDTH / 568)



#import "AFNetworking.h"
#import <PopMenu.h>
#import "MustLogin.h"

@interface KuaiDiViewController ()<UITextFieldDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>{
    
    CLLocationManager *_locationManager;
    UIImageView *AllImageView;
    UIButton *rightButton;
    UIImageView *modelView;
    UITextField *howMuchMoney,*qiTaJinEValue;
    UITextField *NeedMoney,*TotalMoney,*qitajinejutizhilabel,*xiaoshiField,*fenzhongField;
    NSString *dengluqianhou;
    UILabel *dengLuLabel,*placeField,*waiHuiJinE;
    UIButton *lingYuanButton,*wuyuanButton,*shiyuanButton;
    UIAlertView *alertqianming;
    UIImageView *topImageView ;
    UIImageView *baiSeBeiJingView;
    UITextField *nameText,*weight,*payType;
}



@end

@implementation KuaiDiViewController

@synthesize success,type;

#pragma mark - view 生命周期
//在视图显示前出现的界面
-(void)viewWillAppear:(BOOL)animated{
    
    [self initValue];              //初始化
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initTopView];                    //上面的view
    
    [self initMainView];                   //主界面
    
    [self initializeLocationService];      //初始化定位
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }

#pragma mark - init
-(void)initValue{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    NSString *phoneNumber = [userDefault objectForKey:@"user_name"];
    
    //外汇页面上面登录时显示手机号码否则则登录
    if (access_token==nil){
    
        dengLuLabel.text =@"点击登录人人ATM";
    
    }else{
        
        dengLuLabel.text =phoneNumber;
    
    }

}

-(void)initTopView{

    //全局背景图片
    AllImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ];
    AllImageView.image = [UIImage imageNamed:@"RenRenGray"];
    [self.view addSubview:AllImageView];
    
    //顶部图片
    topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
    topImageView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    AllImageView.userInteractionEnabled = YES;
    topImageView.userInteractionEnabled = YES;
    [self.view addSubview:topImageView];
    
    //创建返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back-Small"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(BackView) forControlEvents:UIControlEventTouchUpInside];
    [topImageView addSubview:backButton];
    
    //顶部头像人人图标
    UIImageView *topAvatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -TopViewHeight/2)/2, TopViewHeight/4, TopViewHeight/2, TopViewHeight/2)];
    topAvatarImageView.image = [UIImage imageNamed:@"individual_user"];
    //点击手势
    UITapGestureRecognizer * TapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Login)];
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
    baiSeBeiJingView = [[UIImageView alloc]init];
    baiSeBeiJingView.backgroundColor = [UIColor whiteColor];
    [AllImageView addSubview:baiSeBeiJingView];


}

-(void)initMainView{
 
    for (int i = 0 ; i< 8; i++) {
        
        //白色背景
        modelView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4,5+ i*modelViewHeight, SCREEN_WIDTH/4 * 3 - 5, modelViewHeight)];
        modelView.backgroundColor = [UIColor whiteColor];
        [baiSeBeiJingView addSubview:modelView];
        
          //左
        UILabel *zuoXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 1, modelViewHeight)];
        zuoXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
        [modelView addSubview:zuoXianLabel];
        
        //右
        UILabel *youXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(modelView.frame.size.width-2, 0, 1, modelViewHeight)];
        youXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
        [modelView addSubview:youXianLabel];
        
        if (i>0) {
            //上
            UILabel *shangXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, modelView.frame.size.width-SCREEN_WIDTH/3, 0.5)];
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
        UILabel *zuozhongXianLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, modelViewHeight/4, 1, modelViewHeight/2)];
        zuozhongXianLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.2];
        [modelView addSubview:zuozhongXianLabel];
        
        //左侧L八个abel显示
        NSArray *array = [NSArray arrayWithObjects:@"快递费",@"费用",@"给予赏金",@"物品名称",@"物品重量",@"所在位置",@"收件时间", @"付款方式",nil];
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 60, modelView.frame.size.height)];
        leftLabel.text = array[i];
//        leftLabel.adjustsFontSizeToFitWidth = YES;
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.textAlignment = NSTextAlignmentCenter;
        [modelView addSubview:leftLabel];
        AllImageView.userInteractionEnabled = YES;
        baiSeBeiJingView.userInteractionEnabled = YES;
        
        if (i == 0) {
            
            //¥金额
            UILabel *jinqianfuhaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(modelView.frame.size.width / 2 + 30, 0, 20, modelViewHeight)];
            jinqianfuhaoLabel.text =@"¥";
            jinqianfuhaoLabel.font = [UIFont systemFontOfSize:13];
            jinqianfuhaoLabel.textColor = [UIColor grayColor];
            [modelView addSubview:jinqianfuhaoLabel];
            
            //所需金额
            howMuchMoney = [[UITextField alloc]initWithFrame:CGRectMake(modelView.frame.size.width / 2 - 30, 0, 60, modelViewHeight)];
            howMuchMoney.placeholder = @"20000";
            howMuchMoney.font = [UIFont systemFontOfSize: 13];
            howMuchMoney.textAlignment = NSTextAlignmentCenter;
            howMuchMoney.delegate = self;
            [modelView addSubview:howMuchMoney];
            modelView.userInteractionEnabled = YES;
            howMuchMoney.userInteractionEnabled = YES;
            
        }
        
        if (i==1) {
        
            //服务跑腿费
            UILabel *fuWuPaoLuFei = [[UILabel alloc]initWithFrame:CGRectMake(75, 0, 80, modelViewHeight)];
            fuWuPaoLuFei.text =@"服务跑腿费";
            fuWuPaoLuFei.font = [UIFont systemFontOfSize:13];
            fuWuPaoLuFei.textColor = [UIColor grayColor];
            [modelView addSubview:fuWuPaoLuFei];
            
            //服务跑腿费
            NeedMoney = [[UITextField alloc]initWithFrame:CGRectMake(140, 0, (SCREEN_WIDTH -30)/4+40 , modelViewHeight)];
            //                NeedMoney.backgroundColor = [UIColor greenColor];
            NeedMoney.text = [NSString stringWithFormat:@"¥"];
            NeedMoney.textColor = [UIColor grayColor];
            NeedMoney.font = [UIFont systemFontOfSize:12];
            NeedMoney.userInteractionEnabled  =NO;
            NeedMoney.textAlignment = NSTextAlignmentLeft;
            NeedMoney.adjustsFontSizeToFitWidth = YES;
            [modelView addSubview:NeedMoney];
            
             //总共金额
            TotalMoney = [[UITextField alloc]initWithFrame:CGRectMake(modelView.frame.size.width-((SCREEN_WIDTH-30)/4 + 10), 0, (SCREEN_WIDTH -30)/4, modelViewHeight)];
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
        
         if (i==2) {
            
            modelView.userInteractionEnabled = YES;
            
            //5￥之前的按钮
            wuyuanButton = [[UIButton alloc]initWithFrame:CGRectMake(75, (modelViewHeight - modelViewHeight/4)/2, modelViewHeight/4, modelViewHeight/4)];
            wuyuanButton.layer.borderWidth=1;
            wuyuanButton.layer.cornerRadius =modelViewHeight/8;
            wuyuanButton.userInteractionEnabled = YES;
            [wuyuanButton addTarget:self action:@selector(wuyuan) forControlEvents:UIControlEventTouchUpInside];
            wuyuanButton.layer.borderColor = [[UIColor blueColor] CGColor];
            [modelView addSubview:wuyuanButton];
            
            //五元Label
            UILabel *wuyuanlabel = [[UILabel alloc]initWithFrame:CGRectMake(75 + modelViewHeight/4, (modelViewHeight  - 20)/2,currentWidth * 35, 20)];
            wuyuanlabel.text = @"5¥";
            wuyuanlabel.font = [UIFont systemFontOfSize:11];
//            wuyuanlabel.adjustsFontSizeToFitWidth  = YES;
            [modelView addSubview:wuyuanlabel];
            
            //10￥之前的按钮
            shiyuanButton = [[UIButton alloc]initWithFrame:CGRectMake(75 + modelViewHeight/4 + currentWidth * 35, (modelViewHeight -modelViewHeight/4)/2, modelViewHeight/4, modelViewHeight/4)];
            shiyuanButton.layer.borderWidth=1;
            [shiyuanButton addTarget:self action:@selector(shiyuan) forControlEvents:UIControlEventTouchUpInside];
            shiyuanButton.layer.cornerRadius = modelViewHeight/8;
            shiyuanButton.layer.borderColor = [[UIColor blueColor] CGColor];
            [modelView addSubview:shiyuanButton];
            
            //十元Label
            UILabel *shiyuanlabel = [[UILabel alloc]initWithFrame:CGRectMake(75 + modelViewHeight/4 *2 + currentWidth * 35 , (modelViewHeight  - 20)/2,currentWidth * 35, 20)];
            shiyuanlabel.text = @"10¥";
            shiyuanlabel.font = [UIFont systemFontOfSize:11];
//            shiyuanlabel.adjustsFontSizeToFitWidth  = YES;
            [modelView addSubview:shiyuanlabel];
            
            //0￥之前的按钮
            lingYuanButton = [[UIButton alloc]initWithFrame:CGRectMake(75 + modelViewHeight/4 *2 + currentWidth * 35 *2, (modelViewHeight -modelViewHeight/4)/2, modelViewHeight/4, modelViewHeight/4)];
            lingYuanButton.layer.borderWidth=1;
            lingYuanButton.layer.cornerRadius = modelViewHeight/8;
            [lingYuanButton addTarget:self action:@selector(shiwuyuan) forControlEvents:UIControlEventTouchUpInside];
            lingYuanButton.layer.borderColor = [[UIColor blueColor] CGColor];
            [modelView addSubview:lingYuanButton];
            
            //0元Label
            UILabel *lingYuanlabel = [[UILabel alloc]initWithFrame:CGRectMake(75 + modelViewHeight/4 *3 + currentWidth * 35 *2 , (modelViewHeight  - 20)/2,currentWidth * 35, 20)];
            lingYuanButton.backgroundColor = [UIColor blueColor];
            lingYuanlabel.text = @"0¥";
            lingYuanlabel.font = [UIFont systemFontOfSize:11];
//            lingYuanlabel.adjustsFontSizeToFitWidth  = YES;
            [modelView addSubview:lingYuanlabel];
            
            //其它金额button
            CGRect frame = CGRectMake(75 + modelViewHeight/4 *3 + currentWidth * 35 *3 - 5, (modelViewHeight  - 20)/2,  currentWidth *80, 20);
            BFPaperButton *qitajineButton = [[BFPaperButton alloc] initWithFrame:frame];
            qitajineButton.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
            [qitajineButton setTitle:@"其他金额" forState:UIControlStateNormal];
            qitajineButton.titleLabel.font = [UIFont systemFontOfSize:10];
            [qitajineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [qitajineButton addTarget:self action:@selector(qiTaJinEClick:) forControlEvents:UIControlEventTouchUpInside];
            [modelView addSubview:qitajineButton];
            
            //其它金额具体指
            qitajinejutizhilabel = [[UITextField alloc]initWithFrame:CGRectMake((75 + modelViewHeight/4 *3 + currentWidth * 35 *3 - 10) + currentWidth *80 , (modelViewHeight  - 20)/2,  (modelView.frame.size.width - qitajineButton.frame.origin.x - currentWidth *80 - 20 ), 20)];
            qitajinejutizhilabel.enabled = NO;
            qitajinejutizhilabel.delegate = self;
            qitajinejutizhilabel.placeholder = @"0";
            qitajinejutizhilabel.text = @"0";
            qitajinejutizhilabel.textAlignment = NSTextAlignmentCenter;
            qitajinejutizhilabel.font = [UIFont systemFontOfSize:12];
            qitajinejutizhilabel.adjustsFontSizeToFitWidth  = YES;
            [modelView addSubview:qitajinejutizhilabel];
            
            //其它金额符号Label
            UILabel *jinqianfuhaolabel = [[UILabel alloc]initWithFrame:CGRectMake(modelView.frame.size.width - 20, (modelViewHeight  - 20)/2,  (SCREEN_WIDTH-30)/4*3/5/5, 20)];
            jinqianfuhaolabel.text = @"¥";
            jinqianfuhaolabel.font = [UIFont systemFontOfSize:12];
            jinqianfuhaolabel.adjustsFontSizeToFitWidth  = YES;
            [modelView addSubview:jinqianfuhaolabel];
            
        }
 
        if (i==3) {
            
             nameText = [[UITextField alloc]initWithFrame:CGRectMake(75, 0, modelView.frame.size.width - 75, modelViewHeight)];
            nameText.placeholder = @"物品名称";
            nameText.font = [UIFont systemFontOfSize: 13];
            nameText.textAlignment = NSTextAlignmentCenter;
            [modelView addSubview:nameText];
            
            modelView.userInteractionEnabled = YES;
            nameText.userInteractionEnabled = YES;

            
        }
        
        if (i ==4) {
            
            weight = [[UITextField alloc]initWithFrame:CGRectMake(75, 0, modelView.frame.size.width - 75, modelViewHeight)];
            weight.placeholder = @"物品重量";
            weight.font = [UIFont systemFontOfSize: 13];
            weight.textAlignment = NSTextAlignmentCenter;
            weight.delegate = self;
            [modelView addSubview:weight];
            
            modelView.userInteractionEnabled = YES;
            weight.userInteractionEnabled = YES;

        }
        
        if (i==5) {
            
            //所在位置Label
            placeField = [[UILabel alloc]initWithFrame:CGRectMake((modelView.frame.size.width - 75 -  (SCREEN_WIDTH -140) ) / 2 +75, 0, (SCREEN_WIDTH -140), modelViewHeight)];
            //                placeField.backgroundColor = [UIColor redColor];
            placeField.text = [NSString stringWithFormat:@"所在位置"];
            placeField.textColor = [UIColor grayColor];
            placeField.numberOfLines = 0;
            //                placeField.font = [UIFont systemFontOfSize: 15];
            placeField.textAlignment = NSTextAlignmentCenter;
            placeField.adjustsFontSizeToFitWidth = YES;
            [modelView addSubview:placeField];
            modelView.userInteractionEnabled = YES;
            placeField.userInteractionEnabled = YES;

         }
        
        if (i == 6) {
            
            //“时”Label
            UILabel *shiLabel = [[UILabel alloc]initWithFrame:CGRectMake(75 , (modelViewHeight  - 20)/2,  (modelView.frame.size.width - 75)/4, 20)];
            shiLabel.text = @"时";
            shiLabel.font = [UIFont systemFontOfSize:15];
            shiLabel.adjustsFontSizeToFitWidth  = YES;
            [modelView addSubview:shiLabel];
            
            //所需小时TextField
            xiaoshiField= [[UITextField alloc]initWithFrame:CGRectMake(75 + (modelView.frame.size.width - 75)/4, (modelViewHeight  - 20)/2,  (modelView.frame.size.width - 75)/4, 20)];
            xiaoshiField.placeholder =  @"1";
            xiaoshiField.delegate = self;
            xiaoshiField.userInteractionEnabled = YES;
            [modelView addSubview:xiaoshiField];
            
            //“分”Label
            UILabel *fenLabel = [[UILabel alloc]initWithFrame:CGRectMake(75 + (modelView.frame.size.width - 75)/4*2 , (modelViewHeight  - 20)/2,  (modelView.frame.size.width - 75)/4, 20)];
            fenLabel.text = @"分";
            fenLabel.font = [UIFont systemFontOfSize:15];
            fenLabel.adjustsFontSizeToFitWidth  = YES;
            [modelView addSubview:fenLabel];
            
            //所需分钟TextField
            fenzhongField= [[UITextField alloc]initWithFrame:CGRectMake(75 + (modelView.frame.size.width - 75)/4*3, (modelViewHeight  - 20)/2,  (modelView.frame.size.width - 75)/4, 20)];
            fenzhongField.placeholder =  @"0";
            fenzhongField.delegate = self;
            fenzhongField.userInteractionEnabled = YES;
            [modelView addSubview:fenzhongField];

            modelView.userInteractionEnabled = YES;
            fenzhongField.userInteractionEnabled = YES;
            xiaoshiField.userInteractionEnabled = YES;


        }
        
        if (i == 7) {
            
            payType = [[UITextField alloc]initWithFrame:CGRectMake(75, 0, modelView.frame.size.width - 75, modelViewHeight)];
            payType.placeholder = @"付款方式";
            payType.font = [UIFont systemFontOfSize: 13];
            payType.textAlignment = NSTextAlignmentCenter;
            [modelView addSubview:payType];
            
            modelView.userInteractionEnabled = YES;
            payType.userInteractionEnabled = YES;

        }
 
    }
    

    
    CGRect frame = CGRectMake(15, SCREEN_HEIGHT - modelViewHeight-20, SCREEN_WIDTH -30, modelViewHeight);
    BFPaperButton *fabuButton = [[BFPaperButton alloc] initWithFrame:frame];
    [fabuButton setTitle:@"Rounded" forState:UIControlStateNormal];
    fabuButton.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [fabuButton setTitle:@"发布" forState:UIControlStateNormal];
    fabuButton.layer.cornerRadius = modelViewHeight/2;
    fabuButton.cornerRadius = modelViewHeight/2;
    fabuButton.liftedShadowOffset = CGSizeMake(0, 5);
    fabuButton.loweredShadowOffset= CGSizeMake(0, 1.5);
    [fabuButton addTarget:self action:@selector(fabu) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:fabuButton];

    [self initLeftView];              //左边的View

}

-(void)initLeftView{
    
    //设置白色背景的尺寸
    baiSeBeiJingView.frame = CGRectMake(0, topImageView.frame.origin.y + topImageView.frame.size.height, SCREEN_WIDTH, modelView.frame.origin.y + modelViewHeight + 10) ;

    //快递功能
    UILabel *showLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,(modelView.frame.origin.y + modelViewHeight + 10 - 120)/2 , SCREEN_WIDTH/4, 120)];
    showLeftLabel.text = @"快\n递\n功\n能";
    showLeftLabel.font = [UIFont systemFontOfSize:24];
    showLeftLabel.numberOfLines = 0;
    showLeftLabel.textAlignment = NSTextAlignmentCenter;
    showLeftLabel.backgroundColor = [UIColor clearColor];
    [baiSeBeiJingView addSubview:showLeftLabel];
    
    UILabel *xiaoLeftLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/8 + 20,0 , 20, 120)];
    xiaoLeftLabel.text = @"\n\n\n无\n需\n要\n可\n不\n填\n";
    xiaoLeftLabel.font = [UIFont systemFontOfSize:10];
    xiaoLeftLabel.textColor = [UIColor lightGrayColor];
    xiaoLeftLabel.numberOfLines = 0;
    xiaoLeftLabel.textAlignment = NSTextAlignmentCenter;
    [showLeftLabel addSubview:xiaoLeftLabel];

}

//初始化定位
- (void)initializeLocationService {
    // 初始化定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    _locationManager.delegate = self;
    // 设置定位精确度到米
    _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 开始定位
    [_locationManager startUpdatingLocation];
}

#pragma mark - Button Click Action
//返回
-(void)BackView
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

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
//发布订单
-(void)fabu{
    
    //判断所需金额的大小
    NSString *str = howMuchMoney.text;
    int _int1 = [str intValue];
    int _int2 = 20000;
    if ( _int1 > _int2) {
    UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:@"快递费不可大于20000！"
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
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"请先登录后发布"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
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
             NSTimeInterval timeStamp= [date timeIntervalSince1970];
             int needTimeSecond = [xiaoshiField.text intValue]*3600 + [fenzhongField.text intValue]*60  + timeStamp + 8*60*60;
            
            
            NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
            
            NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
            
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            session.requestSerializer = [AFJSONRequestSerializer serializer];
            session.responseSerializer = [AFJSONResponseSerializer serializer];
            [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
 
            NSLog(@"%@",NeedMoney.text);
//            NSString *extra = [NSString stringWithFormat:@"%@\n%@\n%@",nameText.text,weight.text,payType.text];
            
            NSDictionary *extra = @{
                                           @"name":nameText.text,
                                           @"payType":payType.text,
                                           @"weight":weight.text
                                           };
            NSError *error = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:extra options:NSJSONWritingPrettyPrinted error:&error];

            NSDictionary *parameters = @{@"money":howMuchMoney.text,
                                         @"dealt_at":placeField.text,
                                         @"sent_at":placeField.text,
                                         @"tip":qitajinejutizhilabel.text,
                                         @"service_item_id":@"9",
                                         @"time_limit":[NSString stringWithFormat:@"%d",needTimeSecond],
                                         @"status":@"101",
                                         @"service_charge":NeedMoney.text,
                                         @"sent_by":user_id,
                                         @"extra_fields":jsonData};

            NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/orders"];
            
            [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                //            NSLog(@"formData%@",formData);
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                //            NSLog(@"uploadProgress%@",uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"%@",responseObject);
                [UIView animateKeyframesWithDuration:5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                } completion:nil];
                
//                            NSLog(@"responseObject%@",responseObject);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"发布成功"delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                
                [alert show];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                            NSLog(@"error%@",error);
            }];
            
        }
        
    }
    
}

//选择5元10元15元
-(void)wuyuan
{
    wuyuanButton.backgroundColor = [UIColor blueColor];
    shiyuanButton.backgroundColor = [UIColor clearColor];
    lingYuanButton.backgroundColor = [UIColor clearColor];
    qitajinejutizhilabel.text = @"5";
}
-(void)shiyuan
{
    shiyuanButton.backgroundColor = [UIColor blueColor];
    wuyuanButton.backgroundColor = [UIColor clearColor];
    lingYuanButton.backgroundColor = [UIColor clearColor];
    qitajinejutizhilabel.text = @"10";}
-(void)shiwuyuan
{
    lingYuanButton.backgroundColor = [UIColor blueColor];
    shiyuanButton.backgroundColor = [UIColor clearColor];
    wuyuanButton.backgroundColor = [UIColor clearColor];
    qitajinejutizhilabel.text = @"0";
}

//美元汇算结果
-(void)meiYuanHuilve{
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.k780.com:88/?app=finance.rate&scur=USD&tcur=CNY&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"result"];
    NSString *rate = [weatherInfo objectForKey:@"rate"];
    float float11 = [rate floatValue];
    float float1 = [howMuchMoney.text floatValue];
    float value = float1 / float11;
    int resultInt = (int)ceilf(value);
    waiHuiJinE.text = [NSString stringWithFormat:@"%d",resultInt];
}


//欧元汇算结果
-(void)ouYuanHuilve{
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.k780.com:88/?app=finance.rate&scur=EUR&tcur=CNY&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"result"];
    NSString *rate = [weatherInfo objectForKey:@"rate"];
    float float11 = [rate floatValue];
    float float1 = [howMuchMoney.text floatValue];
    float value = float1 / float11;
    int resultInt = (int)ceilf(value);
    waiHuiJinE.text = [NSString stringWithFormat:@"%d",resultInt];
}


//英镑汇算结果
-(void)yingBangHuilve{
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.k780.com:88/?app=finance.rate&scur=USD&tcur=CNY&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"result"];
    NSString *rate = [weatherInfo objectForKey:@"rate"];
    float float11 = [rate floatValue];
    float float1 = [howMuchMoney.text floatValue];
    float value = float1 / float11;
    int resultInt = (int)ceilf(value);
    waiHuiJinE.text = [NSString stringWithFormat:@"%d",resultInt];
}


//日元汇算结果
-(void)riYuanHuilve{
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.k780.com:88/?app=finance.rate&scur=JPY&tcur=CNY&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"result"];
    NSString *rate = [weatherInfo objectForKey:@"rate"];
    float float11 = [rate floatValue];
    float float1 = [howMuchMoney.text floatValue];
    float value = float1 / float11;
    int resultInt = (int)ceilf(value);
    waiHuiJinE.text = [NSString stringWithFormat:@"%d",resultInt];
}


//港币汇算结果
-(void)gangBiHuilve{
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.k780.com:88/?app=finance.rate&scur=HKD&tcur=CNY&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"result"];
    NSString *rate = [weatherInfo objectForKey:@"rate"];
    float float11 = [rate floatValue];
    float float1 = [howMuchMoney.text floatValue];
    float value = float1 / float11;
    int resultInt = (int)ceilf(value);
    waiHuiJinE.text = [NSString stringWithFormat:@"%d",resultInt];
}


//澳大利亚元汇算结果
-(void)aoDaLiYaYuanHuilve{
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.k780.com:88/?app=finance.rate&scur=AUD&tcur=CNY&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"result"];
    NSString *rate = [weatherInfo objectForKey:@"rate"];
    float float11 = [rate floatValue];
    float float1 = [howMuchMoney.text floatValue];
    float value = float1 / float11;
    int resultInt = (int)ceilf(value);
    waiHuiJinE.text = [NSString stringWithFormat:@"%d",resultInt];
}


//瑞士法郎汇算结果
-(void)ruiShiFaLangHuilve{
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request1 = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.k780.com:88/?app=finance.rate&scur=CHF&tcur=CNY&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request1 returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *weatherInfo = [weatherDic objectForKey:@"result"];
    NSString *rate = [weatherInfo objectForKey:@"rate"];
    float float11 = [rate floatValue];
    float float1 = [howMuchMoney.text floatValue];
    float value = float1 / float11;
    int resultInt = (int)ceilf(value);
    waiHuiJinE.text = [NSString stringWithFormat:@"%d",resultInt];
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

//点击背景键盘回收
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - CLLocationManager 代理
//地理位置更新，显示地理位置
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSString *string1,*string2,*string3,*string4;
            if (placemark.locality == nil)
            {
                string1  = @"";
            }
            else
            {
                string1 = [NSString stringWithFormat:@"%@",placemark.locality];
            }
            if (placemark.subLocality == nil)
            {
                string2  = @"";
            }
            else
            {
                string2 = [NSString stringWithFormat:@"%@",placemark.subLocality];
            }
            if (placemark.thoroughfare == nil)
            {
                string3  = @"";
            }
            else
            {
                string3 = [NSString stringWithFormat:@"%@",placemark.thoroughfare];
            }
            if (placemark.subThoroughfare == nil)
            {
                string4  = @"";
            }
            else
            {
                string4 = [NSString stringWithFormat:@"%@",placemark.subThoroughfare];
            }
            
            placeField.text = [NSString stringWithFormat:@"%@%@%@%@",string1,string2,string3,string4];
        }
    }];
}


#pragma mark - textFieldtextField 代理
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
            
            NeedMoney.text = [NSString stringWithFormat:@"  ¥"];
            TotalMoney.text =[NSString stringWithFormat:@" 合计 ¥"];
            
        }
        else
        {
            float needMoney ;
            
            needMoney = 2 + [howMuchMoney.text floatValue]*0.005;
            
            
            NeedMoney.text = [NSString stringWithFormat:@"%.2f",needMoney];
            TotalMoney.text = [NSString stringWithFormat:@"合计%.2f",needMoney + [howMuchMoney.text intValue]];
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == qitajinejutizhilabel) {
        wuyuanButton.backgroundColor = [UIColor clearColor];
        shiyuanButton.backgroundColor = [UIColor clearColor];
        lingYuanButton.backgroundColor = [UIColor clearColor];
    }
    if (textField ==xiaoshiField||textField == fenzhongField) {
        self.view.frame = CGRectMake(0, 0-150, SCREEN_WIDTH, SCREEN_HEIGHT) ;
    }
    
    
}

//点击Return键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 回收键盘,取消第一响应者
    [textField resignFirstResponder]; return YES;
}


#pragma mark - alertView 代理
//alert的按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    //NSLog(@"alert1 button index=%ld is clicked.....", (long)buttonIndex);
    if(buttonIndex == 0){
        //        NSLog(@"0");
        //        [self dismissViewControllerAnimated:NO completion:nil];
        //        NSLog(@"-----------其他金额==========%@",qiTaJinEValue.text);
        qitajinejutizhilabel.text = qiTaJinEValue.text;
    }
    else
    {
        //        NSLog(@"😳");
    }
    
}


@end

