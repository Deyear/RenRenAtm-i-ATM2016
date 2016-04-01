//
//  DingDanZhuangtai.m
//  RenRenATM
//
//
//
//
//订单状态





#import "DingDanZhuangtai.h"
#import "AFNetworking/AFNetworking.h"


@interface DingDanZhuangtai ()<UIAlertViewDelegate>
{
    NSArray *all_service_itemArray;
    
    
    IBOutlet UIView *topView;
    IBOutlet UIImageView *finishedOne;
    IBOutlet UILabel *xiaDan;
    IBOutlet UILabel *timeOne;
    IBOutlet UIView *xianYi;
    IBOutlet UIImageView *finishedTwo;
    IBOutlet UILabel *jieDan;
    IBOutlet UILabel *timeTwo;
    IBOutlet UIView *xianEr;
    IBOutlet UIImageView *finishedThree;
    IBOutlet UILabel *jiaoYi;
    IBOutlet UILabel *timeThree;
   
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *wufenLabel;
    IBOutlet UIView *xianLabel;
    IBOutlet UILabel *placeLabel;
    IBOutlet UIButton *jieshoudingdanButton;
    IBOutlet UILabel *typeleixingLabel;
    IBOutlet UILabel *typeshixianLabel;
    IBOutlet UILabel *typefabutimeLabel;
    
    IBOutlet UIImageView *yiFen;
    IBOutlet UIImageView *erFen;
    IBOutlet UIImageView *sanFen;
    IBOutlet UIImageView *siFen;
    IBOutlet UIImageView *wuFen;
    
    UIControl *con;
    UIView *pingFenView;
    UIButton *clickWuXing,*p;
    long _tag;
    NSMutableArray *btn;
    
}
@end

@implementation DingDanZhuangtai
@synthesize xiangQingArray;
@synthesize _pingFen;


- (void)viewDidLoad {
    [super viewDidLoad];
    all_service_itemArray = [[NSArray alloc]initWithObjects:@"",@"信用卡取现",@"银行卡取现",@"代收款",@"外汇",@"存钱",@"转账",@"换整",@"换零", nil];
    btn = [[NSMutableArray alloc]init];
    [self initDingDanUI];
    
    pingFenView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-250)/2, (SCREEN_HEIGHT-150)/2, 250, 150)];
                pingFenView.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0f/255.0f alpha:0.6];
    pingFenView.layer.borderWidth = 3;
    pingFenView.layer.borderColor = [[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] CGColor];
    pingFenView.layer.cornerRadius = 40;
    for (int i = 0 ; i<5; i++) {
        clickWuXing = [[UIButton alloc]initWithFrame:CGRectMake(21 + i * 42, 30, 40, 40)];
        [clickWuXing addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *_image = [UIImage imageNamed:@"home_order_receiving_star2"];
        [clickWuXing setImage:_image  forState:UIControlStateNormal];
        [clickWuXing setTag:i];
        [pingFenView addSubview:clickWuXing];
        [btn addObject:clickWuXing];
    }
    
    //            提交按钮
    p = [[UIButton alloc]initWithFrame:CGRectMake((pingFenView.frame.size.width - 80)/2, 76, 80, 44)];
    p.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [p addTarget:self action:@selector(tiJiao) forControlEvents:UIControlEventTouchUpInside];
    p.layer.borderWidth = 6;
    p.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blackColor]);
    p.layer.cornerRadius = 12;
    [p setTitle:@"提交" forState:UIControlStateNormal];
    p.titleLabel.textColor = [UIColor whiteColor];
    [pingFenView addSubview:p];
}


