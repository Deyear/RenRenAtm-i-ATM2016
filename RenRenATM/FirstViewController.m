//
//  FirstViewController.m
//  RenRenATM
//
//
//
//tabBar里面的订单界面



#define NUMBERS @"0123456789."
#define TopViewHeight ((SCREEN_HEIGHT -44)/10*3)
#define modelViewHeight ((SCREEN_HEIGHT -44)/12)

#import "FirstViewController.h"
#import "SettingViewController.h"
#import "LoginViewController.h"
#import "AFNetworking.h"



@interface FirstViewController ()<UITextFieldDelegate>
{
    UIImageView *AllImageView;
    UIButton *rightButton;
    UIImageView *modelView;
    UITextField *howMuchMoney;
    UITextField *NeedMoney,*TotalMoney,*placeField,*qitajinejutizhilabel;
    NSString *dengluqianhou;
    UILabel *dengLuLabel;
    UIButton *shiwuyuanButton,*wuyuanButton,*shiyuanButton;
    int success;
    UITextView *infoView;
}
@end


@implementation FirstViewController

-(void)viewDidWillAppear:(BOOL)animated
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    NSString *phoneNumber = [userDefault objectForKey:@"user_name"];
    
    //登录判断
    if (access_token==nil) {
        dengLuLabel.text =@"点击登录人人ATM";
    }
    else
    {
        dengLuLabel.text =phoneNumber;
    }
    
    NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
        NSLog(@"=========encodeResult:%@",encodeResult);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    infoView = [[UITextView alloc]initWithFrame:CGRectMake(50, 100, SCREEN_WIDTH-100, SCREEN_HEIGHT-200)];
    infoView.text = @"\n发单的时候相关跑腿服务费计算方式\n\na.信用卡取现：  服务费计算方式，7000以下 0.49% 封顶35   跑腿费500以下5元 5000以下10元，5000-2万以下20元\nb.储蓄卡存款，储蓄卡取现 ，我要换零钱，我要换整钱：   跑腿费为500以下5元 5000以下10元，5000-2万以下20元。\nc.我要转帐： 服务费为转账费用   跑腿费500以下5元 5000以下10元，5000-2万以下20元。\nd.我要换外汇：跑腿费不管多少都是20元。\ne.信用卡取现，储蓄卡存款，储蓄卡取现，单笔交易金额为2万元，超过部分算下一单。";
    infoView.backgroundColor = [UIColor redColor];
    infoView.font = [UIFont systemFontOfSize:17];
    
    //wenhaobutton
    UIButton *guanbiButton  = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-130,5,20,20)];
    guanbiButton.backgroundColor = [UIColor whiteColor];
    [guanbiButton addTarget:self action:@selector(guanbi) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:guanbiButton];

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
    success = 1;
    AllImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) ];
    AllImageView.image = [UIImage imageNamed:@"RenRenGray"];
    [self.view addSubview:AllImageView];
    
    //顶部图片
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
    topImageView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    AllImageView.userInteractionEnabled = YES;
    [self.view addSubview:topImageView];
    //顶部左右按钮
    rightButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 20, 65, 44) ];
    [rightButton setTitle: @"设置" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    
    [topImageView addSubview:rightButton];
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


    //代收款label
    UILabel *daishoukuanLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-SCREEN_WIDTH/7)/2, 0 , SCREEN_WIDTH/7, modelViewHeight/4*3)];
    daishoukuanLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.3];

    daishoukuanLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    
    daishoukuanLabel.text =@"代收款";
    daishoukuanLabel.adjustsFontSizeToFitWidth = YES;
    [baiSeBeiJingView addSubview:daishoukuanLabel];
    
    //wenhaobutton
    UIButton *wenhaoButton  = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -35, daishoukuanLabel.frame.origin.y + daishoukuanLabel.frame.size.height +5,20, 20)];
    wenhaoButton.backgroundColor = [UIColor redColor];
    [wenhaoButton addTarget:self action:@selector(wenhao) forControlEvents:UIControlEventTouchUpInside];
    [baiSeBeiJingView addSubview:wenhaoButton];
    
    //1分钟label
    UILabel *yifenzhongLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, daishoukuanLabel.frame.origin.y + daishoukuanLabel.frame.size.height ,SCREEN_WIDTH /5*3, modelViewHeight/2
)];
    yifenzhongLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.2];
    
    yifenzhongLabel.adjustsFontSizeToFitWidth = YES;
    yifenzhongLabel.text =@"只需1分钟，快速发布交易信息";
    [baiSeBeiJingView addSubview:yifenzhongLabel];

    
    for (int i = 0 ; i< 5; i++) {
        if (i<4) {
             modelView = [[UIImageView alloc]initWithFrame:CGRectMake(15,5+ yifenzhongLabel.frame.origin.y + yifenzhongLabel.frame.size.height + i*modelViewHeight, SCREEN_WIDTH-30, modelViewHeight)];
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
            NSArray *array = [NSArray arrayWithObjects:@"所需金额",@"给予赏金",@"所在位置",@"所需时间", nil];
            UILabel *fourZuoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, (SCREEN_WIDTH-30)/4 - 10, modelView.frame.size.height)];
            fourZuoLabel.text = array[i];
            fourZuoLabel.adjustsFontSizeToFitWidth = YES;
            fourZuoLabel.textAlignment = NSTextAlignmentCenter;
            [modelView addSubview:fourZuoLabel];
            AllImageView.userInteractionEnabled = YES;
            baiSeBeiJingView.userInteractionEnabled = YES;

            //在第一个所需金额的框里
            if (i == 0) {
                
                //¥金额
                UILabel *jinqianfuhaoLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 30)/2  - 20, 0, 20, modelViewHeight)];
                jinqianfuhaoLabel.text =@"¥";
                jinqianfuhaoLabel.font = [UIFont systemFontOfSize:13];
                jinqianfuhaoLabel.textColor = [UIColor grayColor];
                [modelView addSubview:jinqianfuhaoLabel];
                //所需金额
                howMuchMoney = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -30)/4+5, 0, (SCREEN_WIDTH -30)/4 - 20, modelViewHeight)];
                howMuchMoney.placeholder = @"1000";
                howMuchMoney.font = [UIFont systemFontOfSize: 13];
                howMuchMoney.textAlignment = NSTextAlignmentCenter;
                howMuchMoney.delegate = self;
                [modelView addSubview:howMuchMoney];
                //服务跑腿费
                NeedMoney = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH- 30)/2 - 12, 0, (SCREEN_WIDTH -30)/4+12  , modelViewHeight)];
                NeedMoney.text = [NSString stringWithFormat:@" 跑腿服务费 ¥"];
                NeedMoney.textColor = [UIColor grayColor];
                NeedMoney.font = [UIFont systemFontOfSize:12];
                NeedMoney.userInteractionEnabled  =NO;
                NeedMoney.textAlignment = NSTextAlignmentCenter;
                NeedMoney.adjustsFontSizeToFitWidth = YES;
                [modelView addSubview:NeedMoney];
                
                //总共金额
                TotalMoney = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH- 30)/4*3 , 0, (SCREEN_WIDTH -30)/4, modelViewHeight)];
                TotalMoney.text =[NSString stringWithFormat:@" 合计 ¥"];
                TotalMoney.textAlignment = NSTextAlignmentCenter;
                TotalMoney.userInteractionEnabled = NO;
                TotalMoney.font = [UIFont systemFontOfSize:12];
                TotalMoney.textColor = [UIColor grayColor];
                TotalMoney.adjustsFontSizeToFitWidth = YES;
                [modelView addSubview:TotalMoney];
                modelView.userInteractionEnabled = YES;
                howMuchMoney.userInteractionEnabled = YES;
            }
            //打赏金额
            if (i==1) {
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
                shiwuyuanButton.layer.borderWidth=1;
                shiwuyuanButton.layer.cornerRadius = 5;
                [shiwuyuanButton addTarget:self action:@selector(shiwuyuan) forControlEvents:UIControlEventTouchUpInside];
                shiwuyuanButton.layer.borderColor = [[UIColor blueColor] CGColor];
                [modelView addSubview:shiwuyuanButton];
                
                //十五元Label
                UILabel *shiwuyuanlabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*2 +(SCREEN_WIDTH-30)/4*3/5/5*2, (modelViewHeight  - 20)/2, 20, 20)];
                shiwuyuanlabel.text = @"15¥";
                shiwuyuanlabel.font = [UIFont systemFontOfSize:13];
                shiwuyuanlabel.adjustsFontSizeToFitWidth  = YES;
                [modelView addSubview:shiwuyuanlabel];
                
                //其它金额Label
                UILabel *qitajinelabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*3, (modelViewHeight  - 20)/2,  (SCREEN_WIDTH-30)/4*3/5, 20)];
                qitajinelabel.text = @"其它金额";
                qitajinelabel.font = [UIFont systemFontOfSize:13];
                qitajinelabel.adjustsFontSizeToFitWidth  = YES;
                [modelView addSubview:qitajinelabel];
                
                //其它金额具体指Label
                qitajinejutizhilabel = [[UITextField alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)/4 + (SCREEN_WIDTH-30)/4*3/5*4+10, (modelViewHeight  - 20)/2,  (SCREEN_WIDTH-30)/4*3/5/5*4, 20)];
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
            if (i ==2) {
                //所在位置
                 placeField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, (SCREEN_WIDTH -110), modelViewHeight)];
                placeField.placeholder = [NSString stringWithFormat:@"所在位置"];
                placeField.textColor = [UIColor grayColor];
                placeField.font = [UIFont systemFontOfSize: 15];
                placeField.textAlignment = NSTextAlignmentCenter;
                placeField.adjustsFontSizeToFitWidth = YES;
                [modelView addSubview:placeField];
                modelView.userInteractionEnabled = YES;
                placeField.userInteractionEnabled = YES;
            }
            if (i==3) {
                //所需时间
                UITextField *timeField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, (SCREEN_WIDTH -110), modelViewHeight)];
                timeField.placeholder = [NSString stringWithFormat:@"所需时间"];
                timeField.font = [UIFont systemFontOfSize:15];
                timeField.textColor = [UIColor grayColor];
                timeField.textAlignment = NSTextAlignmentCenter;
                timeField.adjustsFontSizeToFitWidth = YES;
                [modelView addSubview:timeField];
                modelView.userInteractionEnabled = YES;
                timeField.userInteractionEnabled = YES;
            }
       
        }
        else if(i == 4)
        {
            //先判断有否在做
            if (success == 1) {
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
                UITextField *daishoukuanrenField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, (SCREEN_WIDTH -110), modelViewHeight)];
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
            

        }
    }
    //设置白色背景的尺寸
    baiSeBeiJingView.frame = CGRectMake(0, topImageView.frame.origin.y + topImageView.frame.size.height, SCREEN_WIDTH, modelView.frame.origin.y + modelViewHeight + 10) ;
    
    //最下面的发布button
    UIButton *fabuButton  = [[UIButton alloc]initWithFrame:CGRectMake(15, SCREEN_HEIGHT - modelViewHeight - 44 -20, SCREEN_WIDTH -30, modelViewHeight)];
    [fabuButton setBackgroundImage:[UIImage imageNamed:@"RenRenTabbar"] forState:UIControlStateNormal];
    fabuButton.layer.masksToBounds = YES;
    fabuButton.layer.cornerRadius = modelViewHeight/8;
    [fabuButton setTitle:@"发布" forState:UIControlStateNormal];
    [fabuButton addTarget:self action:@selector(fabu) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:fabuButton];
    
    
    
    
    
   
}


