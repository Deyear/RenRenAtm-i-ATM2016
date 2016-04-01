//
//  AppDelegate.m
//  RenRenATM
//
//  Created by 方少言 on 15/12/22.
//  Copyright © 2015年 com.fsy. All rights reserved.
//
//#define LinkPageOne @"FirstBlood.png"
#define LinkPageOne @"yindao.png"
#define LinkPageTwo @"guide_2.jpg"
#define LinkPageThree @"guide_3.jpg"
#import "AppDelegate.h"
#import "CenterViewController.h"
#import <MAMapKit/MAMapServices.h>
@interface AppDelegate ()
{
    //滚动引导页
    UIScrollView *scrollView;
    //立即进入的按钮
    UIButton *enterBtn;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    NSLog(@"沙盒目录%@",NSHomeDirectory());
    [MAMapServices sharedServices].apiKey = @"fbce2befdad6e5d1da1d24e0ad720812";

    //初始化界面
    [self initView];
    //引导页
    [self yindaoye];
    return YES;
}
//初始化APP界面
-(void)initView
{
    //初始化UITabBarController 
    CenterViewController * centerViewController = [[CenterViewController alloc] init];
    //    //初始化UINavigationController继承UITabBarController
    //    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    //设置全屏
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //    初始化APP为导航加分页模式
    [self.window setRootViewController:centerViewController];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}


-(void)yindaoye
{
    //是否第一次登入app，第一次则进入引导页。
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
//        NSLog(@"第一次启动");
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        scrollView.bounces = NO;
        [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 0)];
        
        //视图整页显示
        [scrollView setPagingEnabled:YES];
        //避免弹跳效果,避免把根视图露出来
        [scrollView setBounces:NO];
       
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [imageview setImage:[UIImage imageNamed:LinkPageOne]];
        [scrollView addSubview:imageview];
     
        [self.window addSubview:scrollView];
        
        //“立即体验”按钮
        enterBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, SCREEN_HEIGHT - 35, 100, 30)];
        [enterBtn setTitle:@"立即体验" forState:UIControlStateNormal];
        [enterBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        enterBtn.backgroundColor = [UIColor clearColor];
        
        //第一次登录
        [enterBtn addTarget:self action:@selector(firstEnter) forControlEvents:UIControlEventTouchUpInside];
        
        //设置矩圆角半径
        [enterBtn.layer setMasksToBounds:YES];
        [enterBtn.layer setCornerRadius:10];
        //边框宽度
        [enterBtn.layer setBorderWidth:1.5];
        //边框颜色
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 1 });
        [enterBtn.layer setBorderColor:colorref];
        [self.window addSubview:enterBtn];
        
    }
    else
    {
//        NSLog(@"不是第一次启动");
    }
    
    
}

-(void)firstEnter
{
    [enterBtn removeFromSuperview];
    [scrollView removeFromSuperview];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