-(void)initDingDanUI{
//    NSLog(@"============array===========%@",xiangQingArray);
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *user_name = [userDefault objectForKey:@"user_name"];
    NSArray *arr = xiangQingArray[@"evaluations"];
    
//    导航栏的颜色
    topView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    
//    蓝线
    xianYi.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    xianEr.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    
//    名字
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    if ([[NSString stringWithFormat:@"%@",xiangQingArray[@"status"]] isEqualToString:@"101"]) {
        nameLabel.text = @"尚无人接单";
    
    }else{
        nameLabel.text = xiangQingArray[@"receiver"][@"username"];
    }
    
    
//    五星评价
//    for (int i = 0 ; i<5; i++) {
//        //五角星评分
//    }
//    if (arr[0][@"general_evaluation"] != 1) {
//        yiFen.image = [UIImage imageNamed:@"home_order_receiving_star1"];
//    }
    
//    if (arr[0][@"general_evaluation"] == 2) {
//        yiFen.image = [UIImage imageNamed:@"home_order_receiving_star1"];
//    }
    
//    分数
    nameLabel.font = [UIFont systemFontOfSize:15];
    wufenLabel.textColor = [UIColor orangeColor];
    if ([arr isEqual:@[] ]) {
        wufenLabel.text = @"0分";
          }else{
              jieshoudingdanButton.hidden = YES;
        wufenLabel.text = [NSString stringWithFormat:@"%@分",arr[0][@"general_evaluation"]];
        NSArray * fenShuArr = @[yiFen,erFen,sanFen,siFen,wuFen];
             for (int i = 0 ; i<[arr[0][@"general_evaluation"] integerValue] ; i++) {
                 UIImageView *_image = fenShuArr[i];
                 _image.image = [UIImage imageNamed:@"home_order_receiving_star1"];
              }
              
    
        
        NSLog(@"=======fenshu====%@", arr[0] );
    }
   
    
//    灰线
    xianLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
    
//    地址
    placeLabel.font = [UIFont systemFontOfSize:12];
    placeLabel.textColor = [UIColor grayColor];
    placeLabel.numberOfLines = 0;
    if ([xiangQingArray[@"dealt_at"] isEqual:[NSNull null]]) {
        placeLabel.text = @"暂无详细交易地点";
    }
    else
    {
        placeLabel.text = xiangQingArray[@"dealt_at"];
    }
    
//    订单类型
    int item = [[NSString stringWithFormat:@"%@",xiangQingArray[@"service_item_id"] ]intValue];
    typeleixingLabel.text = all_service_itemArray[item];
    typeleixingLabel.textColor = [UIColor grayColor];
    typeleixingLabel.font = [UIFont systemFontOfSize:15];
    
//    需求时限
    NSString *time_limit = [NSString stringWithFormat:@"%@",xiangQingArray[@"time_limit"] ];
    long long int date1 = (long long int)[time_limit intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:date1];
    typeshixianLabel.text = [[NSString stringWithFormat:@"%@",date] substringToIndex:19];
    typeshixianLabel.textColor = [UIColor grayColor];
    typeshixianLabel.font = [UIFont systemFontOfSize:15];
    
//    发布时间
    NSString *created_at = [NSString stringWithFormat:@"%@",xiangQingArray[@"created_at"] ];
    int fabut=[created_at intValue] +[@"28800" intValue];
    long long int date2 = (long long int)fabut;
    NSDate *date22 = [NSDate dateWithTimeIntervalSince1970:date2];
    typefabutimeLabel.text = [[NSString stringWithFormat:@"%@",date22] substringToIndex:19];
    
    typefabutimeLabel.textColor = [UIColor grayColor];
    typefabutimeLabel.font = [UIFont systemFontOfSize:15];
    
//    状态按钮
    if ([[NSString stringWithFormat:@"%@",xiangQingArray[@"sender"][@"username"]] isEqualToString:user_name]) {
//        自己发布的订单
        jieshoudingdanButton.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
        //等待接单
        if ([[NSString stringWithFormat:@"%@",xiangQingArray[@"status"]] isEqualToString:@"101"]) {
            xianYi.hidden = YES;
            xianEr.hidden = YES;
            finishedTwo.hidden = YES;
            finishedThree.hidden = YES;
            jieDan.hidden = YES;
            jiaoYi.hidden = YES;
        }
        //取消订单
        if ([[NSString stringWithFormat:@"%@",xiangQingArray[@"status"]] isEqualToString:@"102"]) {
            jieshoudingdanButton.hidden = YES;
            xianYi.hidden = YES;
            xianEr.hidden = YES;
            finishedTwo.hidden = YES;
            finishedThree.hidden = YES;
            xiaDan.text = @"订单已被取消";
            jieDan.hidden = YES;
            jiaoYi.hidden = YES;
        }
        //已被接单
        if ([[NSString stringWithFormat:@"%@",xiangQingArray[@"status"]] isEqualToString:@"201"]) {
            [jieshoudingdanButton setTitle:@"完成订单" forState:UIControlStateNormal];
            xianEr.hidden = YES;
            finishedThree.hidden = YES;
            jiaoYi.hidden = YES;
        }
        //交易完成
        if ([[NSString stringWithFormat:@"%@",xiangQingArray[@"status"]] isEqualToString:@"301"]) {
            [jieshoudingdanButton setTitle:@"评价" forState:UIControlStateNormal];
        }
    }else{
        jieshoudingdanButton.hidden = YES;
        jieshoudingdanButton.enabled = NO;
        if ([[NSString stringWithFormat:@"%@",xiangQingArray[@"status"]] isEqualToString:@"101"]) {
            xianYi.hidden = YES;
            xianEr.hidden = YES;
            finishedTwo.hidden = YES;
            finishedThree.hidden = YES;
            jieDan.hidden = YES;
            jiaoYi.hidden = YES;
        }
        //取消订单
        if ([[NSString stringWithFormat:@"%@",xiangQingArray[@"status"]] isEqualToString:@"102"]) {
            xianYi.hidden = YES;
            xianEr.hidden = YES;
            finishedTwo.hidden = YES;
            finishedThree.hidden = YES;
            xiaDan.text = @"订单已被取消";
            jieDan.hidden = YES;
            jiaoYi.hidden = YES;
        }
        //接单
        if ([[NSString stringWithFormat:@"%@",xiangQingArray[@"status"]] isEqualToString:@"201"]) {
             xianEr.hidden = YES;
            finishedThree.hidden = YES;
            jiaoYi.hidden = YES;
        }
    }
     NSLog(@"=======username===========%@",xiangQingArray[@"status"]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)callPhone:(id)sender {
    NSString *phoneNum = [[NSString alloc]initWithString:nameLabel.text];// 电话号码
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)quXiao:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:[NSString stringWithFormat:@"你确定%@？",jieshoudingdanButton.titleLabel.text]
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        //            NSLog(@"ooo");
        
    }
    else if
        (buttonIndex == 1)
    {
         NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            NSString *access_token = [userDefault objectForKey:@"access_token"];
            NSString *user_id = [userDefault objectForKey:@"user_id"];
            NSString *user_name = [userDefault objectForKey:@"user_name"];
            NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
            
            NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
            //            NSLog(@"encodeResult:%@",token);
            NSString *str = [NSString stringWithFormat:@"http://114.215.203.95:82/v1/users/%@/orders/%@",@"4",[NSString stringWithFormat:@"%@",xiangQingArray[@"id"]]];
            //            NSLog(@"%@",str);
        
        if ([jieshoudingdanButton.titleLabel.text  isEqual: @"完成订单"]) {
            NSLog(@"完成订单");
            NSDictionary *paratemetrs = @{@"sent_by":user_id,
                                          @"status":@"301"};
            
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            session.requestSerializer = [AFJSONRequestSerializer serializer];
            session.responseSerializer = [AFJSONResponseSerializer serializer];
            [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
            
            [session PATCH:str parameters:paratemetrs success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"==========取消========%@",responseObject);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                               message:@"成功完成订单" delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
                [alert show];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi111" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [self dismissViewControllerAnimated:YES completion:nil];
                jieshoudingdanButton.hidden = YES;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //                NSLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"数据异常，该单无法接收" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
        
        }else if ([jieshoudingdanButton.titleLabel.text  isEqual: @"评价"]){
             NSLog(@"评价");
             con = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            con.backgroundColor = [UIColor blackColor];
            con.alpha = 0.5;
            [con addTarget:self action:@selector(showDingdan) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:con];
            [UIView animateKeyframesWithDuration:10 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                [self.view addSubview:pingFenView];
            } completion:nil ];
        }else{
            NSDictionary *paratemetrs = @{@"received_by":user_id,
                                          @"status":@"102"};
            
            AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
            session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
            session.requestSerializer = [AFJSONRequestSerializer serializer];
            session.responseSerializer = [AFJSONResponseSerializer serializer];
            [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
            
            [session PATCH:str parameters:paratemetrs success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"==========取消========%@",responseObject);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                               message:@"取消订单成功" delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
                [alert show];
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi111" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [self dismissViewControllerAnimated:YES completion:nil];
                jieshoudingdanButton.hidden = YES;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //                NSLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"数据异常，该单无法接收" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }];
        }

        }
      }

