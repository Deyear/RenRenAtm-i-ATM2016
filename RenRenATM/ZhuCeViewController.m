//
//  ZhuCeViewController.m
//  RenRenATM
//
//
//
//注册

#import "ZhuCeViewController.h"
#import "AFNetworking.h"             //网址请求
#import "MustLogin.h"                //登录界面
#import "NextViewController.h"       //选择服务者页面

@interface ZhuCeViewController ()<UITextFieldDelegate>{

    LRTextField *textFieldPhone,*passwordOne,
                *passwordTwo,*getKey;                       //用户名、手机号、密码1、密码2、验证码
    
    BFPaperButton *registerButton,*requestKeyButton;        //注册按钮、获取验证码
    
    int secondsCountDown;                                   //60秒
    
    NSTimer *countDownTimer;                                //计时器
    
}

@end

@implementation ZhuCeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initValue];                   //初始化值
    
    [self initLabelAndTextButton];      //初始化界面里面的控件
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

#pragma mark - init
//初始化值
-(void)initValue{

    secondsCountDown = 60;

}

//初始化界面控件
-(void) initLabelAndTextButton{
    
//    //用户名
//    UILabel *personName = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 80, 30)];
//    personName.text = @"用户名：";
//    personName.textAlignment = NSTextAlignmentLeft;
//    [self.view addSubview:personName];
    
    //请输入您的用户名
//    userName = [[LRTextField alloc] initWithFrame:CGRectMake(120, 100, SCREEN_WIDTH-100-80, 30) labelHeight:15];
//    userName.borderStyle = UITextBorderStyleNone;
//    userName.placeholder = @"请输入您的用户名";
//    [self.view addSubview:userName];

    //手机号
    UILabel *phoneName = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 80, 30)];
    phoneName.text = @"手机号：";
    phoneName.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:phoneName];
    
    //请输入您的手机号
    textFieldPhone = [[LRTextField alloc] initWithFrame:CGRectMake(120, 100, SCREEN_WIDTH-100-80, 30) labelHeight:15];
    textFieldPhone.borderStyle = UITextBorderStyleNone;
    textFieldPhone.placeholder = @"请输入您的手机号";
    textFieldPhone.format = @"###########"; // set format for segment input string
    textFieldPhone.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:textFieldPhone];
    
    //密码
    UILabel *passlabel1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 80, 30)];
    passlabel1.text = @"密码：";
//    passlabel1.font = [UIFont systemFontOfSize:15];
    passlabel1.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:passlabel1];
    
    //请输入密码
    passwordOne = [[LRTextField alloc] initWithFrame:CGRectMake(120, 150, SCREEN_WIDTH-100-80, 30) labelHeight:15];
    passwordOne.placeholder = @"请输入密码";
    passwordOne.borderStyle = UITextBorderStyleNone;
    passwordOne.delegate = self;
    [passwordOne setSecureTextEntry:YES];
    [self.view addSubview:passwordOne];

    //确认密码
    UILabel *passlabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, 80, 30)];
    passlabel2.text = @"密码：";
