

#import "MustLogin.h"
#import "ZhuCeViewController.h"
#import "forgotPass.h"
#import "AFNetworking.h"
#import "CenterViewController.h"

@interface MustLogin ()<UITextFieldDelegate>{
    
    IBOutlet UIView *topView;
    
    LRTextField *shoujihaoFeild,*mimaFeild;
    UIAlertView *dengluchenggongAlert;

}

@end


@implementation MustLogin

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self initTopView];     //最上面的view
    
     [self viewInit];       //构造界面整体背景
    
}

#pragma mark - init
-(void)initTopView{

    //最上面的颜色
    topView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    
}

//构建主界面
-(void)viewInit{
    
    //灰色背景
    UIImageView *gray = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH , SCREEN_HEIGHT-64)];
    gray.image = [UIImage imageNamed:@"RenRenGray"];
    [self.view addSubview:gray];
    
    //白色背景
    UIImageView *white = [[UIImageView alloc]initWithFrame:CGRectMake(0, 94,SCREEN_WIDTH , 100)];
    white.userInteractionEnabled = YES;
    white.image = [UIImage imageNamed:@"baise"];
    [self.view addSubview:white];
    
    //手机号label
    UILabel *shoujihaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 60, 24)];
    shoujihaoLabel.text =@"手机号";
    [white addSubview:shoujihaoLabel];
    
    //“手机号”和“密码”之间的横线
    UIView *xianLabel = [[UIView alloc]initWithFrame:CGRectMake(15, 50,SCREEN_WIDTH-15, 1)];
    xianLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    [white addSubview:xianLabel];
    
    //密码label
    UILabel *mimaLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 66, 60, 24)];
    mimaLabel.text =@"密码";
    [white addSubview:mimaLabel];
    
    //请输入手机号TextField
    shoujihaoFeild = [[LRTextField alloc]initWithFrame:CGRectMake(100, 16, SCREEN_WIDTH -120, 24)];
    shoujihaoFeild.placeholder = @"请输入手机号";
    shoujihaoFeild.borderStyle = UITextBorderStyleNone;
    shoujihaoFeild.delegate = self;
    [white addSubview:shoujihaoFeild];
    
    //请输入密码TextField
    mimaFeild = [[LRTextField alloc]initWithFrame:CGRectMake(100, 66, SCREEN_WIDTH -120, 24)];
    mimaFeild.placeholder = @"请输入密码";
    mimaFeild.borderStyle = UITextBorderStyleNone;
    mimaFeild.delegate = self;
    mimaFeild.secureTextEntry = YES;
    [white addSubview:mimaFeild];
    
    //登录按钮
    BFPaperButton *dengluButon = [[BFPaperButton alloc]initWithFrame:CGRectMake(15, white.frame.origin.y + white.frame.size.height + 80, SCREEN_WIDTH - 30, 44)];
    [dengluButon setTitle:@"登录" forState:UIControlStateNormal];
    [dengluButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    dengluButon.layer.masksToBounds = YES;
    dengluButon.layer.cornerRadius = 5;
    dengluButon.cornerRadius = 5;
    dengluButon.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [dengluButon addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dengluButon];
    
    //“注册人人ATM”按钮
    BFPaperButton *zhuceButon = [[BFPaperButton alloc]initWithFrame:CGRectMake(0, dengluButon.frame.origin.y + dengluButon.frame.size.height + 10, SCREEN_WIDTH/2 -20, 44)];
    [zhuceButon setTitle:@"注册人人ATM" forState:UIControlStateNormal];
    [zhuceButon setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    zhuceButon.titleLabel.font = [UIFont systemFontOfSize:15];
    zhuceButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    zhuceButon.backgroundColor = [UIColor clearColor];
    zhuceButon.shadowColor = [UIColor clearColor];
    [zhuceButon addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zhuceButon];
    
    //“注册人人ATM”和“忘记密码”之间的竖线
    UIView *shuxianLabel = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, dengluButon.frame.origin.y + dengluButon.frame.size.height + 24,1, 15)];
    shuxianLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
    [self.view addSubview:shuxianLabel];
    
    //忘记密码
    BFPaperButton *wangjimimaButon = [[BFPaperButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 +20, dengluButon.frame.origin.y + dengluButon.frame.size.height + 10, SCREEN_WIDTH/2 -20, 44)];
    [wangjimimaButon setTitle:@"忘记密码" forState:UIControlStateNormal];
    [wangjimimaButon setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    wangjimimaButon.titleLabel.font = [UIFont systemFontOfSize:15];
    wangjimimaButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    wangjimimaButon.backgroundColor = [UIColor clearColor];
    wangjimimaButon.shadowColor = [UIColor clearColor];
    [wangjimimaButon addTarget:self action:@selector(wangjimima) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wangjimimaButon];
    
}


//登录操作
-(void)loginAction:(UIButton *)sender
{
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        sender.backgroundColor = [UIColor blackColor];
        sender.alpha = 0.5;
        
        [UIView animateKeyframesWithDuration:0.1 delay:0.2 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            sender.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
            sender.alpha = 1;
        } completion:nil];
    } completion:^(BOOL finished) {
        
    }];
    
    if ([shoujihaoFeild.text isEqualToString:@""] ==true) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"手机号不能为空"delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([mimaFeild.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请正确填写密码"delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/auth/authorize"];
        NSDictionary *parameters = @{@"username":shoujihaoFeild.text,
                                     @"password":mimaFeild.text};
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //            NSLog(@"formData%@",formData);
        } progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"responseObject%@",responseObject);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"登录成功"
                                                          delegate:self
                                                 cancelButtonTitle:@"确认"
                                                 otherButtonTitles:nil, nil];
            dengluchenggongAlert = alert;
            [alert show];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            
            [userDefaults removeObjectForKey:@"access_token"];
            [userDefaults removeObjectForKey:@"user_name"];
            [userDefaults removeObjectForKey:@"user_id"];
            [userDefaults removeObjectForKey:@"password"];

            [userDefaults setObject:responseObject[@"access_token"] forKey:@"access_token"];
            [userDefaults setObject:shoujihaoFeild.text forKey:@"user_name"];
            [userDefaults setObject:responseObject[@"user_id"]  forKey:@"user_id"];
            [userDefaults setObject:mimaFeild.text forKey:@"password"];

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        }];
        
    }
}


//跳转到注册界面
-(void)zhuce
{
    ZhuCeViewController *vc = [[ZhuCeViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
//跳转到忘记密码界面
-(void)wangjimima
{
    forgotPass *forget = [[forgotPass alloc]init];
//    [self.navigationController pushViewController:forget animated:NO];
    [self presentViewController:forget animated:YES completion:nil];
}
#pragma mark 导航条返回事件
-(void)BackView
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
//alert的按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if( alertView==dengluchenggongAlert ){

        if(buttonIndex == 0){
 
//            [self dismissViewControllerAnimated:NO completion:nil];
            
            CenterViewController *vc = [[CenterViewController alloc]init];
            [self presentViewController:vc animated:NO completion:nil];
        }
//        else
//        {
//            //            NSLog(@"😳");
//        }
    }
}



//返回按钮
- (IBAction)goBack:(id)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
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

@end
