//  Copyright © 2015年 com.fsy. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPassViewController.h"
#import "AFNetworking.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *shoujihaoFeild,*mimaFeild;
    UIAlertView *dengluchenggongAlert;
}
@end


@implementation LoginViewController
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self topView];        //视图最上面的显示
    [self viewInit];       //构造界面整体背景
}


//视图最上面的显示
-(void)topView
{
    //LoginViewController的页头“登录”
    self.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:17],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"RenRenTabbar"] forBarMetrics:UIBarMetricsDefault];
    
    //导航条左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-Small"] style:UIBarButtonItemStylePlain target:self action:@selector(BackView)];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}


//构建主界面
-(void)viewInit
 {
     //灰色背景
     UIImageView *gray = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT-64)];
     gray.image = [UIImage imageNamed:@"RenRenGray"];
                   [self.view addSubview:gray];
     
     //白色背景
     UIImageView *white = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30,SCREEN_WIDTH , 88)];
     white.userInteractionEnabled = YES;
     white.image = [UIImage imageNamed:@"baise"];
     [self.view addSubview:white];
     
     //手机号label
     UILabel *shoujihaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 60, 24)];
     shoujihaoLabel.text =@"手机号";
     [white addSubview:shoujihaoLabel];
     
     //“手机号”和“密码”之间的横线
     UIView *xianLabel = [[UIView alloc]initWithFrame:CGRectMake(15, 44,SCREEN_WIDTH-15, 1)];
     xianLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
     [white addSubview:xianLabel];
     
     //密码label
     UILabel *mimaLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 54, 60, 24)];
     mimaLabel.text =@"密码";
     [white addSubview:mimaLabel];
     
     //请输入手机号TextField
     shoujihaoFeild = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, SCREEN_WIDTH -120, 24)];
     shoujihaoFeild.placeholder = @"请输入手机号";
     shoujihaoFeild.delegate = self;
     [white addSubview:shoujihaoFeild];
     
     //请输入密码TextField
     mimaFeild = [[UITextField alloc]initWithFrame:CGRectMake(100, 54, SCREEN_WIDTH -120, 24)];
     mimaFeild.placeholder = @"请输入密码";
     mimaFeild.delegate = self;
     mimaFeild.secureTextEntry = YES;
     [white addSubview:mimaFeild];
     
     //登录按钮
     UIButton *dengluButon = [[UIButton alloc]initWithFrame:CGRectMake(15, white.frame.origin.y + white.frame.size.height + 80, SCREEN_WIDTH - 30, 44)];
     [dengluButon setTitle:@"登录" forState:UIControlStateNormal];
     [dengluButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     dengluButon.layer.masksToBounds = YES;
     dengluButon.layer.cornerRadius = 5;
     dengluButon.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
     [dengluButon addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:dengluButon];
     
     //“注册人人ATM”按钮
     UIButton *zhuceButon = [[UIButton alloc]initWithFrame:CGRectMake(0, dengluButon.frame.origin.y + dengluButon.frame.size.height + 10, SCREEN_WIDTH/2 -20, 44)];
     [zhuceButon setTitle:@"注册人人ATM" forState:UIControlStateNormal];
     [zhuceButon setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
     zhuceButon.titleLabel.font = [UIFont systemFontOfSize:15];
     zhuceButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
     zhuceButon.backgroundColor = [UIColor clearColor];
     [zhuceButon addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
     [self.view addSubview:zhuceButon];
     
     //“注册人人ATM”和“忘记密码”之间的竖线
     UIView *shuxianLabel = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, dengluButon.frame.origin.y + dengluButon.frame.size.height + 24,1, 15)];
     shuxianLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
     [self.view addSubview:shuxianLabel];
     
     //忘记密码
     UIButton *wangjimimaButon = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 +20, dengluButon.frame.origin.y + dengluButon.frame.size.height + 10, SCREEN_WIDTH/2 -20, 44)];
     [wangjimimaButon setTitle:@"忘记密码" forState:UIControlStateNormal];
     [wangjimimaButon setTitleColor:[UIColor colorWithWhite:0.3 alpha:0.3] forState:UIControlStateNormal];
     wangjimimaButon.titleLabel.font = [UIFont systemFontOfSize:15];
     wangjimimaButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     wangjimimaButon.backgroundColor = [UIColor clearColor];
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
//        sender.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
//        sender.alpha = 1;
  
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
        NSDictionary *parameters = @{@"username":shoujihaoFeild.text,@"password":mimaFeild.text};
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        [session POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //            NSLog(@"formData%@",formData);
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //            NSLog(@"uploadProgress%@",uploadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //            NSLog(@"responseObject%@",responseObject);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"登录成功"delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            dengluchenggongAlert = alert;
            [alert show];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:responseObject[@"access_token"] forKey:@"access_token"];
            [userDefaults setObject:shoujihaoFeild.text forKey:@"user_name"];
            [userDefaults setObject:responseObject[@"user_id"]  forKey:@"user_id"];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                        NSLog(@"======error=========%@",error);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"手机号码或密码输入错误，\n请重新输入！"delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            dengluchenggongAlert = alert;
            [alert show];
        }];
    }
}


//跳转到注册界面
-(void)zhuce
{
    RegisterViewController *reg = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:reg animated:NO];
}
//跳转到忘记密码界面
-(void)wangjimima
{
    ForgetPassViewController *forget = [[ForgetPassViewController alloc]init];
    [self.navigationController pushViewController:forget animated:NO];
}
#pragma mark 导航条返回事件
-(void)BackView
{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
//alert的按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if( alertView==dengluchenggongAlert )
    {
        //NSLog(@"alert1 button index=%ld is clicked.....", (long)buttonIndex);
        if(buttonIndex == 0){
//            NSLog(@"0");
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        else
        {
//            NSLog(@"😳");
        }
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
