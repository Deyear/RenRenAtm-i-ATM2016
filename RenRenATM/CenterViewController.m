//
//  CenterViewController.m
//  RenRenATM

//显示tableBar的主界面




#import "CenterViewController.h"
#define FirstTitle @"接单"
#define SecondTitle @"订单"
#define ThirdTitle @"附近ATM"
#define FourthTitle @"个人"
#define ATMFuWuZhe @"服务者"
#define FirstImageBefore @"接单1"
#define FirstImageAfter @"接单2"
#define SecondImageBefore @"订单1"
#define SecondImageAfter @"订单2"
#define ThirdImageBefore @"附近ATM1"
#define ThirdImageAfter @"附近ATM2"
#define FourthImageBefore @"个人1"
#define FourthImageAfter @"个人2"
#define atmImageABefore @"服务者1"
#define atmImageAfter @"服务者2"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "HomeVCTestViewController.h"
#import "zhongJianView.h"



@interface CenterViewController ()

@end


@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self FiveViewController];
}


//加载四个主界面
-(void)FiveViewController
{
    //初始化五个界面
    HomeVCTestViewController *firstVC = [[HomeVCTestViewController alloc] init];
    self.view.window.rootViewController =firstVC;
    SecondViewController  *secondVC = [[SecondViewController alloc] init];
    self.view.window.rootViewController =secondVC;
    ThreeViewController *thirdVC = [[ThreeViewController alloc] init];
    self.view.window.rootViewController =thirdVC;
    FourViewController *fourthVC = [[FourViewController alloc] init];
    self.view.window.rootViewController =fourthVC;
    zhongJianView *_Atm = [[zhongJianView alloc]init];
    self.view.window.rootViewController =_Atm;
    NSArray *navArray = @[firstVC,secondVC,_Atm,thirdVC,fourthVC];
    [self setViewControllers:navArray animated:NO];
   
    //tabBar字体显示
    self.tabBar.tintColor=[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    
    //五个界面的点击变化icon状态
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        firstVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:FirstTitle image:[[UIImage imageNamed:FirstImageBefore]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:FirstImageAfter]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        secondVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:SecondTitle image:[[UIImage imageNamed:SecondImageBefore]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:SecondImageAfter]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        thirdVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:ThirdTitle image:[[UIImage imageNamed:ThirdImageBefore]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:ThirdImageAfter]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        fourthVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:FourthTitle image:[[UIImage imageNamed:FourthImageBefore]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:FourthImageAfter]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        _Atm.tabBarItem = [[UITabBarItem alloc]initWithTitle:ATMFuWuZhe image:[[UIImage imageNamed:atmImageABefore]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:atmImageAfter]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    else
    {
        fourthVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:FourthTitle image:[UIImage imageNamed:FourthImageBefore] tag:101];
        thirdVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:ThirdTitle image:[UIImage imageNamed:ThirdImageBefore] tag:102];
        secondVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:SecondTitle image:[UIImage imageNamed:SecondImageBefore]  tag:103];
        firstVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:FirstTitle image:[UIImage imageNamed:FirstImageBefore] tag:104];
        _Atm.tabBarItem = [[UITabBarItem alloc]initWithTitle:ATMFuWuZhe image:[UIImage imageNamed:atmImageABefore] tag:105];
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
