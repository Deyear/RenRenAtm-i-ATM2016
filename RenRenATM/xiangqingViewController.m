//
//  xiangqingViewController.m
//  RenRenATM
//
//
//
//接单————详情页面


#define ydp (SCREEN_HEIGHT/1400)
#define xdp (SCREEN_WIDTH/750)
#import "xiangqingViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "goMap.h"

//立体按钮——第三方
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"




@interface xiangqingViewController (){
    
    NSArray *all_service_itemArray;
    UILabel *nameLabel;

}
@end

@implementation xiangqingViewController

@synthesize xiangqingArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initValues];                    //初始化各种值
    
    [self initTopView];                   //导航View

    [self initAllView];                   //初始化界面
    
}

#pragma mark - init Value
-(void)initValues{

    all_service_itemArray = [[NSArray alloc]initWithObjects:@"",@"信用卡取现",@"银行卡取现",@"代收款",@"外汇",@"存钱",@"转账",@"换整",@"换零",@"快递", nil];

}

#pragma mark - init Views
//导航View
-(void)initTopView{
    
    //顶部图片
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topImageView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [self.view addSubview:topImageView];
    
    //创建返回按钮
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"back-Small"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(BackView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    //全局的灰色
    UIImageView *topGrayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT -64)];
    topGrayView.image = [UIImage imageNamed:@"RenRenGray"];
    [self.view addSubview:topGrayView];
    
}

