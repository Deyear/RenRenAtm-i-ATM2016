
#define TopViewHeight ((SCREEN_HEIGHT -44)/10*3)
#define TwoAndTwoViewHeight ((SCREEN_HEIGHT -44)/10*1.2)
#define ThreeHeight ((SCREEN_HEIGHT -44)/10*2)
#define fourViewHeight ((SCREEN_WIDTH-5)/4)
#import "FourViewController.h"
#import "SettingViewController.h"
#import "xinyongkaquxianViewController.h"
#import "LoginViewController.h"
#import "WaiHuiViewController.h"
@interface FourViewController ()<UIScrollViewDelegate>
{
    UIScrollView * scrollViewUpToBottom;
    UIImageView *top1ImageView;
    UIImageView *FourView;
    UIImageView *ThreeView;
    UIButton *rightButton;
    NSString *dengluqianhou;
    UILabel *dengLuLabel;
    
}

@end

@implementation FourViewController
-(void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    NSString *phoneNumber = [userDefault objectForKey:@"user_name"];
    
    //最上面的显示手机号码的判断
    if (access_token==nil) {
        dengLuLabel.text =@"点击登录人人ATM";
    }
    else
    {
        dengLuLabel.text =phoneNumber;
    }
    
    NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    NSLog(@"encodeResult:%@",encodeResult);
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    if (access_token==nil) {
        dengluqianhou =@"点击登录人人ATM";
    }
    else
    {
        dengluqianhou =@"点击进入个人资料";
    }
    // Do any additional setup after loading the view from its nib.
    //全局滚动背景
    scrollViewUpToBottom =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
    //设置容量
    scrollViewUpToBottom.userInteractionEnabled = YES;
        scrollViewUpToBottom.bounces = NO;
    scrollViewUpToBottom.showsVerticalScrollIndicator = FALSE;
    scrollViewUpToBottom.showsHorizontalScrollIndicator = FALSE;
    
    scrollViewUpToBottom.backgroundColor =[UIColor clearColor];
    scrollViewUpToBottom.delegate = self;
    [self.view addSubview:scrollViewUpToBottom];
    //全局背景图片
    top1ImageView = [[UIImageView alloc]init ];
    top1ImageView.image = [UIImage imageNamed:@"RenRenGray"];
    [scrollViewUpToBottom addSubview:top1ImageView];
    
    //顶部图片
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
    topImageView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    top1ImageView.userInteractionEnabled = YES;
    [top1ImageView addSubview:topImageView];
    //顶部右按钮
    rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 20, 65, 44) ];
    [rightButton setTitle: @"设置" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [top1ImageView addSubview:rightButton];
    //顶部人人图标
    UIImageView *topAvatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -TopViewHeight/2)/2, TopViewHeight/4, TopViewHeight/2, TopViewHeight/2)];
        UITapGestureRecognizer * TapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LoginButton)];
    topAvatarImageView.image = [UIImage imageNamed:@"individual_user"];
    topImageView.userInteractionEnabled = YES;
    topAvatarImageView.userInteractionEnabled = YES;
    [topAvatarImageView addGestureRecognizer:TapGestureRecognizer];

    [top1ImageView addSubview:topAvatarImageView];
    //点击登录录人ATM
    dengLuLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, TopViewHeight/4*3, 150, TopViewHeight/4)];
    dengLuLabel.textColor = [UIColor whiteColor];
    dengLuLabel.backgroundColor = [UIColor clearColor];
    dengLuLabel.textAlignment =NSTextAlignmentCenter;
    dengLuLabel.text = dengluqianhou;
    [top1ImageView addSubview:dengLuLabel];
    //下面的四个界面
        NSArray *twoAndtwoArray = [NSArray arrayWithObjects:@"individual_One",@"individual_Two",@"individual_Three",@"individual_Four", nil];
    NSArray *twoAndtwoNameArray = [NSArray arrayWithObjects:@"信用卡取现",@"银行卡取现",@"代收款",@"我要换外汇", nil];
    NSArray *twoAndtwoContentArray = [NSArray arrayWithObjects:@"贷款取现、便捷",@"取现、快人一步",@"有事、离不开身",@"外汇、轻松掌握", nil];
    
    for (int i = 0; i<4; i++) {
        UIImageView *TwoAndTwoView =[[UIImageView alloc]initWithFrame:CGRectMake(1 +((i%2)*(SCREEN_WIDTH/2-0.5)),1+ topImageView.frame.size.height+(i/2)*TwoAndTwoViewHeight , (SCREEN_WIDTH-3)/2, TwoAndTwoViewHeight-1)];
//        TwoAndTwoView.backgroundColor  = [UIColor redColor];
        TwoAndTwoView.backgroundColor  = [UIColor whiteColor];
        [top1ImageView addSubview:TwoAndTwoView];
        UITapGestureRecognizer * TapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fabu:)];
        [TwoAndTwoView setUserInteractionEnabled:YES];
        [TwoAndTwoView addGestureRecognizer:TapGestureRecognizer];
        UIView *singleTapView = [TapGestureRecognizer view];
        singleTapView.tag = i+101;
        
        //加图片 名字 内容
        //图片
        UIImageView *fourView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/15, TwoAndTwoViewHeight/4, TwoAndTwoViewHeight/2, TwoAndTwoViewHeight/2)];
        fourView.image = [UIImage imageNamed:twoAndtwoArray[i]];
        [TwoAndTwoView addSubview:fourView];
        //名字
        UILabel *fourLabel = [[UILabel alloc]initWithFrame:CGRectMake(fourView.frame.origin.x + fourView.frame.size.width + 5, TwoAndTwoViewHeight/4, SCREEN_WIDTH/2 - SCREEN_WIDTH/24*3 -TwoAndTwoViewHeight/2 , TwoAndTwoViewHeight/4)];
        fourLabel.text = twoAndtwoNameArray[i];
        fourLabel.font = [UIFont systemFontOfSize: 15];
        [TwoAndTwoView addSubview:fourLabel];
        //内容
        UILabel *fourContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(fourView.frame.origin.x + fourView.frame.size.width + 5, TwoAndTwoViewHeight/2+5, SCREEN_WIDTH/2 - SCREEN_WIDTH/24*3 -TwoAndTwoViewHeight/2 , TwoAndTwoViewHeight/4)];
        fourContentLabel.text = twoAndtwoContentArray[i];
        fourContentLabel.textColor = [UIColor darkGrayColor];
        fourContentLabel.font = [UIFont systemFontOfSize: 11];
        [TwoAndTwoView addSubview:fourContentLabel];
        
    }
    //下面的四个界面
    NSArray *FourIconArray = [NSArray arrayWithObjects:@"individual_Five",@"individual_Six",@"individual_Seven",@"individual_Eight", nil];
    NSArray *FourNameArray = [NSArray arrayWithObjects:@"我要存钱",@"我要转账",@"我要换零钱",@"我要换整钱", nil];
    
    for (int i = 0; i<4; i++) {
        //横着四个view
        FourView =[[UIImageView alloc]initWithFrame:CGRectMake(1 +(i%4)*((SCREEN_WIDTH-5)/4 +1),1+ topImageView.frame.size.height+ TwoAndTwoViewHeight*2, (SCREEN_WIDTH-5)/4, (SCREEN_WIDTH-5)/4)];
//        FourView.backgroundColor  = [UIColor yellowColor];
        FourView.backgroundColor  = [UIColor whiteColor];
        [top1ImageView addSubview:FourView];
        UITapGestureRecognizer * TapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fabu:)];
        [FourView setUserInteractionEnabled:YES];
        [FourView addGestureRecognizer:TapGestureRecognizer];
        UIView *singleTapView = [TapGestureRecognizer view];
        singleTapView.tag = i+105;
        //fouricon
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((fourViewHeight - fourViewHeight/5*2)/2, (fourViewHeight/4), fourViewHeight/5*2, fourViewHeight/5*2)];
        imageView.image =[UIImage imageNamed:FourIconArray[i]] ;
        [FourView addSubview:imageView];
        //fourLabel
        UILabel *fourLabel = [[UILabel alloc]initWithFrame:CGRectMake(fourViewHeight/12, fourViewHeight/2, fourViewHeight/6*5 , fourViewHeight/2)];
        fourLabel.text = FourNameArray[i];
        fourLabel.font = [UIFont systemFontOfSize: 14];
        fourLabel.adjustsFontSizeToFitWidth = YES;
        fourLabel.textAlignment = NSTextAlignmentCenter;
        fourLabel.textColor = [UIColor darkGrayColor];
        [FourView addSubview:fourLabel];
        
    }
