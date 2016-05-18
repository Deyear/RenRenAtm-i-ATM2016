//
//  FaDanViewController.m
//  RenRenATM
//
//
//
//发单
#define APIKEY  (@"6bec592d15603e556999915510e4bd6e")

#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>


#import "FaDanViewController.h"
#import "xinyongkaquxianViewController.h"
#import "WaiHuiViewController.h"
#import "KuaiDiViewController.h"

@interface FaDanViewController ()<UIScrollViewDelegate,AMapSearchDelegate,AMapNearbySearchManagerDelegate>{
    
    UIScrollView * scrollViewUpToBottom;                    //背景滚动视图
    
    UIImageView *top1ImageView;                             //背景图片
    
    BFPaperButton *FiveBt;                                  //下面五个button
    
    UIImageView *ThreeView;                                 //ScrollView的容量大小
    
    xinyongkaquxianViewController *quxian;                  //详情页面

    AMapSearchAPI*_search;
    AMapNearbySearchManager*nearbyManager;
    NSString *user_id;
    float currentLatitude,currentLongtitude;
}

@end

@implementation FaDanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBackView];                           //初始化背景滚动视图
    
    [self aboveFourButton];                        //上面四个button
    
    [self followingFiveButton];                    //下面五个button
    
    [self initAlertLabel];                         //警告label
    
    [self geTiservice];
    
}

-(void)geTiservice{

    //2D栅格地图配置用户Key
    [AMapSearchServices sharedServices].apiKey = APIKEY;
    [MAMapServices sharedServices].apiKey =APIKEY;
    [AMapLocationServices sharedServices].apiKey = APIKEY;
    
    _search = [[AMapSearchAPI alloc] init];            //初始化检索对象
    _search.delegate = self;
    
    nearbyManager = [AMapNearbySearchManager sharedInstance];   //附近搜索功能
    nearbyManager.delegate = self;
    

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    user_id = [userDefault objectForKey:@"user_id"];
    currentLatitude = [userDefault floatForKey:@"currentLatitude"];
    currentLongtitude = [userDefault floatForKey:@"currentLongtitude"];
    NSString *service = [userDefault objectForKey:@"serviceType"];
    
    
    
    
        [self initGetGeTiLocation];         //得到附近的个体服务者的位置
        
 
}

 //得到附近的个体服务者的位置
-(void)initGetGeTiLocation{
    
    //    构造AMapNearbySearchRequest对象，配置周边搜索参数
    AMapNearbySearchRequest *request = [[AMapNearbySearchRequest alloc] init];
    
    request.center = [AMapGeoPoint locationWithLatitude:39.001 longitude:114.002];//中心点
    request.radius = 10000;                                    //搜索半径
    request.timeRange = 5;                                 //查询的时间
    request.searchType = AMapNearbySearchTypeDriving;           //直线距离
     [_search AMapNearbySearch:request];
    
    NSLog(@"\n\n中心%@\n\n",request.center);
}


-(void)initNearbyLocation{
    
    if (nearbyManager.isAutoUploading){
        
        [nearbyManager stopAutoUploadNearbyInfo];//关闭自动上传
        
    }
    else{
        
        [nearbyManager startAutoUploadNearbyInfo];//开启自动上传
        
    }
    
}



#pragma mark - init views
-(void)initBackView{

    scrollViewUpToBottom =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    //设置容量
    scrollViewUpToBottom.userInteractionEnabled = YES;
    scrollViewUpToBottom.bounces = NO;
    scrollViewUpToBottom.showsVerticalScrollIndicator = FALSE;
    scrollViewUpToBottom.showsHorizontalScrollIndicator = FALSE;
    scrollViewUpToBottom.backgroundColor =[UIColor clearColor];
    scrollViewUpToBottom.delegate = self;
    [self.view addSubview:scrollViewUpToBottom];
    
    
}