//初始化所有的界面
-(void)initAllView{

    //上面的白色背景view
    UIImageView *whiteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 220*ydp)];
    whiteImageView.backgroundColor = [UIColor whiteColor];
    whiteImageView.userInteractionEnabled = YES;
    [self.view addSubview:whiteImageView];
    
    //名字label
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(22*xdp, 33*ydp, 400*xdp, 40*ydp)];
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
    NSString *str1 = [xiangqingArray[@"sender"][@"username"] substringWithRange:NSMakeRange(0, 7)];
    nameLabel.text = [NSString stringWithFormat:@"%@****",str1];
    [whiteImageView addSubview:nameLabel];
    
    //五角星评分
    NSInteger fenshu = [xiangqingArray[@"senderAvgOfGeneralEvaluation"] integerValue];
    for (int i = 0 ; i<5; i++) {
        
        UIImageView *FiveView = [[UIImageView alloc]initWithFrame:CGRectMake(22*xdp + 35*xdp*i, 80*ydp, 35*xdp, 35*xdp)];
        FiveView.userInteractionEnabled = NO;
        
        if (i < fenshu) {
        
            FiveView.image = [UIImage imageNamed:@"home_order_receiving_star1"];
        
        }else{
            FiveView.image = [UIImage imageNamed:@"home_order_receiving_star2"];
            
        }
        
        FiveView.userInteractionEnabled = NO;
        
        [whiteImageView addSubview:FiveView];
    
    }
    
    //五分label
    UILabel *wufenLabel = [[UILabel alloc]initWithFrame:CGRectMake(200*xdp, 77*ydp, 130*xdp, 40*ydp)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    wufenLabel.textColor = [UIColor orangeColor];
    wufenLabel.text = [NSString stringWithFormat:@"%ld分",(long)fenshu];
    [whiteImageView addSubview:wufenLabel];
    
    //一条线
    UILabel *xianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 130*ydp, SCREEN_WIDTH, 1)];
    xianLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    [whiteImageView addSubview:xianLabel];
    
    //地点的图片
    UIImageView *leftPlaceView = [[UIImageView alloc]initWithFrame:CGRectMake(22*xdp, 150*ydp, 40*xdp, 40*xdp)];
    leftPlaceView.image = [UIImage imageNamed:@"home_order_receiving_positioon"];
    [whiteImageView addSubview:leftPlaceView];
    
    //地点label
    UIButton *placeLabel = [[UIButton alloc]initWithFrame:CGRectMake(80*xdp, 155*ydp, 490*xdp, 30*xdp)];
    placeLabel.titleLabel.font = [UIFont systemFontOfSize:15];
    [placeLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    if ([xiangqingArray[@"dealt_at"] isEqual:[NSNull null]]) {
    
        [placeLabel setTitle:@"暂无详细交易地点" forState:UIControlStateNormal];
    
    }
    else{
        
        [placeLabel setTitle:[NSString stringWithFormat:@"%@",xiangqingArray[@"dealt_at"]] forState:UIControlStateNormal];
    
    }
    
    [placeLabel addTarget:self action:@selector(clickMap:) forControlEvents:UIControlEventTouchUpInside];
    [whiteImageView addSubview:placeLabel];
    
    //一条线
    UILabel *shuxianLabel = [[UILabel alloc]initWithFrame:CGRectMake(580*xdp, 140*ydp, 1, 70*ydp)];
    shuxianLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    [whiteImageView addSubview:shuxianLabel];
    
    //接受订单
    CGRect frame = CGRectMake(570*xdp, 40*ydp, 160*xdp, 50*xdp);
    BFPaperButton *jieshoudingdanButton = [[BFPaperButton alloc] initWithFrame:frame  ];
    jieshoudingdanButton.backgroundColor = [UIColor whiteColor];
    jieshoudingdanButton.shadowColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [jieshoudingdanButton setTitle:@"接收订单" forState:UIControlStateNormal];
    [jieshoudingdanButton setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    jieshoudingdanButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    jieshoudingdanButton.userInteractionEnabled = YES;
    [jieshoudingdanButton addTarget:self action:@selector(jiedan) forControlEvents:UIControlEventTouchUpInside];
    [whiteImageView addSubview: jieshoudingdanButton];
    
    
    //下面的白色背景
    UIImageView *whiteImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  64 +260*ydp, SCREEN_WIDTH, 550*ydp)];
    whiteImageView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteImageView2];
    
    //创建数组
    NSArray *typeArray = [[NSArray alloc]initWithObjects:@"订单类型",@"需求时限",@"发布时间",@"需求面额",@"给予赏金",@"跑腿服务费", nil];
    for (int i = 0; i < typeArray.count; i++) {
        
        //一条线
        UILabel *shuxianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, i*90*ydp, SCREEN_WIDTH, 1)];
        shuxianLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
        [whiteImageView2 addSubview:shuxianLabel];
        
        //typeLabel
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(22*xdp,40*ydp+i*90*ydp, 180*xdp, 40*ydp)];
        typeLabel.text = typeArray[i];
        typeLabel.font = [UIFont systemFontOfSize:15];
        typeLabel.adjustsFontSizeToFitWidth = YES;
        [whiteImageView2 addSubview:typeLabel];
        
    }
    
    //type订单类型
    UILabel *typeleixingLabel =[[UILabel alloc]initWithFrame:CGRectMake(230*xdp,40*ydp, 180*xdp, 40*ydp)];
    int item = [[NSString stringWithFormat:@"%@",xiangqingArray[@"service_item_id"] ]intValue];
    typeleixingLabel.text = all_service_itemArray[item];
    typeleixingLabel.textColor = [UIColor grayColor];
    typeleixingLabel.font = [UIFont systemFontOfSize:15];
    typeleixingLabel.adjustsFontSizeToFitWidth = YES;
    [whiteImageView2 addSubview:typeleixingLabel];
    
    //type需求时限
    UILabel *typeshixianLabel =[[UILabel alloc]initWithFrame:CGRectMake(230*xdp,40*ydp + 90*ydp, 500*xdp, 40*ydp)];
    NSString *time_limit = [NSString stringWithFormat:@"%@",xiangqingArray[@"time_limit"] ];
    long long int date1 = (long long int)[time_limit intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:date1];
    typeshixianLabel.text = [[NSString stringWithFormat:@"%@",date] substringToIndex:19];
    typeshixianLabel.textColor = [UIColor grayColor];
    typeshixianLabel.font = [UIFont systemFontOfSize:15];
    typeshixianLabel.adjustsFontSizeToFitWidth = YES;
    [whiteImageView2 addSubview:typeshixianLabel];
    
    //type发布时间
    UILabel *typefabutimeLabel =[[UILabel alloc]initWithFrame:CGRectMake(230*xdp,40*ydp + 180*ydp, 400*xdp, 40*ydp)];
    NSString *created_at = [NSString stringWithFormat:@"%@",xiangqingArray[@"created_at"] ];
    int fabut=[created_at intValue] +[@"28800" intValue];
    long long int date2 = (long long int)fabut;
    NSDate *date22 = [NSDate dateWithTimeIntervalSince1970:date2];
    typefabutimeLabel.text = [[NSString stringWithFormat:@"%@",date22] substringToIndex:19];
    typefabutimeLabel.textColor = [UIColor grayColor];
    typefabutimeLabel.font = [UIFont systemFontOfSize:15];
    typefabutimeLabel.adjustsFontSizeToFitWidth = YES;
    [whiteImageView2 addSubview:typefabutimeLabel];
    
    //type跑腿服务费
    UILabel *typepaotuifeiLabel =[[UILabel alloc]initWithFrame:CGRectMake(230*xdp,40*ydp + 270*ydp, 180*xdp, 40*ydp)];
    NSString *money = [NSString stringWithFormat:@"%@¥",xiangqingArray[@"money"] ];
    typepaotuifeiLabel.text = money;
    typepaotuifeiLabel.textColor = [UIColor grayColor];
    typepaotuifeiLabel.font = [UIFont systemFontOfSize:15];
    typepaotuifeiLabel.adjustsFontSizeToFitWidth = YES;
    [whiteImageView2 addSubview:typepaotuifeiLabel];
    
    //type跑腿服务费
    UILabel *typeshangjinTipLabel =[[UILabel alloc]initWithFrame:CGRectMake(230*xdp,40*ydp + 360*ydp, 180*xdp, 40*ydp)];
    NSString *tip = [NSString stringWithFormat:@"%@¥",xiangqingArray[@"tip"] ];
    typeshangjinTipLabel.text = tip;
    typeshangjinTipLabel.textColor = [UIColor grayColor];
    typeshangjinTipLabel.font = [UIFont systemFontOfSize:15];
    typeshangjinTipLabel.adjustsFontSizeToFitWidth = YES;
    [whiteImageView2 addSubview:typeshangjinTipLabel];
    
    //type交易金额
    UILabel *typejiaoyijineLabel =[[UILabel alloc]initWithFrame:CGRectMake(230*xdp,40*ydp + 450*ydp, 180*xdp, 40*ydp)];
    NSString *service_charge = [NSString stringWithFormat:@"%@¥",xiangqingArray[@"service_charge"] ];
    typejiaoyijineLabel.text = service_charge;
    typejiaoyijineLabel.textColor = [UIColor grayColor];
    typejiaoyijineLabel.font = [UIFont systemFontOfSize:15];
    typejiaoyijineLabel.adjustsFontSizeToFitWidth = YES;
    [whiteImageView2 addSubview:typejiaoyijineLabel];
    
}