//点击消失评价View
-(void)showDingdan
{   [UIView animateKeyframesWithDuration:3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
     pingFenView.hidden = YES;
    con.hidden = YES;
    con.enabled = NO;
} completion:nil ];
   
}


//选择分数
-(void)click:(UIButton *)sender
{
    _tag = sender.tag + 1;
    for (int i = 0 ; i<_tag; i++) {
        UIButton *current = btn[i];
        UIImage *_image = [UIImage imageNamed:@"home_order_receiving_star1"];
        [current setBackgroundImage:_image  forState:UIControlStateNormal];
    }
    for (long j = sender.tag +1 ; j<5; j++) {
        UIButton *current = btn[j];
        
        UIImage *_image = [UIImage imageNamed:@""];
        [current setBackgroundImage:_image  forState:UIControlStateNormal];
    }
    
    NSLog(@"%ld",_tag);
//    NSLog(@"-------------btn------------%lu",(unsigned long)btn.count);
 
}


//提交评价
-(void)tiJiao
{
    NSLog(@"===========得到评分==========%ld",(long)_tag);
    NSString *juTi = [NSString stringWithFormat:@"%ld",_tag];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    NSString *user_id = [userDefault objectForKey:@"user_id"];
    NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
        NSString *str = [NSString stringWithFormat:@"http://114.215.203.95:82/v1/orders/%@/evaluations",[NSString stringWithFormat:@"%@",xiangQingArray[@"id"]]];
    NSDictionary *paratemetrs = @{@"sent_by":user_id,
                                  @"general_evaluation":juTi};
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [session POST:str parameters:paratemetrs success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSLog(@"==========评价========%@",responseObject);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:@"成功完成评价" delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil, nil];
    [alert show];
                    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi111" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self dismissViewControllerAnimated:YES completion:nil];
                    jieshoudingdanButton.hidden = YES;
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    //                NSLog(@"%@",error);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"数据异常，该单无法接收" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    }];
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