//    //下面的三个界面
//    for (int i = 0; i<3; i++) {
//        ThreeView =[[UIImageView alloc]initWithFrame:CGRectMake(0,FourView.frame.origin.y + FourView.frame.size.height +3 + (i%3)*ThreeHeight, SCREEN_WIDTH, ThreeHeight)];
//        ThreeView.backgroundColor  = [UIColor whiteColor];
//        [top1ImageView addSubview:ThreeView];
//        
//        UIImageView *threeImageView =[[UIImageView alloc]initWithFrame:CGRectMake(15,3 , SCREEN_WIDTH-30, ThreeHeight-6)];
//        threeImageView.image = [UIImage imageNamed:@"RenRenTest"];
//        [ThreeView addSubview:threeImageView];
//        
//    }
                     top1ImageView.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT*2);
    scrollViewUpToBottom.contentSize = CGSizeMake(SCREEN_WIDTH, ThreeView.frame.origin.y + ThreeView.frame.size.height +5);
}
//跳转到设置界面
-(void)setting
{
    SettingViewController *setting = [[SettingViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:setting];
    [self presentViewController:navi animated:NO completion:nil];
    
    
}
//发布
-(void)fabu:(id)onview
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)onview;
    
    NSInteger i = [singleTap view].tag;
//    NSLog(@"%ld",(long)i);
    if (i == 104) {
        WaiHuiViewController *waihui = [[WaiHuiViewController alloc]init];
        waihui.success=@"0";
        waihui.type=@"4";
        [self presentViewController:waihui animated:NO completion:nil];

    }
    else
    {
        if (i == 103) {
            xinyongkaquxianViewController *quxian = [[xinyongkaquxianViewController alloc]init];
            quxian.success=@"1";
            quxian.type=@"3";
            [self presentViewController:quxian animated:NO completion:nil];
            

        }
        else
        {
            
            xinyongkaquxianViewController *quxian = [[xinyongkaquxianViewController alloc]init];
            quxian.type =[NSString stringWithFormat:@"%ld",i - 100];
            quxian.success=@"0";
            [self presentViewController:quxian animated:NO completion:nil];

        }
}
}
//    xinyongkaquxianViewController *quxian = [[xinyongkaquxianViewController alloc]init];
//    [self presentViewController:quxian animated:NO completion:nil];
//跳转到登录
-(void)LoginButton
    
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *access_token = [userDefault objectForKey:@"access_token"];
        if (access_token==nil) {
//            NSLog(@"123");
            LoginViewController *Login = [[LoginViewController alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:Login];
            [self presentViewController:navi animated:NO completion:nil];
        }
        else
        {
            
        }
        
        
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
