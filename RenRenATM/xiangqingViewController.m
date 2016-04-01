//
//  xiangqingViewController.m
//  RenRenATM
//
//
//
//


#define ydp (SCREEN_HEIGHT/1400)
#define xdp (SCREEN_WIDTH/750)
#import "xiangqingViewController.h"
#import "AFNetworking/AFNetworking.h"
@interface xiangqingViewController ()
{
    NSArray *all_service_itemArray;
    UILabel *nameLabel;
}
@end

@implementation xiangqingViewController
@synthesize xiangqingArray;
- (void)viewDidLoad {
    [super viewDidLoad];

    all_service_itemArray = [[NSArray alloc]initWithObjects:@"",@"信用卡取现",@"银行卡取现",@"代收款",@"外汇",@"存钱",@"转账",@"换整",@"换零", nil];
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

    //上面的白色背景view
    UIImageView *whiteImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 220*ydp)];
    whiteImageView.backgroundColor = [UIColor whiteColor];
    whiteImageView.userInteractionEnabled = YES;
    [self.view addSubview:whiteImageView];

    //名字label
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(22*xdp, 33*ydp, 400*xdp, 40*ydp)];
    nameLabel.font = [UIFont boldSystemFontOfSize:17];
//    nameLabel.text = xiangqingArray[@"sender"][@"username"];
    nameLabel.text = @"请接单";
//    nameLabel.backgroundColor = [UIColor greenColor];
    [whiteImageView addSubview:nameLabel];
    
    for (int i = 0 ; i<5; i++) {
        //五角星评分
        UIImageView *FiveView = [[UIImageView alloc]initWithFrame:CGRectMake(22*xdp + 35*xdp*i, 80*ydp, 35*xdp, 35*xdp)];
        FiveView.image = [UIImage imageNamed:@"home_order_receiving_star2"];
        FiveView.userInteractionEnabled = NO;
        [whiteImageView addSubview:FiveView];
    }
    
    //五分label
    UILabel *wufenLabel = [[UILabel alloc]initWithFrame:CGRectMake(200*xdp, 77*ydp, 130*xdp, 40*ydp)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    wufenLabel.textColor = [UIColor orangeColor];
    wufenLabel.text = @"5.0分";
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
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80*xdp, 155*ydp, 490*xdp, 30*xdp)];
    placeLabel.font = [UIFont systemFontOfSize:15];
    placeLabel.textColor = [UIColor grayColor];
//    NSLog(@"===交易地点为===%@",xiangqingArray[@"dealt_at"]);
    if ([xiangqingArray[@"dealt_at"] isEqual:[NSNull null]]) {
        placeLabel.text = @"暂无详细交易地点";
    }
    else
    {
    placeLabel.text = xiangqingArray[@"dealt_at"];
    }

    [whiteImageView addSubview:placeLabel];
    
    //一条线
    UILabel *shuxianLabel = [[UILabel alloc]initWithFrame:CGRectMake(580*xdp, 140*ydp, 1, 70*ydp)];
    shuxianLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    [whiteImageView addSubview:shuxianLabel];
    
    //接受订单
    UIButton *jieshoudingdanButton = [[UIButton alloc]initWithFrame:CGRectMake(570*xdp, 40*ydp, 160*xdp, 50*xdp)];
    [jieshoudingdanButton setTitle:@"接收订单" forState:UIControlStateNormal];
    [jieshoudingdanButton setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
    jieshoudingdanButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    jieshoudingdanButton.userInteractionEnabled = YES;
    [jieshoudingdanButton addTarget:self action:@selector(jiedan) forControlEvents:UIControlEventTouchUpInside];
    [whiteImageView addSubview: jieshoudingdanButton];
    
    //拨打电话
    UIButton *callPhoneButton = [[UIButton alloc]initWithFrame:CGRectMake(630*xdp, 150*ydp, 50*xdp, 50*xdp)];
    [callPhoneButton setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    [callPhoneButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    [whiteImageView addSubview:callPhoneButton];
    //----------------------------------上下两个view-------------------------//
    
    
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
//接单
-(void)jiedan
{
    
//    NSLog(@"接单判断");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"确定接收该订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];



}


//自动拨号功能
-(void)callPhone:(UIButton *)sender
{
    NSString *phoneNum = [[NSString alloc]initWithString:nameLabel.text];// 电话号码
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    [[UIApplication sharedApplication] openURL:url];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if(buttonIndex == 0)
        {
//            NSLog(@"ooo");
           
        }
    else if
        (buttonIndex == 1)
    {
//        NSLog(@"111");
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *access_token = [userDefault objectForKey:@"access_token"];
            NSString *user_id = [userDefault objectForKey:@"user_id"];
            NSString *user_name = [userDefault objectForKey:@"user_name"];
            NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
        
            NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
//            NSLog(@"encodeResult:%@",token);
            NSString *str = [NSString stringWithFormat:@"http://114.215.203.95:82/v1/users/%@/orders/%@",@"4",[NSString stringWithFormat:@"%@",xiangqingArray[@"id"]]];
//            NSLog(@"%@",str);
        
        
            NSDictionary *paratemetrs = @{@"received_by":user_id,
                                          @"status":@"201"};
        
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            session.requestSerializer = [AFJSONRequestSerializer serializer];
            session.responseSerializer = [AFJSONResponseSerializer serializer];
            [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        
            [session PATCH:str parameters:paratemetrs success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"=============response===========%@",responseObject);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"抢单成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi111" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [self dismissViewControllerAnimated:YES completion:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                NSLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"数据异常，该单无法接收" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];	
            }];
        }
}
#pragma mark 导航条返回事件
-(void)BackView
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
