//
//  UserInfoViewController.m
//  RenRenATM
//
//
//
//个人信息




#import "UserInfoViewController.h"
#import "MustLogin.h"
#import "ownInfoViewController.h"
#import "CallServiesViewController.h"
//分享微信、QQ
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

 #import "forgotPass.h"                     //忘记密码
#import "ChengWeiFuWuZheViewController.h"   //成为服务者




#define TopViewHeight ((SCREEN_HEIGHT - 44)/10*3)



@interface UserInfoViewController ()<UIAlertViewDelegate>{

    NSString *dengluqianhou;                 //登录前后字符串
    UILabel *dengLuLabel;                    //登录显示Label
    UIImageView *AllImageView;
     NSString *service;                      //服务者身份

    IBOutlet UIView *whiteView;

    IBOutlet UILabel *puTongYonghu;
    
    IBOutlet UIButton *daGouButton;
    
}

@end

@implementation UserInfoViewController

#pragma mark - View 生命周期
-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    NSString *phoneNumber = [userDefault objectForKey:@"user_name"];
     //最上面的显示手机号码的判断
    if (access_token==nil) {
        dengLuLabel.text =@"点击登录人人银行";
    }
    else
    {
        dengLuLabel.text = phoneNumber;
    }

//    NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
//    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
 
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initinfo];                              //初始化用户信息
    
    [self initTopView];                           //初始化上面的界面
    
    [self initButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
#pragma mark - init Value
-(void)initinfo{

    [HTTP_Get_UserInfo setUserInfo:^(NSDictionary *dic) {
        
        NSDictionary *arr1 = dic;
        NSArray *Arr = arr1[@"roles"];
        if (Arr.count == 0) {
            
            service = @"";
            
        }else{
            
            service = Arr[0][@"name"];
            if ([service isEqual:[NSNull null]]) {
                
                service = @"";
                
            }
            
        }
        
        
    }];
    
    if ( [service isEqualToString:@"普通用户"] ) {
        
        
        
    }else{
       
        daGouButton.enabled = NO;
         
    }


}
#pragma mark - init Views
//初始化上面的界面
-(void)initTopView{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    NSString *phoneNumber = [userDefault objectForKey:@"user_name"];
    if (access_token==nil) {
        
        dengluqianhou =@"点击登录人人银行";
    
    }
    else{
        
        dengluqianhou =phoneNumber;
    
    }

    //灰色背景图片
    AllImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight) ];
    AllImageView.image = [UIImage imageNamed:@"RenRenGray"];
    [self.view addSubview:AllImageView];
    
    //顶部图片
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TopViewHeight)];
    topImageView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    AllImageView.userInteractionEnabled = YES;
    [self.view addSubview:topImageView];
    
    //顶部人人图标
    UIImageView *topAvatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -TopViewHeight/2)/2, TopViewHeight/4, TopViewHeight/2, TopViewHeight/2)];
    topAvatarImageView.image = [UIImage imageNamed:@"individual_user"];
    UITapGestureRecognizer * TapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Login)];
    topImageView.userInteractionEnabled = YES;
    topAvatarImageView.userInteractionEnabled = YES;
    [topAvatarImageView addGestureRecognizer:TapGestureRecognizer];
    [topImageView addSubview:topAvatarImageView];
    
    //点击登录人人ATM
    dengLuLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2, TopViewHeight/4*3, 150, TopViewHeight/4)];
    dengLuLabel.textColor = [UIColor whiteColor];
    dengLuLabel.backgroundColor = [UIColor clearColor];
    dengLuLabel.textAlignment =NSTextAlignmentCenter;
    dengLuLabel.text =dengluqianhou;
    [topImageView addSubview:dengLuLabel];
    
    //白色view
    UIImageView *baiSeBeiJingView = [[UIImageView alloc]init];
    baiSeBeiJingView.backgroundColor = [UIColor whiteColor];
    [AllImageView addSubview:baiSeBeiJingView];

}

-(void)initButton{

    //添加五个按钮
    for (int i = 0; i < 5; i ++) {
        
        BFPaperButton *wuGeButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT/568*44 + 2)*i, SCREEN_WIDTH, SCREEN_HEIGHT/568*44)];
        wuGeButton.backgroundColor = [UIColor clearColor];
        wuGeButton.tag = i;
        [wuGeButton addTarget:self action:@selector(liuGeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        wuGeButton.shadowColor = [UIColor clearColor];
        wuGeButton.tapCircleColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:0.8];
        [whiteView addSubview:wuGeButton];
        
    }
    
    BFPaperButton *loginOut = [[BFPaperButton alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT/568*44 + 2)*5 + 10, SCREEN_WIDTH, SCREEN_HEIGHT/568*44)];
    loginOut.backgroundColor = [UIColor clearColor];
    loginOut.shadowColor = [UIColor clearColor];
    loginOut.tag = 5;
    [loginOut addTarget:self action:@selector(liuGeButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    loginOut.tapCircleColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:0.8];
    [whiteView addSubview:loginOut];
 
    
}
#pragma mark - Button Click Action
-(void)Login{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    if (access_token==nil) {
        //        NSLog(@"123");
        MustLogin *Login = [[MustLogin alloc]init];
         [self presentViewController:Login animated:NO completion:nil];
    }
    else
    {
        
    }
    
}