//    passlabel2.font = [UIFont systemFontOfSize:15];
    passlabel2.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:passlabel2];
    
    //请再次确认密码
    passwordTwo = [[LRTextField alloc] initWithFrame:CGRectMake(120, 200, SCREEN_WIDTH-100-80, 30) labelHeight:15];
    passwordTwo.placeholder = @"请再次确认密码";
    passwordTwo.borderStyle = UITextBorderStyleNone;
    passwordTwo.delegate = self;
    [passwordTwo setSecureTextEntry:YES];
    [self.view addSubview:passwordTwo];
    
    //请输入验证码
    getKey = [[LRTextField alloc] initWithFrame:CGRectMake(20, 250, SCREEN_WIDTH-100-80, 30) labelHeight:15];
    getKey.placeholder = @"请输入验证码";
    getKey.borderStyle = UITextBorderStyleNone;
    getKey.delegate = self;
    [self.view addSubview:getKey];
    
    //获取验证码
    requestKeyButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(20+SCREEN_WIDTH-100-80, 250, 100, 30) raised:NO];
    [requestKeyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [requestKey setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [requestKeyButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
     [requestKeyButton addTarget:self action:@selector(getTheKey:) forControlEvents:UIControlEventTouchUpInside];
    requestKeyButton.backgroundColor = [UIColor whiteColor];
    requestKeyButton.tapCircleColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    requestKeyButton.cornerRadius = requestKeyButton.frame.size.width / 2;
    requestKeyButton.rippleFromTapLocation = NO;
    requestKeyButton.rippleBeyondBounds = YES;
    requestKeyButton.tapCircleDiameter = MAX(requestKeyButton.frame.size.width, requestKeyButton.frame.size.height) * 1.3;
    [self.view addSubview:requestKeyButton];
    
    //五条下划线
    for (int i = 1; i<5; i++) {
        UIView *lines = [[UIView alloc]initWithFrame:CGRectMake(20,30 + 50*(i + 1), SCREEN_WIDTH- 40, 1)];
        lines.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
        [self.view addSubview:lines];
    }
    
    //注册按钮
    registerButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(40, 350, SCREEN_WIDTH-80, 44) raised:YES];
    [registerButton setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1]];
    registerButton.titleLabel.numberOfLines = 0;
    registerButton.layer.cornerRadius =22;
    registerButton.cornerRadius = 22;
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.f]];
    [registerButton addTarget:self action:@selector(doRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    //注册按钮
    BFPaperButton*nextLogin = [[BFPaperButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-140, 400,  100, 30) raised:YES];
    [nextLogin setBackgroundColor:[UIColor whiteColor]];
    nextLogin.titleLabel.numberOfLines = 0;
    nextLogin.layer.cornerRadius =22;
    nextLogin.shadowColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [nextLogin setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    nextLogin.cornerRadius = 15;
    [nextLogin setTitle:@"已有账号，直接登录" forState:UIControlStateNormal];
    [nextLogin setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
    [nextLogin addTarget:self action:@selector(goLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextLogin];

}


#pragma mark - button click
//返回事件
- (IBAction)doBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//获取验证码
-(void)getTheKey:(UIButton *)sender{
    //发送验证码成功弹窗
    
    //获取验证码网址
    NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/captcha/send?number=%@",textFieldPhone.text];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

     [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//                NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"-----responseObject----%@",responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"-----error----%@",error);

                if (textFieldPhone.text.length != 11) {
                    
                    UIAlertView *notiAlert = [[UIAlertView alloc]
                                              initWithTitle:nil
                                              message:@"请正确填写手机号码！"
                                              delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
                    [notiAlert show];
                    
                }else{
                
                    //发送验证码成功弹窗
                    UIAlertView *notiAlert = [[UIAlertView alloc]
                                              initWithTitle:nil
                                              message:@"发送验证码成功"
                                              delegate:nil
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
                    
                }
                
    }];
    
}

//注册
-(void)doRegister:(UIButton *)sender{
    
    //信息每天完整的弹窗
    if ([textFieldPhone.text  isEqual: @""]||[passwordOne.text  isEqual: @""]||[passwordTwo.text  isEqual: @""]||[getKey.text  isEqual: @""]) {

        //注册信息未填完整弹窗
        UIAlertView *notiAlert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"注册信息未填完整"
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil, nil];
        [notiAlert show];

    }else{

        //密码不对的弹窗
        if([passwordOne.text isEqualToString:passwordTwo.text] ==false) {
            
            UIAlertView *notiAlert = [[UIAlertView alloc]
                                      initWithTitle:@"请重新输入密码！"
                                      message:@"两次输入的密码不一样"
                                      delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil, nil];
            [notiAlert show];
            //NSLog(@"\n%@\n%@",passwordOne.text,passwordTwo.text);
        
        }else{
        
//            NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/users"];
//            NSString *test = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *parameters = @{@"username":textFieldPhone.text,
//                                         @"password":passwordOne.text,
//                                         @"password_repeat":passwordTwo.text,
//                                         @"captcha":getKey.text};
//            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//            [session POST:test
//               parameters:parameters
//                 progress:nil
//                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
                      UIAlertView *notiAlert = [[UIAlertView alloc]
                                                initWithTitle:@"注册成功！"
                                                message:nil
                                                delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
                      [notiAlert show];
                      
//                      NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//                      [userDefaults setObject:responseObject[@"access_token"] forKey:@"access_token"];
//                      [userDefaults setObject:textFieldPhone.text forKey:@"user_name"];
//                      [userDefaults setObject:responseObject[@"user_id"]  forKey:@"user_id"];
//                      [userDefaults setObject:passwordOne.text  forKey:@"password"];
//
//
//                      
//                  }
//                  failure:nil];

        }
    
    }
 
}

//有账号，直接登录
-(void)goLogin:(UIButton *)sender{

    MustLogin *vc = [[MustLogin alloc]init];
    [self presentViewController:vc animated:YES completion:nil];

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
        
//        if (textField ==passwordOne) {
//            self.view.frame = CGRectMake(0, 0-100, SCREEN_WIDTH, SCREEN_HEIGHT-64) ;
//        }
        if (textField ==passwordTwo) {
            self.view.frame = CGRectMake(0, 0-100, SCREEN_WIDTH, SCREEN_HEIGHT-64) ;
        }
        if (textField ==getKey) {
            self.view.frame = CGRectMake(0, 0-150, SCREEN_WIDTH, SCREEN_HEIGHT-64) ;
        }

    } completion:nil];
    
 }

//结束编辑调用的方法
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        if (textField == passwordOne) {
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) ;
        }
        if (textField == passwordTwo) {
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) ;
        }
        if (textField == getKey) {
            self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) ;
        }
        
    } completion:nil];
    
 }

#pragma mark  点击背景键盘回收
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark 计时器运行事件
-(void)timeFireMethod{
    
    secondsCountDown--;
    int Checkseconds = secondsCountDown -1;
    
    //获取验证码的按钮title动态变化
    [requestKeyButton
     setTitle:[[NSString stringWithFormat:@"%d",Checkseconds] stringByAppendingString:@"秒后重发"]
     forState:UIControlStateNormal];
    
    //计时器停止
    if (secondsCountDown == 0) {
        
        [countDownTimer invalidate];                    //计时器失效
        
        //获取验证码按钮属性
        requestKeyButton.userInteractionEnabled=YES;
        requestKeyButton.alpha=1;
        [requestKeyButton
         setTitle:@"获取验证码"
         forState:UIControlStateNormal];
        
        secondsCountDown = 60;                          //回到赋值60
    }
    
}

#pragma mark - alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    NextViewController *vc = [[NextViewController alloc]init];
    
    vc.username = textFieldPhone.text;
    vc.password = passwordOne.text;
    vc.captcha = getKey.text;
    
    [self presentViewController:vc animated:NO completion:nil];
    
}

@end