//上面四个button
-(void)aboveFourButton{

    NSArray *twoAndtwoArray = [NSArray arrayWithObjects:@"钱包",@"住",@"23",@"外汇", nil];
    NSArray *twoAndtwoNameArray = [NSArray arrayWithObjects:@"信用卡取现",@"银行卡取现",@"代收款",@"我要换外汇", nil];
    NSArray *twoAndtwoContentArray = [NSArray arrayWithObjects:@"贷款取现、便捷",@"取现、快人一步",@"有事、离不开身",@"外汇、轻松掌握", nil];
    
    for (int i = 0; i<4; i++) {
        UIButton *TwoAndTwoView = [[UIButton alloc] initWithFrame:CGRectMake(10 +(i%2)*(SCREEN_WIDTH -20)/2,(i/2)*(TwoAndTwoViewHeight + 4) , (SCREEN_WIDTH -20)/2, TwoAndTwoViewHeight+4)];
        [TwoAndTwoView addTarget:self action:@selector(fabu:) forControlEvents:UIControlEventTouchUpInside];
        TwoAndTwoView.backgroundColor  = [UIColor whiteColor];
        TwoAndTwoView.tag = i+101;
        [scrollViewUpToBottom addSubview:TwoAndTwoView];
        
        //加图片 名字 内容
        //图片
        UIImageView *fourView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/15, TwoAndTwoViewHeight/4, TwoAndTwoViewHeight/2, TwoAndTwoViewHeight/2)];
        fourView.image = [UIImage imageNamed:twoAndtwoArray[i]];
        [TwoAndTwoView addSubview:fourView];
        //名字
        UILabel *fourLabel = [[UILabel alloc]initWithFrame:CGRectMake(fourView.frame.origin.x + fourView.frame.size.width + 5, TwoAndTwoViewHeight/4, SCREEN_WIDTH/2 - SCREEN_WIDTH/24*3 -TwoAndTwoViewHeight/2 , TwoAndTwoViewHeight/4)];
        fourLabel.text = twoAndtwoNameArray[i];
        fourLabel.font = [UIFont systemFontOfSize: 15];
        [TwoAndTwoView addSubview:fourLabel];
        //内容
        UILabel *fourContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(fourView.frame.origin.x + fourView.frame.size.width + 5, TwoAndTwoViewHeight/2+5, SCREEN_WIDTH/2 - SCREEN_WIDTH/24*3 -TwoAndTwoViewHeight/2 , TwoAndTwoViewHeight/4)];
        fourContentLabel.text = twoAndtwoContentArray[i];
        fourContentLabel.textColor = [UIColor darkGrayColor];
        fourContentLabel.font = [UIFont systemFontOfSize: 11];
        [TwoAndTwoView addSubview:fourContentLabel];
        
    }
    
}

//下面五个button
-(void)followingFiveButton{
    
    NSArray *FourIconArray = [NSArray arrayWithObjects:@"存钱",@"人",@"快",@"零钱", @"挣钱",nil];
    NSArray *FourNameArray = [NSArray arrayWithObjects:@"我要存钱",@"我要转账",@"我的快递",@"我要换零钱",@"我要换整钱", nil];
    
    for (int i = 0; i<5; i++) {
 
        FiveBt =[[BFPaperButton alloc]initWithFrame:CGRectMake(10 + i * (5 + (SCREEN_WIDTH-40)/5),30 + 2 * TwoAndTwoViewHeight , (SCREEN_WIDTH-40)/5, (SCREEN_WIDTH-40)/5)];
        FiveBt.backgroundColor = [UIColor whiteColor];
        FiveBt.tapCircleColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:0.5];
        FiveBt.shadowColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
        FiveBt.rippleFromTapLocation = NO;
        FiveBt.rippleBeyondBounds = YES;

        FiveBt.tapCircleDiameter = MAX(FiveBt.frame.size.width, FiveBt.frame.size.height) * 1.3;
        [FiveBt addTarget:self action:@selector(fabu:) forControlEvents:UIControlEventTouchUpInside];
        [scrollViewUpToBottom addSubview:FiveBt];
         FiveBt.tag = i+105;
        
//        //fouricon
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((fourViewHeight - TwoAndTwoViewHeight/2)/2,fourViewHeight/8, fourViewHeight/2, fourViewHeight/2)];
        imageView.image =[UIImage imageNamed:FourIconArray[i]] ;
        [FiveBt addSubview:imageView];
        //fourLabel
        UILabel *fourLabel = [[UILabel alloc]initWithFrame:CGRectMake(fourViewHeight/12, fourViewHeight * 3/4, fourViewHeight/6*5 , fourViewHeight/4)];
        fourLabel.text = FourNameArray[i];
        fourLabel.font = [UIFont systemFontOfSize: 14];
        fourLabel.adjustsFontSizeToFitWidth = YES;
        fourLabel.textAlignment = NSTextAlignmentCenter;
        fourLabel.textColor = [UIColor darkGrayColor];
        [FiveBt addSubview:fourLabel];
        
    }

}