//五个Button点击事件
-(void)liuGeButtonClickAction:(UIButton *)sender {
    
    NSUInteger clickTag = sender.tag;
    
    if ( clickTag == 0) {
 
        ownInfoViewController *vc = [[ownInfoViewController alloc]init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (clickTag == 1){
    
        [self doShare];          //分享功能
        
    }else if (clickTag == 2){
        
        //修改密码
        forgotPass *vc = [[forgotPass alloc]init];
        [self presentViewController:vc animated:NO completion:nil];
        
    }else if (clickTag == 3){
    
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"联系邮箱："
                                  message:@"rrbank@hzhanghuan.com"
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
        [alertView show];

        //联系客服
//        CallServiesViewController *vc = [[CallServiesViewController alloc]init];
//        [self presentViewController:vc animated:YES completion:nil];

    }else if (clickTag == 4){
        
        [self becomeServies];          //成为服务者
        
    }else if (clickTag == 5){
        
        [self loginOutAction];          //退出登录
    }

}

//分享功能
-(void)doShare{
    
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"图标.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享人人银行"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"https://itunes.apple.com/us/app/ren-renatm/id1091937247?mt=8"]
                                          title:@"人人是银行，处处可金融交易！"
                                           type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state,
                                         SSDKPlatformType platformType,
                                         NSDictionary *userData,
                                         SSDKContentEntity *contentEntity,
                                         NSError *error, BOOL end) {
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc]
                                                         initWithTitle:@"分享成功"
                                                         message:nil
                                                         delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc]
                                                     initWithTitle:@"分享失败"
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

//成为服务者
-(void)becomeServies{
    
    ChengWeiFuWuZheViewController *vc = [[ChengWeiFuWuZheViewController alloc]init];
    [self presentViewController:vc animated:nil completion:nil];
 
}

//退出登录
-(void)loginOutAction{

//    NSLog(@"您点击了退出登录");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定要退出吗"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [alert show];
    
}

//普通用户开启订单通知
- (IBAction)openOederPush:(UIButton *)sender {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *phoneNumber = [userDefault objectForKey:@"user_name"];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    
    NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    if ( sender.tag == 1) {
        
        sender.tag = 2;
        [sender setImage:[UIImage imageNamed:@"buxuanzhong"] forState:UIControlStateNormal];
             
        NSString * URL =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/user/order-status-change"];
            
            NSDictionary *parameters = @{@"username":phoneNumber,
                                         @"accept_status":@"0" };
        [session POST:URL
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
//                  NSLog(@"\n\n\n\n\n\n\n----------responseObject---------\n%@",responseObject);
                  
                  UIAlertView *notiAlert = [[UIAlertView alloc]
                                            initWithTitle:nil
                                            message:@"成功取消订单通知！"
                                            delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
                  
                  [notiAlert show];
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  UIAlertView *notiAlert = [[UIAlertView alloc]
                                            initWithTitle:nil
                                            message:@"网络连接失败！"
                                            delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
                  
                  [notiAlert show];
                  
              }];

        
    }else{
    
        sender.tag = 1;
        [sender setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        
        NSString * URL =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/user/order-status-change"];
        
        NSDictionary *parameters = @{@"username":phoneNumber,
                                     @"accept_status":@"1" };
        [session POST:URL
           parameters:parameters
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                  
//                  NSLog(@"\n\n\n\n\n\n\n----------responseObject---------\n%@",responseObject);

                  UIAlertView *notiAlert = [[UIAlertView alloc]
                                            initWithTitle:nil
                                            message:@"成功开启订单通知！"
                                            delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
                  
                  [notiAlert show];
                  
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  UIAlertView *notiAlert = [[UIAlertView alloc]
                                            initWithTitle:nil
                                            message:@"网络连接失败！"
                                            delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
                  
                  [notiAlert show];
                  
              }];

    }
    
}

#pragma mark -alertView回调函数
//alert的按钮
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 0){
        //            NSLog(@"您点击了取消");
    }
    else if(buttonIndex == 1)
    {
        //获取UserDefaults单例
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        
        //删除存储的用户信息
        [userDefault removeObjectForKey:@"user_name"];
        [userDefault removeObjectForKey:@"access_token"];
        [userDefault removeObjectForKey:@"user_id"];
        [userDefault removeObjectForKey:@"serviceType"];
        [userDefault synchronize];
        
        dengLuLabel.text =@"点击登录人人银行";

     }
    else
    {
        //        NSLog(@"退出登录未知错误");
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
