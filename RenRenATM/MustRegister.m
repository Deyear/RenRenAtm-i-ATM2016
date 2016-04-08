//
//  MustRegister.m
//  RenRenATM
//
//
//
//注册界面

#import "MustRegister.h"
#import "AFNetworking.h"
#import "agreeView.h"
#import "MustLogin.h"

@interface MustRegister ()<UIScrollViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UIButton *buttonOne,*buttonTwo,*bageButton,*zhuceRightButton;
    UIScrollView *SelfScrollerView;
    int zhucefangshi ;
    
    NSTimer *countDownTimer;
    int secondsCountDown;
    NSString *codeStr;
    UIButton *checkRightButton,*getiButton,*dianpuButton;
    UITextField * phoneRightField;
    UILabel *bageLabel;
    
    UITextField * nameRightField,*codeRightField,*codeLeftField,*mimaRightField;
    UIAlertView *zhucechenggongAlert;
    //判断个体活着店铺
    NSString *getiOrdianpu;
    //八个功能选择
    NSString *ONE,*TWO,*THREE,*FOUR,*FIVE,*SIX,*SEVEN,*EIGHT;
    //左边的注册帐号密码
    UITextField *nameleftField,*phoneLeftField,*mimaleftField;
    
    UIView *uiRightView;
}

@property (strong, nonatomic) IBOutlet UIView *topView;

@end

@implementation MustRegister

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    
    zhucefangshi= 1;
    getiOrdianpu =@"个体服务者";
    self.title = @"注册";
    ONE=@"1";
    TWO=@"2";
    THREE =@"3";
    FOUR = @"4";
    FIVE =@"5";
    SIX = @"6";
    SEVEN =@"7";
    EIGHT = @"8";
    secondsCountDown = 60;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"RenRenTabbar"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-Small"] style:UIBarButtonItemStylePlain target:self action:@selector(BackView)];
    //添加下面的两个界面
    [self LeftView];
    [self RightView];
    uiRightView.hidden = YES;
    
    //添加两个个按钮
    NSArray *FourArray = @[@"服务者入口",@"个人用户入口"];
    for (int i = 0; i<2; i++) {
        switch (i) {
            case 0:
                //按钮One
                buttonOne = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6, 84, (SCREEN_WIDTH/3)-5, 25)];
                [buttonOne setTitle:FourArray[i] forState:UIControlStateNormal];
                buttonOne.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
                [buttonOne setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                buttonOne.titleLabel.font = [UIFont systemFontOfSize:14];
                buttonOne.layer.borderWidth = 1;
                buttonOne.layer.cornerRadius = 12;
                buttonOne.layer.masksToBounds = YES;
                buttonOne.layer.borderColor = [[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] CGColor];
                [buttonOne addTarget:self action:@selector(buttonOneSelect) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:buttonOne];
                break;
            case 1:
                //按钮Two
                buttonTwo = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+5, 84 , SCREEN_WIDTH/3-5, 25)];
                [buttonTwo setTitle:FourArray[i] forState:UIControlStateNormal];
                buttonTwo.backgroundColor = [UIColor whiteColor];
                [buttonTwo setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1]  forState:UIControlStateNormal];
                buttonTwo.titleLabel.font = [UIFont systemFontOfSize:14];
                buttonTwo.layer.borderColor = [[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1]CGColor];
                buttonTwo.layer.cornerRadius = 12;
                buttonTwo.layer.masksToBounds = YES;
                buttonTwo.layer.borderWidth = 1;
                [buttonTwo addTarget:self action:@selector(buttonTwoSelect) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:buttonTwo];
                break;
                
                
            default:
                break;
        }
    }

}

