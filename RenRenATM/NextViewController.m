//
//  NextViewController.m
//  RenRenATM
//
//
//
//注册跳转页


#define a_x    ([[UIScreen mainScreen] bounds].size.width)/8

#import "NextViewController.h"
#import "BecomeServiceViewController.h"
#import "CenterViewController.h"

@interface NextViewController ()<UIAlertViewDelegate>{

    UILabel *rollingLabel;                  //滚动的label
    
    NSTimer *_time;                         //计时器
    
    int _x ;                                //初始化滚动label的值
    
    UIView *serviceView;                    //服务者背景view
    
    NSString *access_token,*user_id;
    
}

@end

@implementation NextViewController

@synthesize username,password,captcha;

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self initValue];                //初始化值
    
    [self initViews];                //初始化视图
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }

#pragma mark - init 初始值
-(void)initValue{

     _x = -SCREEN_WIDTH + a_x;
    
    _time = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(timeAction)
                                           userInfo:nil
                                            repeats:YES];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    access_token = [userDefault objectForKey:@"access_token"];
    user_id = [userDefault objectForKey:@"user_id"];


}

#pragma mark - init
-(void)initViews{

    //提示label
    rollingLabel = [[UILabel alloc ] initWithFrame:CGRectMake(-SCREEN_WIDTH+a_x, 150, SCREEN_WIDTH-_x * 2, 40)];
    rollingLabel.text = @"注册成功，正在为您跳转页面.....";
    [self.view addSubview:rollingLabel];
    
    //背景view
    serviceView = [[UIView alloc]initWithFrame:CGRectMake(a_x, 200, a_x*6, a_x*4)];
    serviceView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [self.view addSubview:serviceView];
    
    //成为服务者
    UILabel *becomeService = [[UILabel alloc]initWithFrame:CGRectMake(a_x/2, a_x/2, 150, a_x/2)];
    becomeService.text = @"成为服务者：";
    becomeService.font = [UIFont systemFontOfSize:20];
    becomeService.textColor = [UIColor whiteColor];
    [serviceView addSubview:becomeService];
    
    //条款
    UILabel * seriesLabel = [[UILabel alloc]initWithFrame:CGRectMake(a_x/2, a_x, a_x*5 , a_x)];
    seriesLabel.text = @"1.服务者有新的订单通知\n2.地图上随时显示位置和服务者信息";
    seriesLabel.font = [UIFont systemFontOfSize:11];
    seriesLabel.textColor = [UIColor whiteColor];
    seriesLabel.numberOfLines = 0;
    [serviceView addSubview:seriesLabel];
    
    //成为服务者按钮
    BFPaperButton*button1 = [[BFPaperButton alloc] initWithFrame:CGRectMake(a_x*0.2, a_x*2.5, a_x*2.5 , a_x)];
    [button1 setBackgroundColor:[UIColor whiteColor]];
    button1.titleLabel.numberOfLines = 0;
    button1.layer.cornerRadius =a_x;
    button1.shadowColor = [UIColor blackColor];
    [button1 setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    button1.cornerRadius = 15;
    [button1 setTitle:@"成为服务者" forState:UIControlStateNormal];
    [button1 setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [button1 addTarget:self action:@selector(goServies:) forControlEvents:UIControlEventTouchUpInside];
    [serviceView addSubview:button1];

    //不成为服务者
    BFPaperButton*button2 = [[BFPaperButton alloc] initWithFrame:CGRectMake(a_x*3.3 , a_x*2.5, a_x*2.5 , a_x)];
    [button2 setBackgroundColor:[UIColor whiteColor]];
    button2.titleLabel.numberOfLines = 0;
    button2.layer.cornerRadius =a_x;
    button2.shadowColor = [UIColor blackColor];
    [button2 setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    button2.cornerRadius = 15;
    [button2 setTitle:@"不成为服务者" forState:UIControlStateNormal];
    [button2 setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15.f]];
    [button2 addTarget:self action:@selector(isNotServies) forControlEvents:UIControlEventTouchUpInside];
    [serviceView addSubview:button2];

}

#pragma mark - button click action
//返回
- (IBAction)goBack:(id)sender {
    
    [_time invalidate];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//计时器
-(void)timeAction{

    _x+=SCREEN_WIDTH/8;
    
    
    if (rollingLabel.frame.origin.x >= SCREEN_WIDTH) {
        
        _x = -SCREEN_WIDTH;
        rollingLabel.frame = CGRectMake(_x+a_x,150, SCREEN_WIDTH-80, 40);

        NSLog(@"超过了");
        
    }else{

        [UIView animateWithDuration:1
                              delay:0 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             rollingLabel.frame = CGRectMake(_x,150, SCREEN_WIDTH-80, 40);
                         }
                         completion:nil];
        
    }
 
}

//成为服务者
-(void)goServies:(UIButton *)sender{

    [_time invalidate];
    
    BecomeServiceViewController *vc = [[BecomeServiceViewController alloc]init];
    
    vc.username = username;
    vc.password = password;
    vc.captcha = captcha;

    [self presentViewController:vc animated:NO completion:nil];


}

//不成为服务者
-(void)isNotServies{
    
    NSDictionary *parameters = @{@"username":username,
                                 @"password":password,
                                 @"password_repeat":password,
                                 @"captcha":captcha};
    
    NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/users"];
    NSString *test = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:test
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              UIAlertView *notiAlert = [[UIAlertView alloc]
                                        initWithTitle:@"欢迎使用人人银行！"
                                        message:nil
                                        delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
              [notiAlert show];
              
              NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
              [userDefaults setObject:responseObject[@"access_token"] forKey:@"access_token"];
              [userDefaults setObject:username forKey:@"user_name"];
              [userDefaults setObject:responseObject[@"user_id"]  forKey:@"user_id"];
              
          }
          failure:nil];

}

#pragma mark - alertView代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    CenterViewController * vc = [[CenterViewController alloc]init];
    [self presentViewController:vc animated:NO completion:nil];
    
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
