//
//  rightBtnDetialTabView.m
//  RenRenATM
//
//
//
#define ydp (SCREEN_HEIGHT/1400)
#define xdp (SCREEN_WIDTH/750)


#import "rightBtnDetialTabView.h"
#import "AFNetworking/AFNetworking.h"
#import "AllTableViewCell.h"
#import "DingDanZhuangtai.h"

@interface rightBtnDetialTabView ()
{
    IBOutlet UILabel *tittleLabel;
    UIButton *gezhongButton;
    UILabel *zhuangtaiLabel,*typeMoney,*whoFabuLabel;
    NSArray *Array;
//    IBOutlet UITableView *_tableView;
    UITableView *uiTableView;
    
    
}
@end

@implementation rightBtnDetialTabView


- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@synthesize type;
@synthesize titleName;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    tittleLabel.text = titleName;
}


//加载完成后左边的“全部”定单界面
-(void)viewDidAppear:(BOOL)animated
{
    [self viewTwoLeft];
}


//构造左边的“全部”定单界面
-(void)viewTwoLeft
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
    NSString *user_id = [userDefault objectForKey:@"user_id"];
    //    NSLog(@"-----------------------------%@,------%@,--------%@",userDefault,access_token,user_id);
    
    if (access_token==nil) {
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请先登录后操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
        UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:@"您尚未登录！" message:@"请先登录后操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alert show];
    }
    else
    {
        NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
        NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
                NSLog(@"encodeResult:%@",token);
        
                AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        
                session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
                session.requestSerializer = [AFJSONRequestSerializer serializer];
                session.responseSerializer = [AFJSONResponseSerializer serializer];
        
                [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
                NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/users/%@/orders?relation=sender,receiver,evaluations",user_id];
                //    NSLog(@"%@",str);
                //分类——信用卡取现
                NSString *search = [NSString stringWithFormat:@"[\"=\", \"service_item_id\", \"%@\"]",type];
                //    NSLog(@"%@",search);
        
                NSDictionary *paratemetrs = @{@"search":search};
        
                [session GET:str parameters:paratemetrs progress:^(NSProgress * _Nonnull downloadProgress) {
                    //            NSLog(@"全部订单数据%@",downloadProgress);
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {            //            NSLog(@"======================全部订单数据%@",responseObject);
            Array = responseObject;
            if (Array.count == 0) {
                UILabel *NilLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-20-64, SCREEN_WIDTH - 60 , 40)];
                NilLabel.text = @"暂无该类型订单~~~";
                NilLabel.textAlignment = NSTextAlignmentCenter;
                
                [uiTableView removeFromSuperview];
                [self.view addSubview:NilLabel];
            }
            else
            {
                [self leftTableView];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
}

//左边的界面列表
-(void)leftTableView
{
    uiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT - 80) style:UITableViewStylePlain];
    uiTableView.delegate =self;
    uiTableView.dataSource = self;
    uiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    uiTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:uiTableView];

}


//每行CELL的高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return  80;
}


//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  Array.count;
    //    NSLog(@"================%@",Array.count);
}


////自定义cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * str = @"cell";
    AllTableViewCell  *cell =[tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil]objectAtIndex:0];
        
        zhuangtaiLabel = [[UILabel alloc]initWithFrame:CGRectMake(600*xdp, 60*ydp, 150*xdp, 40*xdp)];
        zhuangtaiLabel.font = [UIFont systemFontOfSize:15];
        zhuangtaiLabel.textColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
        [cell addSubview:zhuangtaiLabel];
        
        //左边的头像
        UIImageView *leftAvatarView = [[UIImageView alloc]initWithFrame:CGRectMake(120*xdp, 40*ydp, 120*xdp, 120*xdp)];
        leftAvatarView.image = [UIImage imageNamed:@"individual_Five"];
        [cell addSubview:leftAvatarView];
        
        typeMoney = [[UILabel alloc]initWithFrame:CGRectMake(250*xdp, 40*ydp, 330*xdp, 60*xdp)];
        typeMoney.font = [UIFont systemFontOfSize:15];
        typeMoney.adjustsFontSizeToFitWidth  = YES;
        [cell addSubview:typeMoney];
        
        whoFabuLabel = [[UILabel alloc]initWithFrame:CGRectMake(250*xdp, 100*ydp, 330*xdp, 60*xdp)];
        whoFabuLabel.font = [UIFont systemFontOfSize:15];
        [cell addSubview:whoFabuLabel];
        
        //上面的灰色
        UIImageView *topGrayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15*ydp)];
        topGrayView.image = [UIImage imageNamed:@"RenRenGray"];
        [cell addSubview:topGrayView];
        
        
        
    }
    
    //home_order_receiving_positioon home_order_receiving_time
    //  home_order_receiving_distance
    //创建个人中心 显示个人中心列表数据
    
    NSUInteger row = [indexPath row];
    //    NSLog(@"%@",Array[row]);
    NSArray  *all_service_itemArray1 = [[NSArray alloc]initWithObjects:@"",@"信用卡取现",@"银行卡取现",@"代收款",@"外汇",@"存钱",@"转账",@"换整",@"换零", nil];
    int type_ser = [Array[row][@"service_item_id"] intValue];
    //    NSLog(@"\\\\\\\\\\\\\%d",type_ser);
    
    typeMoney.text  =[NSString stringWithFormat:@"%@%@¥",all_service_itemArray1[type_ser],Array[row][@"money"]];
    
    //    NSLog(@"----------------------------%@",typeMoney.text);
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *user_name = [userDefault objectForKey:@"user_name"];
    NSString *status =[NSString stringWithFormat:@"%@",Array[row][@"status"]];
    //自己发布
    if ([Array[row][@"sender"][@"username"] isEqualToString:user_name]) {
        whoFabuLabel.text = @"自己发布";
        whoFabuLabel.textColor = [UIColor redColor];
    }
    else
    {
        //他人发布
        whoFabuLabel.text =[NSString stringWithFormat:@"%@发布",Array[row][@"sender"][@"username"]] ;
    }
    
    //右侧状态标签
    if([status isEqualToString:@"101"])
    {
        zhuangtaiLabel.text = @"等待接单";
    }
    if ([status isEqualToString:@"102"]) {
        zhuangtaiLabel.text = @"订单已取消";
    }
    if ([status isEqualToString:@"201"]) {
        zhuangtaiLabel.text = @"已接单";
    }
    if ([status isEqualToString:@"202"]) {
        zhuangtaiLabel.text = @"暂停";
    }
    if ([status isEqualToString:@"301"]) {
        zhuangtaiLabel.text= @"订单完成";
    }
    if ([status isEqualToString:@"302"]) {
        zhuangtaiLabel.text = @"失败";
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}






//当前一个提到的减速完毕、滚动视图停止移动时会得到通知，收到这个通知的时刻，滚动视图contentOffset属性
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击列表事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DingDanZhuangtai *detail = [[DingDanZhuangtai alloc]init];
    detail.xiangQingArray = Array[indexPath.row];
    NSLog(@"=========1111111111===========%@",Array[indexPath.row]);
    [self presentViewController:detail animated:NO completion:nil];
}



@end

