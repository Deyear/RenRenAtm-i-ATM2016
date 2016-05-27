//
//  AppDelegate.m
//  RenRenATM
//
//
//
//
//
#define LinkPageOne @"LaunchImage6P.png"
#define LinkPageTwo @"guide_2.jpg"
#define LinkPageThree @"guide_3.jpg"
#import "AppDelegate.h"
#import "CenterViewController.h"
#import <MAMapKit/MAMapServices.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

////微信SDK头文件

#import "WeiboSDK.h"                           //新浪微博SDK头文件

#import <ShareSDKConnector/ShareSDKConnector.h>//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

#import "WXApi.h"                              //微信SDK头文件

#import <AdSupport/AdSupport.h>                //极光推送



@interface AppDelegate ()
{
    //滚动引导页
    UIScrollView *scrollView;
    //立即进入的按钮
    UIButton *enterBtn;
    
    NSString *user_id;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [MAMapServices sharedServices].apiKey = @"fbce2befdad6e5d1da1d24e0ad720812";

    [self initView];       //初始化界面
    
    [self yindaoye];       //引导页
    
    [self initAllBeforeInfo];  //得到用户的信息
    
 
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    user_id = [userDefault objectForKey:@"user_id"];
 
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];

}


- (void)applicationWillTerminate:(UIApplication *)application {

}

 //此时app在前台运行，我的做法是弹出一个alert，告诉用户有一条推送，用户可以选择查看或者忽略
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    NSLog(@"\n+++++++收到通知+++++++:%@", [self logDic:userInfo]);
    
    if (application.applicationState != UIApplicationStateActive) {
        
        //        [self presentViewControllerWithUserInfo:userInfo];
        
        NSLog(@"-------将来跳转-------------");
        
    }

     if([UIApplication sharedApplication].applicationState == UIApplicationStateActive){
         
         UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                         message:@"人人银行有一条未读信息"
                                                        delegate:nil
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"查看",nil];
        [alert show];
        
    }
 
    //app icon 右上角的红色数字标志.
    [UIApplication sharedApplication].applicationIconBadgeNumber  =  0;
    completionHandler(UIBackgroundFetchResultNewData);

    
}

//注册上传手机号
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];
    
     //获取用户的电话号码
    NSUserDefaults * userDefault =[NSUserDefaults standardUserDefaults];
    NSString *name = [userDefault objectForKey:@"user_name"];
    
    [JPUSHService setTags:[NSSet setWithObjects:@"用户号码",nil]
                    alias:name
         callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                   object:self];

    [JPUSHService setTags:[NSSet setWithObjects:@"用户号码",nil]
        aliasInbackground:name];
    
    NSLog(@"deviceToken%@\n", [NSString stringWithFormat:@"设备令牌: %@", deviceToken]);
    NSLog(@"JPUSHService registrationID:%@",[JPUSHService registrationID]);


}

//设置别名（alias）与标签（tags）回掉函数。
-(void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias{
    
    NSLog(@"rescode: %d, \n标签: %@, \n别名: %@\n", iResCode, tags , alias);

}



//APNs 通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    
//    // IOS 7 Support Required
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"\ndid Fail To Register For Remote Notifications With Error: %@\n", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

 - (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
}

 - (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
}
#endif


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
}

 - (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

#pragma mark - init 

//得到用户的信息
-(void)initAllBeforeInfo{
    
    [HTTP_Get_UserInfo setUserInfo:^(NSDictionary *dic) {
        
        NSDictionary *arr1 = dic;
        NSArray *Arr = arr1[@"roles"];
        NSString * service =[[NSString alloc] init];
        if (Arr.count == 0) {
            
            service = @"";
            
        }else{
            
            service = Arr[0][@"name"];
            if ([service isEqual:[NSNull null]]) {
                
                service = @"";
                
            }
            
        }
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                
        [userDefaults setObject:service forKey:@"serviceType"];
        
    }];
    
}

//初始化APP界面
-(void)initView
{
    //初始化UITabBarController
    CenterViewController * centerViewController = [[CenterViewController alloc] init];
    //设置全屏
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     [self.window setRootViewController:centerViewController];
     self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    [ShareSDK registerApp:@"1179caf0bf21c"
     
     //     微信平台，qq平台
          activePlatforms:@[
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxb0dbf99dfdae906e"
                                       appSecret:@"16276e229af30d8138b76118a02f92a4"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105324014"
                                      appKey:@"XtLb782mgHS6GDev"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
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
        enterBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, SCREEN_HEIGHT - 80, 100, 30)];
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






//-------------------------------------------------------------------------------

 - (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    
    application.applicationIconBadgeNumber = 0;
    
}

//应用内消息
 - (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    
 }







@end