//让金额只能输入数字
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    if (textField == howMuchMoney) {
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
    if ([howMuchMoney.text isEqualToString:@""]) {
//        NSLog(@"meiyou");
        NeedMoney.text = [NSString stringWithFormat:@" 跑腿服务费 ¥"];
        TotalMoney.text =[NSString stringWithFormat:@" 合计 ¥"];
    }
    else
    {
        int needMoney ;
//    NSLog(@"you");
        int howmuch= [howMuchMoney.text intValue];
        if (howmuch<=500) {
            needMoney =  5 + [howMuchMoney.text intValue]*0.0049;
        }
       else  if (howmuch<=5000) {
           needMoney =  10 + [howMuchMoney.text intValue]*0.0049;
       }
        else if (howmuch<=7000)
        {
             needMoney =  20 + [howMuchMoney.text intValue]*0.0049;
        }
        else if (howmuch<=20000)
        {
            needMoney =  20 + 35;
        }
//      needMoney = [howMuchMoney.text intValue] + 88;
        NeedMoney.text = [NSString stringWithFormat:@"跑腿服务费%d¥",needMoney];
        TotalMoney.text = [NSString stringWithFormat:@"合计%d¥",needMoney + [howMuchMoney.text intValue]];
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

//跳转到设置界面
-(void)setting
{
    SettingViewController *setting = [[SettingViewController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:setting];
    [self presentViewController:navi animated:NO completion:nil];
    
    
}


//跳转到登录
-(void)Login
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    if (access_token==nil) {
//        NSLog(@"123");
        LoginViewController *Login = [[LoginViewController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:Login];
        [self presentViewController:navi animated:NO completion:nil];
    }
    else
    {

    }


}


//发布订单
-(void)fabu
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    if (access_token==nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请先登录后发布" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
        
        NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
//        NSLog(@"encodeResult:%@",token);
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        session.requestSerializer = [AFJSONRequestSerializer serializer];
        session.responseSerializer = [AFJSONResponseSerializer serializer];
        [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        NSDictionary *parameters = @{@"money":@"1",
                                     @"dealt_at":@"1",
                                     @"sent_at":@"1",
                                     @"tip":@"1",
                                     @"service_item_id":@"1",
                                     @"time_limit":@"1",
                                     @"status":@"101",
                                     @"service_charge":@"1",
                                     @"sent_by":@"1"};
        
        NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/orders"];
        
        [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//            NSLog(@"formData%@",formData);
        } progress:^(NSProgress * _Nonnull uploadProgress) {
//            NSLog(@"uploadProgress%@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"responseObject%@",responseObject);
            //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"登录成功"delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            //
            //        [alert show];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            NSLog(@"error%@",error);
        }];

    }
    

}


//选择5元10元15元
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
    qitajinejutizhilabel.text = @"15";
}

-(void)wenhao
{
    [self.view addSubview:infoView];
}
-(void)guanbi
{
    [infoView removeFromSuperview];
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