//提示信息
-(void)initAlertLabel{
    
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 250, 40 + 2 * TwoAndTwoViewHeight + (SCREEN_WIDTH-40)/5, 250, 40)];
    alertLabel.text = @"只需1分钟，快速发布交易信息\n本平台只提供信息服务其他法律责任概不承担！";
    alertLabel.textAlignment = NSTextAlignmentLeft;
    alertLabel.numberOfLines = 0;
    alertLabel.font = [UIFont systemFontOfSize:11];
    alertLabel.textColor = [UIColor lightGrayColor];
    [scrollViewUpToBottom addSubview:alertLabel];
    
}

#pragma mark - Button click action
-(void)fabu:(UIButton *)sender{

    NSInteger i = sender.tag;
 
    if (i < 107) {
        
        if (i == 104) {
            
            [NSTimer scheduledTimerWithTimeInterval:0.5f
                                             target:self
                                           selector:@selector( delayTime)
                                           userInfo:nil
                                            repeats:NO];

        }
        else{
            
            if (i == 103) {
                
                quxian = [[xinyongkaquxianViewController alloc]init];
                quxian.success=@"1";
                quxian.type=@"3";
                [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                 target:self
                                               selector:@selector(quXianDelayTime)
                                               userInfo:nil
                                                repeats:NO];

            }
            else{
                
                quxian = [[xinyongkaquxianViewController alloc]init];
                quxian.type =[NSString stringWithFormat:@"%ld",(long)(i - 100)];
                quxian.success=@"0";
                [NSTimer scheduledTimerWithTimeInterval:0.5f
                                                 target:self
                                               selector:@selector(quXianDelayTime)
                                               userInfo:nil
                                                repeats:NO];
                
            }
            
        }

    }else{
    
        if (i == 107 ) {
            
            NSLog(@"我被点击了！");
            [NSTimer scheduledTimerWithTimeInterval:0.5f
                                             target:self
                                           selector:@selector( kuaiDiDelayTime)
                                           userInfo:nil
                                            repeats:NO];

            
        }else{
        
            quxian = [[xinyongkaquxianViewController alloc]init];
            quxian.type =[NSString stringWithFormat:@"%ld",(long)(i - 101)];
            quxian.success=@"0";
            [NSTimer scheduledTimerWithTimeInterval:0.5f
                                             target:self
                                           selector:@selector(quXianDelayTime)
                                           userInfo:nil
                                            repeats:NO];
            
        }

    }
    
}

#pragma mark - Other Action
-(void)kuaiDiDelayTime{

    KuaiDiViewController *waihui = [[KuaiDiViewController alloc]init];
    waihui.success=@"0";
    waihui.type=@"4";
    [self presentViewController:waihui animated:NO completion:nil];

}
-(void)delayTime{

    WaiHuiViewController *waihui = [[WaiHuiViewController alloc]init];
    waihui.success=@"0";
    waihui.type=@"4";
    [self presentViewController:waihui animated:NO completion:nil];
 
}

-(void)quXianDelayTime{

    [self presentViewController:quxian animated:NO completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -  AMapNearbyUploadInfo ———— 代理
//-(void)onNearbySearchDone:(AMapNearbySearchRequest *)request response:(AMapNearbySearchResponse *)response{
//    
//    NSLog(@"\n附近的个体服务者\n%@",response.infos);
//    if(response.infos.count == 0){
//        
//        return;
//        
//    }
//    
//     for (AMapNearbyUserInfo *info in response.infos){
//        
//        MAPointAnnotation *anno = [[MAPointAnnotation alloc] init];
//        
//        anno.title = info.userID;
//        anno.subtitle = [[NSDate dateWithTimeIntervalSince1970:info.updatetime] descriptionWithLocale:[NSLocale currentLocale]];
//        
//        anno.coordinate = CLLocationCoordinate2DMake(info.location.latitude, info.location.longitude);
//        NSLog(@"\n\n获取到的id%@",info.userID);
//        
//        
//    }
//}

@end