//两个个界面的构造事件左边服务者UIScrollView
-(void)LeftView
{
    //整个上下滚动view
    SelfScrollerView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    //设置容量
    
    SelfScrollerView.userInteractionEnabled = YES;
    //    SelfScrollerView.pagingEnabled = YES;
    SelfScrollerView.bounces = NO;
    SelfScrollerView.showsHorizontalScrollIndicator=NO;
    SelfScrollerView.delegate = self;
    [self.view addSubview:SelfScrollerView];
    
    
    
    //手机号
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(30, buttonTwo.frame.origin.y + 50,60 , 20)];
    namelabel.text = @"手机号";
    [SelfScrollerView addSubview:namelabel];
    namelabel.textAlignment = NSTextAlignmentLeft;
    //手机号左边的
    nameleftField = [[UITextField alloc]initWithFrame:CGRectMake(100, buttonTwo.frame.origin.y + 50,SCREEN_WIDTH - 160 , 20)];
    nameleftField.delegate= self;
    nameleftField.placeholder = @"请输入您的手机号";
    [SelfScrollerView addSubview:nameleftField];
    UILabel * namexianlabel = [[UILabel alloc]initWithFrame:CGRectMake(32, buttonTwo.frame.origin.y + 80,SCREEN_WIDTH - 64 , 1)];
    namexianlabel.backgroundColor =[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [SelfScrollerView addSubview:namexianlabel];
    
    
    
    //密码
    UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(30, namelabel.frame.origin.y + 50,60 , 20)];
    phonelabel.text = @"密码";
    [SelfScrollerView addSubview:phonelabel];
    phonelabel.textAlignment = NSTextAlignmentLeft;
    //左边的密码
    phoneLeftField = [[UITextField alloc]initWithFrame:CGRectMake(100, namelabel.frame.origin.y + 50,SCREEN_WIDTH - 160 , 20)];
    [phoneLeftField setSecureTextEntry:YES];
    phoneLeftField.placeholder = @"请输入密码";
    phoneLeftField.delegate =self;
    [SelfScrollerView addSubview:phoneLeftField];
    UILabel * phonexianlabel = [[UILabel alloc]initWithFrame:CGRectMake(32, namelabel.frame.origin.y + 80,SCREEN_WIDTH - 64 , 1)];
    phonexianlabel.backgroundColor =[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [SelfScrollerView addSubview:phonexianlabel];
    
    //确认密码
    UILabel *mimalabel = [[UILabel alloc]initWithFrame:CGRectMake(30, phonelabel.frame.origin.y + 50,60 , 20)];
    mimalabel.text = @"密码";
    [SelfScrollerView addSubview:mimalabel];
    mimalabel.textAlignment = NSTextAlignmentLeft;
    //左边的确认密码
    mimaleftField = [[UITextField alloc]initWithFrame:CGRectMake(100, phonelabel.frame.origin.y + 50,SCREEN_WIDTH - 160 , 20)];
    [mimaleftField setSecureTextEntry:YES];
    mimaleftField.placeholder = @"请确认您的密码";
    mimaleftField.delegate = self;
    [SelfScrollerView addSubview:mimaleftField];
    UILabel * mimaxianlabel = [[UILabel alloc]initWithFrame:CGRectMake(32, phonelabel.frame.origin.y + 80,SCREEN_WIDTH - 64 , 1)];
    mimaxianlabel.backgroundColor =[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [SelfScrollerView addSubview:mimaxianlabel];
    
    //验证码
    codeLeftField = [[UITextField alloc]initWithFrame:CGRectMake(30, mimaleftField.frame.origin.y + 50,100 , 20)];
    codeLeftField.placeholder = @"请输入验证码";
    codeLeftField.adjustsFontSizeToFitWidth = YES;
    codeLeftField.textAlignment = NSTextAlignmentLeft;
    [SelfScrollerView addSubview:codeLeftField];
    checkRightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-130, mimaleftField.frame.origin.y + 50, 100, 20)];
    [checkRightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [checkRightButton setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [checkRightButton addTarget:self action:@selector(getCheckLeftCode) forControlEvents:UIControlEventTouchUpInside];
    [SelfScrollerView addSubview:checkRightButton];
    UILabel * codexianlabel = [[UILabel alloc]initWithFrame:CGRectMake(32, mimaleftField.frame.origin.y + 80,SCREEN_WIDTH - 64 , 1)];
    codexianlabel.backgroundColor =[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [SelfScrollerView addSubview:codexianlabel];
    
    //服务者类型
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, codeLeftField.frame.origin.y + 40,100 , 20)];
    typeLabel.text = @"服务者类型";
    [SelfScrollerView addSubview:typeLabel];
    
    //创建服务类型
    UILabel *getilabel = [[UILabel alloc]initWithFrame:CGRectMake(50, typeLabel.frame.origin.y + 30, 50, 20)];
    getilabel.text = @"个体";
    getilabel.textAlignment = NSTextAlignmentLeft;
    getilabel.textColor = [UIColor grayColor];
    [SelfScrollerView addSubview:getilabel];
    //个体 店铺
    UILabel *dianpuLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+ 30, typeLabel.frame.origin.y + 30, 50, 20)];
    dianpuLabel.text = @"店铺";
    dianpuLabel.textAlignment = NSTextAlignmentLeft;
    dianpuLabel.textColor = [UIColor grayColor];
    [SelfScrollerView addSubview:dianpuLabel];
    
    //个体和店铺选中button
    getiButton = [[UIButton alloc]initWithFrame:CGRectMake(30, typeLabel.frame.origin.y + 30, 20, 20)];
    [getiButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
    [getiButton addTarget:self
                   action:@selector(xuanzegeti) forControlEvents:UIControlEventTouchUpInside];
    [SelfScrollerView addSubview:getiButton];
    dianpuButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, typeLabel.frame.origin.y + 30, 20, 20)];
    [dianpuButton addTarget:self action:@selector(xuanzedianpu) forControlEvents:UIControlEventTouchUpInside];
    [dianpuButton setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
    [SelfScrollerView addSubview:dianpuButton];
    //选择服务项目
    UILabel *fuwuxiangmuLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, getilabel.frame.origin.y + 30,150 , 20)];
    fuwuxiangmuLabel.text = @"选择服务项目";
    [SelfScrollerView addSubview:fuwuxiangmuLabel];
    
    //八个字  循环做
    NSArray *array = [NSArray arrayWithObjects:@"信用卡取现",@"银行卡取现",@"代收款业务",@"我要换外汇",@"我要存钱",@"我要转账",@"我要换整钱",@"我要换零钱", nil];
    for (int i = 0 ; i<array.count; i++) {
        bageLabel = [[UILabel alloc]initWithFrame:CGRectMake(50 + (i%2)*(SCREEN_WIDTH/2-20), fuwuxiangmuLabel.frame.origin.y + 30 +(i/2)*30, SCREEN_WIDTH/2-80, 20)];
        bageLabel.text = array[i];
        bageLabel.textAlignment = NSTextAlignmentLeft;
        bageLabel.adjustsFontSizeToFitWidth = YES;
        bageLabel.textColor = [UIColor grayColor];
        [SelfScrollerView addSubview:bageLabel];
        
        bageButton = [[UIButton alloc]initWithFrame:CGRectMake(30 + (i%2)*(SCREEN_WIDTH/2-30), fuwuxiangmuLabel.frame.origin.y + 30 +(i/2)*30, 20, 20)];
        [bageButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        [SelfScrollerView addSubview:bageButton];
        UITapGestureRecognizer *bageButtontap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bageTap:)];
        bageButton.userInteractionEnabled = YES;
        [bageButton addGestureRecognizer:bageButtontap];
        
        UIView *singleTapView = [bageButtontap view];
        singleTapView.tag = i+100;
    }
    //服务时间段
    UILabel *shijianLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, bageLabel.frame.origin.y + 40, 80, 20)];
    shijianLabel.text = @"服务时间段";
    shijianLabel.textAlignment = NSTextAlignmentLeft;
    shijianLabel.adjustsFontSizeToFitWidth = YES;
    [SelfScrollerView addSubview:shijianLabel];
    //服务时间段
    UITextField *shijianField = [[UITextField alloc]initWithFrame:CGRectMake(120, bageLabel.frame.origin.y + 40, SCREEN_WIDTH - 150, 20)];
    shijianField.text = @"09:00 -- 23:00";
    shijianField.userInteractionEnabled = NO;
    shijianField.textAlignment = NSTextAlignmentLeft;
    shijianField.adjustsFontSizeToFitWidth = YES;
    [SelfScrollerView addSubview:shijianField];
    
    //地理位置
    UILabel *diliweizhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, shijianLabel.frame.origin.y + 40, 80, 20)];
    diliweizhiLabel.text = @"地理位置";
    diliweizhiLabel.textAlignment = NSTextAlignmentLeft;
    diliweizhiLabel.adjustsFontSizeToFitWidth = YES;
    [SelfScrollerView addSubview:diliweizhiLabel];
    
    UILabel * shijianxianlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, shijianLabel.frame.origin.y + 25,SCREEN_WIDTH - 60 , 1)];
    shijianxianlabel.backgroundColor =[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [SelfScrollerView addSubview:shijianxianlabel];
    
    UILabel * diliweizhixianlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, diliweizhiLabel.frame.origin.y + 25,SCREEN_WIDTH - 60 , 1)];
    diliweizhixianlabel.backgroundColor =[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [SelfScrollerView addSubview:diliweizhixianlabel];
    
    //查看协议按钮
    UIButton *agreeButton = [[UIButton alloc]initWithFrame:CGRectMake(70, diliweizhixianlabel.frame.origin.y + 35, SCREEN_WIDTH -100, 44)];
    [agreeButton setTitle:@"我接受《人人ATM－软件及服务》" forState:UIControlStateNormal];
    [agreeButton addTarget:self action:@selector(agreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [agreeButton setBackgroundColor:[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:0]];
    [agreeButton setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [SelfScrollerView addSubview:agreeButton];
    
    //同意按钮
    UIButton *doAgreen = [[UIButton alloc]initWithFrame:CGRectMake(50, diliweizhixianlabel.frame.origin.y + 47, 20, 20)];
    [doAgreen addTarget:self action:@selector(doAgreen:) forControlEvents:UIControlEventTouchUpInside];
    [doAgreen setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
    [doAgreen setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:0]];
    [SelfScrollerView addSubview:doAgreen];
    
    //注册
    zhuceRightButton = [[UIButton alloc]initWithFrame:CGRectMake(25, diliweizhixianlabel.frame.origin.y + 80, SCREEN_WIDTH -50, 44)];
    [zhuceRightButton setTitle:@"注册" forState:UIControlStateNormal];
    zhuceRightButton.layer.masksToBounds = YES;
    zhuceRightButton.layer.cornerRadius = 22;
    [zhuceRightButton setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:0.5]];
    zhuceRightButton.enabled = NO;
    [zhuceRightButton addTarget:self action:@selector(zhuceRight) forControlEvents:UIControlEventTouchUpInside];
    [SelfScrollerView addSubview:zhuceRightButton];
    
#pragma marks SelfScrollerView的滚动高度
    [SelfScrollerView setBounces:NO];
    SelfScrollerView.contentSize = CGSizeMake(SCREEN_WIDTH, zhuceRightButton.frame.origin.y + 64 );
    
}


//查看协议
-(void)agreenAction:(UIButton *)sender
{
    agreeView *vc = [[agreeView alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}


//接受协议
-(void)doAgreen:(UIButton *)sender
{
    [zhuceRightButton setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1]];
    zhuceRightButton.enabled = YES;
    [sender setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
}


//两个个界面的构造事件右边个人拥护注册View
-(void)RightView
{
    //整个上下滚动view
    uiRightView =[[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    //设置容量
    //    SelfScrollerView.contentSize = CGSizeMake(4*SCREEN_WIDTH, 0);
    uiRightView.userInteractionEnabled = YES;
    [self.view addSubview:uiRightView];
    
    
    //手机号
    UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(30, buttonTwo.frame.origin.y + 60,60 , 20)];
    namelabel.text = @"手机号";
    [uiRightView addSubview:namelabel];
    namelabel.textAlignment = NSTextAlignmentLeft;
    
    nameRightField = [[UITextField alloc]initWithFrame:CGRectMake(100, buttonTwo.frame.origin.y + 60,SCREEN_WIDTH - 160 , 20)];
    nameRightField.placeholder = @"请输入您的手机号";
    nameRightField.delegate = self;
    [uiRightView addSubview:nameRightField];
    UILabel * namexianlabel = [[UILabel alloc]initWithFrame:CGRectMake(32, buttonTwo.frame.origin.y + 90,SCREEN_WIDTH - 64 , 1)];
    namexianlabel.backgroundColor =[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [uiRightView addSubview:namexianlabel];
    
    
    
    //密码
    UILabel *phonelabel = [[UILabel alloc]initWithFrame:CGRectMake(30, namelabel.frame.origin.y + 60,60 , 20)];
    phonelabel.text = @"密码";
    [uiRightView addSubview:phonelabel];
    phonelabel.textAlignment = NSTextAlignmentLeft;
    phoneRightField = [[UITextField alloc]initWithFrame:CGRectMake(100, namelabel.frame.origin.y + 60,SCREEN_WIDTH - 160 , 20)];
    [phoneRightField setSecureTextEntry:YES];
    phoneRightField.placeholder = @"请输入您的密码";
    phoneRightField.delegate = self;
    [uiRightView addSubview:phoneRightField];
    UILabel * phonexianlabel = [[UILabel alloc]initWithFrame:CGRectMake(32, namelabel.frame.origin.y + 90,SCREEN_WIDTH - 64 , 1)];
    phonexianlabel.backgroundColor =[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [uiRightView addSubview:phonexianlabel];
    
    
    //确认密码
    UILabel *mimalabel = [[UILabel alloc]initWithFrame:CGRectMake(30, phonelabel.frame.origin.y + 60,60 , 20)];
    mimalabel.text = @"密码";
    [uiRightView addSubview:mimalabel];
    mimalabel.textAlignment = NSTextAlignmentLeft;
    mimaRightField = [[UITextField alloc]initWithFrame:CGRectMake(100, phonelabel.frame.origin.y + 60,SCREEN_WIDTH - 160 , 20)];
    [mimaRightField setSecureTextEntry:YES];
    mimaRightField.placeholder = @"请确认您的密码密码";
    mimaRightField.delegate = self;
    [uiRightView addSubview:mimaRightField];
    UILabel * mimaxianlabel = [[UILabel alloc]initWithFrame:CGRectMake(32, phonelabel.frame.origin.y + 90,SCREEN_WIDTH - 64 , 1)];
    mimaxianlabel.backgroundColor =[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [uiRightView addSubview:mimaxianlabel];
    
    //输入验证码
    codeRightField = [[UITextField alloc]initWithFrame:CGRectMake(30, mimaRightField.frame.origin.y + 60,100 , 20)];
    codeRightField.placeholder = @"请输入验证码";
    codeRightField.delegate =self;
    codeRightField.adjustsFontSizeToFitWidth = YES;
    codeRightField.textAlignment = NSTextAlignmentLeft;
    [uiRightView addSubview:codeRightField];
    
    //获取验证码
    checkRightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-130, mimaRightField.frame.origin.y + 60, 100, 20)];
    [checkRightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [checkRightButton setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [checkRightButton addTarget:self action:@selector(getCheckCode) forControlEvents:UIControlEventTouchUpInside];
    [uiRightView addSubview:checkRightButton];
    UILabel * codexianlabel = [[UILabel alloc]initWithFrame:CGRectMake(32, mimaRightField.frame.origin.y + 90,SCREEN_WIDTH - 64 , 1)];
    codexianlabel.backgroundColor =[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [uiRightView addSubview:codexianlabel];
    
    //查看协议按钮
    UIButton *agreeButton1 = [[UIButton alloc]initWithFrame:CGRectMake(70, mimaxianlabel.frame.origin.y + 100, SCREEN_WIDTH -100, 44)];
    [agreeButton1 setTitle:@"我接受《人人ATM－软件及服务》" forState:UIControlStateNormal];
    [agreeButton1 addTarget:self action:@selector(agreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [agreeButton1 setBackgroundColor:[UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:0]];
    [agreeButton1 setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [uiRightView addSubview:agreeButton1];
    
    //同意按钮
    UIButton *doAgreen1 = [[UIButton alloc]initWithFrame:CGRectMake(50, mimaxianlabel.frame.origin.y + 112, 20, 20)];
    [doAgreen1 addTarget:self action:@selector(doAgreen:) forControlEvents:UIControlEventTouchUpInside];
    [doAgreen1 setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
    [doAgreen1 setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:0]];
    [uiRightView addSubview:doAgreen1];
    
    //注册
    zhuceRightButton = [[UIButton alloc]initWithFrame:CGRectMake(25, mimaxianlabel.frame.origin.y + 160, SCREEN_WIDTH - 50, 44)];
    [zhuceRightButton setTitle:@"注册" forState:UIControlStateNormal];
    zhuceRightButton.layer.masksToBounds = YES;
    zhuceRightButton.layer.cornerRadius = 22;
    [zhuceRightButton setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:0.5]];
    zhuceRightButton.enabled = NO;
    [zhuceRightButton addTarget:self action:@selector(zhuceRight) forControlEvents:UIControlEventTouchUpInside];
    [uiRightView addSubview:zhuceRightButton];
    
}


//获取验证码
- (void)getCheckCode {
    if (nameRightField.text.length !=11) {
        UIAlertView *notiAlert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码输入有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [notiAlert show];
    }
    else
    {
        NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/captcha/send?number=%@",nameRightField.text];
        UIAlertView *notiAlert = [[UIAlertView alloc]initWithTitle:nil message:@"发送验证码成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [notiAlert show];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"%@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"%@",error);
        }];
        
        checkRightButton.userInteractionEnabled=NO;
        checkRightButton.alpha=0.4;
        
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    }
}
- (void)getCheckLeftCode {
    if (nameleftField.text.length !=11) {
        UIAlertView *notiAlert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号码输入有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [notiAlert show];
        
    }
    else
    {
        NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/captcha/send?number=%@",nameleftField.text];
        UIAlertView *notiAlert = [[UIAlertView alloc]initWithTitle:nil message:@"发送验证码成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [notiAlert show];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"%@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"%@",error);
        }];
        
        checkRightButton.userInteractionEnabled=NO;
        checkRightButton.alpha=0.4;
        
        countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        
        
    }
}

#pragma mark 导航条返回事件
-(void)BackView
{
    
    [self.navigationController popViewControllerAnimated:NO];
}
//注册
-(void)zhuceRight
{
    if (zhucefangshi == 1) {
//        NSLog(@"1");
        if (nameleftField.text.length != 11) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if([phoneLeftField.text isEqualToString:@""])
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if([phoneLeftField.text isEqualToString:mimaleftField.text] ==false)
        {
            
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"请确认两次密码一样" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        else   if (codeLeftField.text.length != 4) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"请正确输入验证码" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/users"];
            NSString *service_item_ids;
            NSArray *eightArray = [NSArray arrayWithObjects:ONE,TWO,THREE,FOUR,FIVE,SIX,SEVEN,EIGHT, nil];
            for (int i = 0; i<eightArray.count; i++) {
                if ([eightArray[i] isEqualToString:@""]) {
                    
                }
                else
                {
                    if (service_item_ids == nil) {
                        service_item_ids = eightArray[i];
                    }
                    else
                    {
                        service_item_ids = [NSString stringWithFormat:@"%@,%@",service_item_ids,eightArray[i]];
                    }
                }
            }
            //            NSString *service_item_ids = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",ONE,TWO,THREE,FOUR,FIVE,SIX,SEVEN,EIGHT];
            NSDictionary *parameters = @{@"username":nameleftField.text,@"password":phoneLeftField.text,@"password_repeat":mimaleftField.text,@"role":getiOrdianpu,@"service_item_ids":service_item_ids,@"captcha":codeLeftField.text};
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//                NSLog(@"formData%@",formData);
            } progress:^(NSProgress * _Nonnull uploadProgress) {
//                NSLog(@"uploadProgress%@",uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"responseObject%@",responseObject);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"注册成功"delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                zhucechenggongAlert = alert;
                [alert show];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"error%@",error);
            }];
        }
        
    }
    else if (zhucefangshi == 2)
    {
        //        NSLog(@"2");
        if (nameRightField.text.length != 11) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"请正确输入手机号" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if([phoneRightField.text isEqualToString:@""])
        {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"密码不能为空" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        else if([phoneRightField.text isEqualToString:mimaRightField.text] ==false)
        {
            
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"请确认两次密码一样" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        else   if (codeRightField.text.length != 4) {
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:@"请正确输入验证码" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/users"];
            NSString *test = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *parameters = @{@"username":nameRightField.text,@"password":phoneRightField.text,@"password_repeat":mimaRightField.text,@"captcha":codeRightField.text};
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            [session POST:test parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//                NSLog(@"formData%@",formData);
            } progress:^(NSProgress * _Nonnull uploadProgress) {
//                NSLog(@"uploadProgress%@",uploadProgress);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"responseObject%@",responseObject);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"注册成功"delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                zhucechenggongAlert = alert;
                [alert show];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"error%@",error);
                
            }];
        }
    }
    else
    {
//        NSLog(@"囧");
    }
}





//按钮One的点击事件
-(void)buttonOneSelect
{
    zhucefangshi=1;
    //    [uiRightView removeFromSuperview];
    //    [self LeftView];
    buttonOne.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] ;
    buttonTwo.backgroundColor =  [UIColor whiteColor] ;
    [buttonTwo setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1]  forState:UIControlStateNormal];
    [buttonOne setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    uiRightView.hidden = YES;
    SelfScrollerView.hidden = NO;;
    
} 
//按钮Two的点击事件
-(void)buttonTwoSelect
{
    zhucefangshi =2;
    //        [SelfScrollerView removeFromSuperview];
    //    [self RightView];
    buttonTwo.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] ;
    buttonOne.backgroundColor = [UIColor whiteColor];
    [buttonOne setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1]  forState:UIControlStateNormal];
    [buttonTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    uiRightView.hidden = NO;
    SelfScrollerView.hidden =YES;
}
#pragma mark 60秒倒计时
-(void)timeFireMethod
{
    
    int Checkseconds = secondsCountDown -1;
    [checkRightButton setTitle:[[NSString stringWithFormat:@"%d",Checkseconds] stringByAppendingString:@"秒后重发"] forState:UIControlStateNormal];
    secondsCountDown--;
    if (secondsCountDown == 0) {
        [countDownTimer invalidate];
        checkRightButton.userInteractionEnabled=YES;
        checkRightButton.alpha=1;
        [checkRightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        secondsCountDown = 60;
    }
    
}
//选择店铺
-(void)xuanzedianpu
{
    getiOrdianpu = @"店铺服务者";
    [getiButton setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
    [dianpuButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
}
//选择个体
-(void)xuanzegeti
{
    getiOrdianpu = @"个体服务者";
    [dianpuButton setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
    [getiButton setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
}
//alert的按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if( alertView==zhucechenggongAlert )
    {
        //NSLog(@"alert1 button index=%ld is clicked.....", (long)buttonIndex);
        if(buttonIndex == 0){
//            NSLog(@"0");
            [self.navigationController popViewControllerAnimated:NO];
        }
        else
        {
//            NSLog(@"😳");
        }
    }
}
//八个选择功能
-(void)bageTap:(UITapGestureRecognizer*)sender
{
//    NSLog(@"%ld",(long)sender.view.tag);
    NSString *strId = [NSString stringWithFormat:@"%ld",(long)sender.view.tag];
    //    int StrId = [strId intValue] - 100;
    UIButton * button =(UIButton*)[ self.view  viewWithTag:[strId intValue]];
    
    //    NSString *medicineId = [NSString stringWithFormat:@"%d",StrId];
    if ([strId intValue] ==100) {
        if ([ONE isEqualToString:@"1"]) {
            ONE =@"";
            [button setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
        }
        else if ([ONE isEqualToString:@""])
        {
            ONE =@"1";
            [button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        }
        
    }
    else if ([strId intValue] ==101) {
        if ([TWO isEqualToString:@"2"]) {
            TWO =@"";
            [button setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
        }
        else if ([TWO isEqualToString:@""])
        {
            TWO =@"2";
            [button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        }
    }
    else if ([strId intValue] ==102) {
        if ([THREE isEqualToString:@"3"]) {
            THREE =@"";
            [button setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
        }
        else if ([THREE isEqualToString:@""])
        {
            THREE =@"3";
            [button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        }
    }
    else if ([strId intValue] ==103) {
        if ([FOUR isEqualToString:@"4"]) {
            FOUR =@"";
            [button setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
        }
        else if ([FOUR isEqualToString:@""])
        {
            FOUR =@"4";
            [button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        }
    }
    else if ([strId intValue] ==104) {
        if ([FIVE isEqualToString:@"5"]) {
            FIVE =@"";
            [button setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
        }
        else if ([FIVE isEqualToString:@""])
        {
            FIVE =@"5";
            [button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        }
    }
    else if ([strId intValue] ==105) {
        if ([SIX isEqualToString:@"6"]) {
            SIX =@"";
            [button setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
        }
        else if ([SIX isEqualToString:@""])
        {
            SIX =@"6";
            [button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        }
    }
    else if ([strId intValue] ==106) {
        if ([SEVEN isEqualToString:@"7"]) {
            SEVEN =@"";
            [button setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
        }
        else if ([SEVEN isEqualToString:@""])
        {
            SEVEN =@"7";
            [button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        }
    }
    else if ([strId intValue] ==107) {
        if ([EIGHT isEqualToString:@"8"]) {
            EIGHT =@"";
            [button setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
        }
        else if ([EIGHT isEqualToString:@""])
        {
            EIGHT =@"8";
            [button setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        }
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
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //开始拖拽
    //NSLog(@"scrollViewWillBeginDragging %@",NSStringFromCGPoint(scrollView.contentOffset));
    [self.view endEditing:YES];
}
//个人的验证码上啦界面

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField ==codeRightField) {
        uiRightView.frame = CGRectMake(0, 0-150, SCREEN_WIDTH, SCREEN_HEIGHT-64) ;
    }
}
//结束编辑调用的方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == codeRightField) {
        uiRightView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) ;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)doBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    MustLogin *login = [[MustLogin alloc]init];
    [self presentViewController:login animated:YES completion:nil];
}


@end
