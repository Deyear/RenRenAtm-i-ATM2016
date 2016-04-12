//
//  SettingViewController.m
//  RenRenATM
//
//
//
//

#import "SettingViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
//立体控件————第三方
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置";
    [self.navigationController.navigationBar setTitleTextAttributes:
     
  @{NSFontAttributeName:[UIFont systemFontOfSize:17],
    
    NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"RenRenTabbar"] forBarMetrics:UIBarMetricsDefault];
    //导航条左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back-Small"] style:UIBarButtonItemStylePlain target:self action:@selector(BackView)];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    //全局背景图片
    UIImageView *AllImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    AllImageView.image = [UIImage imageNamed:@"RenRenGray"];
    AllImageView.userInteractionEnabled = YES;
    [self.view addSubview:AllImageView];
    
    
//    //构建view
//    //第一个view图片
//    UIImageView *zhanghuxiangqingView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44)];
//    zhanghuxiangqingView.backgroundColor = [UIColor whiteColor];
//    zhanghuxiangqingView.userInteractionEnabled = YES;
//    [self.view addSubview:zhanghuxiangqingView];
//    
//    UILabel *zhanghuxiangqingLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 100, 30)];
//    zhanghuxiangqingLabel.text = @"账户详情";
//    [zhanghuxiangqingView addSubview:zhanghuxiangqingLabel];
//    
//    UIImageView *zhanghuxiangqingrightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 37, 12, 20, 20)];
//    zhanghuxiangqingrightImageView.image = [UIImage imageNamed:@"right-Small"];
//    [zhanghuxiangqingView addSubview:zhanghuxiangqingrightImageView];
//    
//    UILabel *xianLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH-30, 1)];
//    xianLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
//    [zhanghuxiangqingView addSubview:xianLabel];
//
//    //下面五个用循环构建了
//    NSArray *shezhiArray = [NSArray arrayWithObjects:@"消息推送",@"清除缓存",@"意见反馈",@"关于",@"分享", nil];
//    for (int i = 0 ; i<5; i++) {
//        //第一个不一样
//        if (i==0) {
//            //第一个view图片
//            UIImageView *firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 44)];
//            firstImageView.backgroundColor = [UIColor whiteColor];
//            firstImageView.userInteractionEnabled = YES;
//            [self.view addSubview:firstImageView];
//            //第一个图片后面的设置按钮
//            //UISwitch的初始化
//            
//            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -60, 8.5, 59, 27)];
//            //设置UISwitch的初始化状态
//            
//            switchView.on = YES;//设置初始为ON的一边
//            //UISwitch事件的响应
//            switchView.onTintColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
//
//
//            [switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//            
//            
//         
//            [firstImageView addSubview:switchView];
//            
//            //一条线
//            UILabel *xianLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 43, SCREEN_WIDTH-30, 1)];
//            xianLabel.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.2];
//            [firstImageView addSubview:xianLabel];
//            //消息推送名字
//            UILabel *shezhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 100, 30)];
//            shezhiLabel.text = shezhiArray[i];
//            [firstImageView addSubview:shezhiLabel];
//            
//        }
//        else
//        {
//            //构建四个view
//        UIImageView *FourImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 108 + 54*(i-1), SCREEN_WIDTH, 44)];
//        FourImageView.backgroundColor = [UIColor whiteColor];
//        [self.view addSubview:FourImageView];
//            //四个title
//            UILabel *shezhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 100, 30)];
//            shezhiLabel.text = shezhiArray[i];
//            [FourImageView addSubview:shezhiLabel];
//            //做缓存大小的
//            if (i==1) {
//                UILabel *sizeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-115, 7, 100, 30)];
//                sizeLabel.text = @"1.3M";
//                sizeLabel.textColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
//                sizeLabel.textAlignment = NSTextAlignmentRight;
//                [FourImageView addSubview:sizeLabel];
//
//            }
//          //三个右箭头
//        if (i>1) {
//            UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 37, 12, 20, 20)];
//            rightImageView.image = [UIImage imageNamed:@"right-Small"];
//            [FourImageView addSubview:rightImageView];
//
//        }
//        }
//        
//        
//
//    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    if (access_token==nil) {

    }
    else
    {

        
//        分享
        //其它金额button
        CGRect frame = CGRectMake(15, 30, SCREEN_WIDTH - 30, 44);
        HTPressableButton *fenXiangButon = [[HTPressableButton alloc] initWithFrame:frame buttonStyle:HTPressableButtonStyleRounded];
        fenXiangButon.buttonColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
        fenXiangButon.shadowColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:0.8];
        [fenXiangButon setTitle:@"分享" forState:UIControlStateNormal];
        [fenXiangButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        fenXiangButon.userInteractionEnabled = YES;
        fenXiangButon.layer.masksToBounds = YES;
        fenXiangButon.layer.cornerRadius = 5;
        [fenXiangButon addTarget:self action:@selector(fenXiang) forControlEvents:UIControlEventTouchUpInside];
        [AllImageView addSubview:fenXiangButon];
        
        
        //退出登录按钮
        CGRect frame1 = CGRectMake(15, 100, SCREEN_WIDTH - 30, 44);
        HTPressableButton *logoffButon = [[HTPressableButton alloc] initWithFrame:frame1 buttonStyle:HTPressableButtonStyleRounded];
        logoffButon.buttonColor = [UIColor colorWithRed:255.0f/255.0f green:78.0f/255.0f blue:73.0f/255.0f alpha:1];
        logoffButon.shadowColor = [UIColor colorWithRed:255.0f/255.0f green:78.0f/255.0f blue:73.0f/255.0f alpha:0.8];
        [logoffButon setTitle:@"退出登录" forState:UIControlStateNormal];
        [logoffButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        logoffButon.userInteractionEnabled = YES;
        logoffButon.layer.masksToBounds = YES;
        logoffButon.layer.cornerRadius = 5;
        [logoffButon addTarget:self action:@selector(logoff) forControlEvents:UIControlEventTouchUpInside];
        [AllImageView addSubview:logoffButon];
    }


}
//返回主界面
-(void)BackView
{
[self dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//UISwitch操作
-(void)switchAction:(UISwitch*)sender
{

    UISwitch *myswitch = (UISwitch *)sender;
    if (myswitch.isOn) {
        NSLog(@"开");
        [myswitch setOnImage:[UIImage imageNamed:@"RenRenBack"]];
    }
    else {
        NSLog(@"关");

        [myswitch setOffImage:[UIImage imageNamed:@"RenRenBack"]];
    }
}
//退出登录操作
-(void)logoff
{
    NSLog(@"您点击了退出登录");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定要退出吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
//alert的按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    

        if(buttonIndex == 0){
            NSLog(@"您点击了取消");
        }
        else if(buttonIndex == 1)
        {
            NSLog(@"您点击了确定");
            //获取UserDefaults单例
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            
            [userDefault removeObjectForKey:@"user_name"];
            [userDefault removeObjectForKey:@"access_token"];
            [userDefault removeObjectForKey:@"user_id"];
            [userDefault synchronize];
            
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    else
    {
        NSLog(@"退出登录未知错误");
    }
}

-(void)fenXiang
{
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"图标.png"]];
//    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享人人ATM"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/ren-renatm/id1091937247?mt=8"]
                                          title:@"人人是ATM机，处处可金融交易！"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];

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

@end
