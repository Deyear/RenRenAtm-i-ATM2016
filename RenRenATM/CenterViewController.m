//
//  CenterViewController.m
//  RenRenATM

//显示tableBar的主界面




#import "CenterViewController.h"
#define Jiedan @"接单"
#define Fadan @"发单"
#define Dingdan @"订单"
#define Fuwuzhe @"服务者"
#define Geren @"个人"

#define FirstImageBefore @"接单灰色"
#define FirstImageAfter @"接单蓝色"
#define SecondImageBefore @"发单灰色"
#define SecondImageAfter @"发单蓝色"
#define atmImageABefore @"订单灰色"
#define atmImageAfter @"订单蓝色"
#define ThirdImageBefore @"服务者灰色"
#define ThirdImageAfter @"服务者蓝色"
#define GeRenImageBefore @"个人灰色"
#define GeRenImageAfter @"个人蓝色"

#import "HomeVCTestViewController.h"
#import "FaDanViewController.h"
#import "SecondViewController.h"
#import "ThreeViewController.h"
#import "UserInfoViewController.h"




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
    
     FaDanViewController *fourthVC = [[FaDanViewController alloc] init];
    self.view.window.rootViewController =fourthVC;
    
    SecondViewController  *secondVC = [[SecondViewController alloc] init];
    self.view.window.rootViewController =secondVC;
  
    ThreeViewController *thirdVC = [[ThreeViewController alloc] init];
    self.view.window.rootViewController =thirdVC;

    UserInfoViewController *UserInfoVC = [[UserInfoViewController alloc]init];
    self.view.window.rootViewController =UserInfoVC;
    NSArray *navArray = @[firstVC,fourthVC,secondVC,thirdVC,UserInfoVC];
    [self setViewControllers:navArray animated:NO];
   
    //tabBar字体显示
    self.tabBar.tintColor=[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    
    //五个界面的点击变化icon状态
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        firstVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:Jiedan image:[[UIImage imageNamed:FirstImageBefore]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:FirstImageAfter]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        fourthVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:Fadan image:[[UIImage imageNamed:SecondImageBefore]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:SecondImageAfter]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        secondVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:Dingdan image:[[UIImage imageNamed:atmImageABefore]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:atmImageAfter]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        thirdVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:Fuwuzhe image:[[UIImage imageNamed:ThirdImageBefore]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:ThirdImageAfter]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

        UserInfoVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:Geren image:[[UIImage imageNamed:GeRenImageBefore]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:GeRenImageAfter]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    else
    {
        
        firstVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:Jiedan image:[UIImage imageNamed:FirstImageBefore] tag:101];
        fourthVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:Fadan image:[UIImage imageNamed:SecondImageBefore] tag:102];
        secondVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:Dingdan image:[UIImage imageNamed:atmImageABefore]  tag:103];
        thirdVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:Fuwuzhe image:[UIImage imageNamed:ThirdImageBefore] tag:104];
        UserInfoVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:Geren image:[UIImage imageNamed:GeRenImageBefore] tag:105];
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
