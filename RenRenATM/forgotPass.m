//
//  forgotPass.m
//  RenRenATM
//
//
//
//找回密码

#import "forgotPass.h"
#import "AFNetworking.h"

@interface forgotPass (){
    
    IBOutlet UIView *topView;
    
    NSTimer *countDownTimer;
    
    LRTextField * nameRightField,*yanzhengmaFeild,*xinmimaFeild;
    
    BFPaperButton *checkRightButton;
    
    LRTextField *shoujihaoFeild;
    
    int secondsCountDown;

}

@end

@implementation forgotPass

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initValue];             //初始值
    
    [self initTopView];           //初始化导航
    
    [self initViewsForMain];      //初始化界面
    
}

#pragma mark init
-(void)initValue{

    secondsCountDown = 60;
    
}

-(void)initTopView{

    topView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    
    //灰色背景
    UIImageView *gray = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH , SCREEN_HEIGHT-64)];
    gray.image = [UIImage imageNamed:@"RenRenGray"];
    [self.view addSubview:gray];

}

-(void)initViewsForMain{

    //白色背景
    UIImageView *white = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30 + 64,SCREEN_WIDTH , 44*3)];
    white.userInteractionEnabled = YES;
    white.image = [UIImage imageNamed:@"baise"];
    [self.view addSubview:white];
    
    //手机号label
    UILabel *shoujihaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 60, 24)];
    shoujihaoLabel.text =@"手机号";
    [white addSubview:shoujihaoLabel];
    
    //验证码label
    UILabel *yanzhengmaLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 54, 60, 24)];
    yanzhengmaLabel.text =@"验证码";
    [white addSubview:yanzhengmaLabel];
    
    //新密码label
    UILabel *xinmimaLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 98, 60, 24)];
    xinmimaLabel.text =@"新密码";
    [white addSubview:xinmimaLabel];
    
    //xianlabel
    UILabel *xianLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 44,SCREEN_WIDTH-15, 1)];
    xianLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    [white addSubview:xianLabel];
    //xianlabel
    UILabel *xian2Label = [[UILabel alloc]initWithFrame:CGRectMake(15, 88,SCREEN_WIDTH-15, 1)];
    xian2Label.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    [white addSubview:xian2Label];
    
    //请输入手机号
    shoujihaoFeild = [[LRTextField alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH -120, 24)];
    shoujihaoFeild.placeholder = @"请输入手机号";
    shoujihaoFeild.borderStyle = UITextBorderStyleNone;
    [white addSubview:shoujihaoFeild];
    
    //请输入验证码
    yanzhengmaFeild = [[LRTextField alloc]initWithFrame:CGRectMake(100, 54, SCREEN_WIDTH -120, 24)];
    yanzhengmaFeild.placeholder = @"请输入验证码";
    yanzhengmaFeild.borderStyle = UITextBorderStyleNone;
    [white addSubview:yanzhengmaFeild];
    
    //请输入新密码
    xinmimaFeild = [[LRTextField alloc]initWithFrame:CGRectMake(100, 98, SCREEN_WIDTH -120, 24)];
    xinmimaFeild.placeholder = @"输入您要修改的密码";
    xinmimaFeild.borderStyle = UITextBorderStyleNone;
    [white addSubview:xinmimaFeild];
 
    //获取验证码按钮
    checkRightButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, yanzhengmaFeild.frame.origin.y , 80, 20)];
    checkRightButton.shadowColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    checkRightButton.backgroundColor = [UIColor whiteColor];
    [checkRightButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [checkRightButton setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    [checkRightButton addTarget:self
                         action:@selector(getCheckLeftCode:)
               forControlEvents:UIControlEventTouchUpInside];
    checkRightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [white addSubview:checkRightButton];
    
    //确认按钮
    BFPaperButton *querenButon = [[BFPaperButton alloc]initWithFrame:CGRectMake(15, white.frame.origin.y + white.frame.size.height + 80, SCREEN_WIDTH - 30, 44)];
    [querenButon setTitle:@"确认" forState:UIControlStateNormal];
    [querenButon addTarget:self
                    action:@selector(queRenAction:)
          forControlEvents:UIControlEventTouchUpInside];
    querenButon.backgroundColor  = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [querenButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    querenButon.layer.cornerRadius =10;
    querenButon.cornerRadius = 10;
    [self.view addSubview:querenButon];
    
}

#pragma mark Button Click
-(void)queRenAction:(UIButton *)sender{
    
    NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/user/forget-password"];
    NSDictionary *parameters = @{@"username":shoujihaoFeild.text,
                                 @"password":xinmimaFeild.text,
                                 @"captcha":yanzhengmaFeild.text};
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session POST:str
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           
              UIAlertView *notiAlert = [[UIAlertView alloc]
                                        initWithTitle:nil
                                        message:@"重置密码成功！"
                                        delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
              
              [notiAlert show];
              [self dismissViewControllerAnimated:YES completion:nil];
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              UIAlertView *notiAlert = [[UIAlertView alloc]
                                        initWithTitle:nil
                                        message:@"验证码错误！"
                                        delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
              
              [notiAlert show];

          }];

}

//点击按钮进行返回
- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark Other Action
//获取验证码
- (void)getCheckLeftCode :(UIButton *)sender{
    if (shoujihaoFeild.text.length !=11) {
        
        UIAlertView *notiAlert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"手机号码输入有误"
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil, nil];
        
        [notiAlert show];
        
    }
    else{
        
        NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/captcha/forget-send?number=%@",shoujihaoFeild.text];
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session GET:str
          parameters:nil
            progress:^(NSProgress * _Nonnull downloadProgress) {
            
        }
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            
        }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            UIAlertView *notiAlert = [[UIAlertView alloc]initWithTitle:nil
                                                               message:@"发送验证码成功" delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
            
            [notiAlert show];
            
            //60秒计时器
            countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                              target:self
                                                            selector:@selector(timeFireMethod)
                                                            userInfo:nil
                                                             repeats:YES];
            
            sender.userInteractionEnabled=NO;
            sender.alpha=0.4;

        }];

    }

}

//计时器的运行事件
-(void)timeFireMethod{
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