#pragma mark - Button Click Action
//点击地理位置，显示地图
-(void)clickMap:(UIButton *)sender{
    
    goMap *vc= [[goMap alloc]init];
    vc.dic = sender.titleLabel.text;
    [self presentViewController:vc animated:YES completion:nil];
 
}

//返回事件
-(void)BackView{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

//接单
-(void)jiedan{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:nil
                          message:@"确定接收该订单"
                          delegate:self
                          cancelButtonTitle:@"取消"
                          otherButtonTitles:@"确定", nil];
 
    [alert show];
    
 }


#pragma mark - Other Action

#pragma mark - alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        
    }
    else if(buttonIndex == 1){
    
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *access_token = [userDefault objectForKey:@"access_token"];
        NSString *user_id = [userDefault objectForKey:@"user_id"];
        NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
        NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
        NSString *str = [NSString stringWithFormat:@"http://114.215.203.95:82/v1/users/%@/orders/%@",@"4",[NSString stringWithFormat:@"%@",xiangqingArray[@"id"]]];
         NSDictionary *paratemetrs = @{@"received_by":user_id,
                                      @"status":@"201"};
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        session.requestSerializer = [AFJSONRequestSerializer serializer];
        session.responseSerializer = [AFJSONResponseSerializer serializer];
        [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
        [session PATCH:str
            parameters:paratemetrs
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 
                   UIAlertView *alert = [[UIAlertView alloc]
                                         initWithTitle:nil
                                         message:@"抢单成功"
                                         delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
                   
                   [alert show];
                   
                   //创建通知
                   NSNotification *notification =[NSNotification notificationWithName:@"tongzhi111" object:nil userInfo:nil];
                   //通过通知中心发送通知
                   [[NSNotificationCenter defaultCenter] postNotification:notification];
          
                    [self dismissViewControllerAnimated:YES completion:nil];
       
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
                   UIAlertView *alert = [[UIAlertView alloc]
                                         initWithTitle:nil message:@"数据异常，该单无法接收"
                                         delegate:nil
                                            cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil, nil];
            
                   [alert show];
            
               }];
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }
@end
