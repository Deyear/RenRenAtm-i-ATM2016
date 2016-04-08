//
//  SecondViewController.m
//
//
//
//
//
//
//订单页面
//全部列表及其事件
//






#define cellHeight SCREEN_HEIGHT/10   //单元格的行高
#define ydp (SCREEN_HEIGHT/1400)      //高度的单位值
#define xdp (SCREEN_WIDTH/750)        //宽度的单位值

//本项目
#import "SecondViewController.h"
#import "rightBtnDetialTabView.h"
#import "MustLogin.h"
#import "DingDanZhuangtai.h"
#import "AllTableViewCell.h"

//第三方
#import "AFNetworking/AFNetworking.h"
#import "MJRefresh.h"

//刷新
#import "MJRefresh.h"




@interface SecondViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
//
    UILabel *tipLabel,*paotuiLabel,*placeLabel,*timeLimitLabel,*juliLabel,*typeMoney,*whoFabuLabel,*zhuangtaiLabel,*xianLabel;
//
    UIButton *quanbuButton,*fenleiButton,*gezhongButton;
//    分类下面的八行按钮
    UIControl *detialListView;
//    
    UIScrollView *TwoScrollerView;
//    
    UITableView *uiTableView;
//    
    NSArray *Array;
    
    NSString *SortType;

}

@end


@implementation SecondViewController

#pragma mark - view的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
   

//    从第一页开始刷新
    __strong  SecondViewController *wakeSelf =self;
    wakeSelf.page =0;
    SortType =@ "-time_limit";
    
    [self initALL];                     //初始化views——全局变量
    
    [self Top];                           //顶部的背景颜色和“订单”
    
    [self QuanbuFenleiButtonAndXianLabel];//全部与分类button操作及两条线
    
    [self ScrollerViewInit];              //构造用于跳转的ScrollerView
    
    [self quanbu];                        //全部和分类订单下的显示列表
    
    
}




//加载完成后左边的“全部”定单界面
-(void)viewDidAppear:(BOOL)animated
{
    [self viewTwoLeft:@"1"];
}


#pragma mark - init初始化——>全局变量
-(void)initALL
{
    detialListView = [[UIControl alloc]init];      //分类下面的八行按钮
}


#pragma mark - init初始化——>视图
//顶部的背景颜色和“订单”
-(void)Top
{
    //顶部蓝色背景
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topImageView.userInteractionEnabled = YES;
    topImageView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [self.view addSubview:topImageView];
    
    //顶部“订单”
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-50)/2, 30, 50, 24)];
    label.text =@"订单";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [topImageView addSubview:label];
}


//全部与分类button操作及两条线
-(void)QuanbuFenleiButtonAndXianLabel
{
    //“全部”Button
    quanbuButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH/2, 44)];
    quanbuButton.backgroundColor = [UIColor clearColor];
    [quanbuButton setTitle:@"全部" forState:UIControlStateNormal];
    [quanbuButton addTarget:self action:@selector(quanbu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: quanbuButton];
    
    //“分类”Button
    fenleiButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 64, SCREEN_WIDTH/2, 44)];
    fenleiButton.backgroundColor = [UIColor clearColor];
    [fenleiButton setTitle:@"分类" forState:UIControlStateNormal];
    [fenleiButton addTarget:self action:@selector(fenlei) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: fenleiButton];
    
    //顶部两个按钮的线
    xianLabel = [[UILabel alloc]init];
    xianLabel.backgroundColor = self.tabBar.tintColor=[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [self.view addSubview:xianLabel];
}


//构造用于跳转的ScrollerView
-(void)ScrollerViewInit
{
    TwoScrollerView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64 +44, SCREEN_WIDTH, SCREEN_HEIGHT-(64 +44 +self.tabBar.frame.size.height))];
    //设置容量
    TwoScrollerView.contentSize = CGSizeMake(2*SCREEN_WIDTH, 0);
    TwoScrollerView.userInteractionEnabled = YES;
    TwoScrollerView.pagingEnabled = YES;
    TwoScrollerView.bounces = NO;
    TwoScrollerView.showsHorizontalScrollIndicator=NO;
    TwoScrollerView.backgroundColor =[UIColor clearColor];
    TwoScrollerView.delegate = self;
    
    
    [self.view addSubview:TwoScrollerView];
    
    [self viewTwoLeft:@"1"];//构造左边的全部定单界面
    [self viewTwoRight];//构造右边的分类界面
}


//构造左边的“全部”定单界面
-(void)viewTwoLeft:(NSString *)refreshPage
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
     NSString *user_id = [userDefault objectForKey:@"user_id"];
//    NSLog(@"-----------------------------%@,------%@,--------%@",userDefault,access_token,user_id);
    
    if (access_token==nil) {
        UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:@"您尚未登录！" message:@"请先登录后操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [_alert show];
    }
    else
    {
        NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
        NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
//        NSLog(@"encodeResult:%@",token);
        
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        session.requestSerializer = [AFJSONRequestSerializer serializer];
        session.responseSerializer = [AFJSONResponseSerializer serializer];
        [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
//        NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/users/%@/orders?relation=sender,receiver,evaluations",user_id];
        NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/users/%@/orders?relation=sender,receiver,evaluations",user_id];
        NSDictionary *parameters=@{
                                   @"page":refreshPage,
                                   @"sort":SortType
                                   };
        [session GET:str parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//            NSLog(@"全部订单数据%@",downloadProgress);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            NSLog(@"============全部订单数据==========全部订单数据%@",responseObject);
            Array = responseObject;
//            NSLog(@"-------个数-------%lu",(unsigned long)Array.count);
            if (Array.count == 0) {
              UILabel *NilLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-20-64, SCREEN_WIDTH - 60 , 40)];
                NilLabel.text = @"暂无该类型订单~~~";
                NilLabel.textAlignment = NSTextAlignmentCenter;
                
                [uiTableView removeFromSuperview];
                [TwoScrollerView addSubview:NilLabel];
            }
            else
            {
            [self leftTableView];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

    }
}


//提示框消失后跳转到登录界面
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    MustLogin *login = [[MustLogin alloc]init];
    [self presentViewController:login animated:YES completion:nil];
}


//构造右边的分类界面
-(void)viewTwoRight
{
    //左边的图片显示
    NSArray *imageArray =[ [NSArray alloc]initWithObjects:@"individual_One",@"individual_Two",@"individual_Six",@"individual_Five",@"individual_Seven",@"individual_Eight",@"individual_Four",@"individual_Three", nil];
    //左边的内容显示
    NSArray *nameArray = [[NSArray alloc]initWithObjects:@"信用卡取现",@"银行卡取现",@"我要转账",@"我要存钱",@"我要换零钱",@"我要换整钱",@"我要换外汇",@"代收款", nil];
    //灰色背景图片
    UIImageView *RightView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, TwoScrollerView.frame.size.height)];
    RightView.image = [UIImage imageNamed:@"RenRenGray"];
    [TwoScrollerView addSubview:RightView];
    for (int i = 0;  i<8; i++) {
        //每一行的背景View
//        sixView = [[UIControl alloc]initWithFrame:CGRectMake(0, cellHeight*i + 30*(i/3), SCREEN_WIDTH, cellHeight)];
        detialListView = [[UIControl alloc]initWithFrame:CGRectMake(0, TwoScrollerView.frame.size.height/8 * i, SCREEN_WIDTH, TwoScrollerView.frame.size.height/8)];
        detialListView.backgroundColor = [UIColor whiteColor];
        
        //给每一个sixView添加一个tag
        [detialListView setTag:i + 10000];
        [detialListView addTarget:self action:@selector(SelectedSixView:) forControlEvents:UIControlEventTouchUpInside];
        
        [RightView addSubview:detialListView];
        RightView.userInteractionEnabled = YES;
//        NSLog(@"RightView is %@",RightView);
        
        //每一行左侧的图片显示
//        UIImageView *leftView= [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, cellHeight-20, cellHeight-20)];
         UIImageView *leftView= [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, cellHeight-20, cellHeight-20)];
        leftView.image = [UIImage imageNamed:imageArray[i]];
        [detialListView addSubview:leftView];
        
        
        //每一行左侧的内容显示
//        UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftView.frame.size.width + 15, (cellHeight-20)/2, 100, 20)];
         UILabel *NameLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftView.frame.size.width + 15, cellHeight/2-20, 100, 20)];
        NameLabel.text = nameArray[i];
        NameLabel.font = [UIFont systemFontOfSize:15];
        [detialListView addSubview: NameLabel];
        
        
        //右侧箭头显示
        UIImageView *rightView= [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, (cellHeight - 20)/2, 20, 20)];
        rightView.image = [UIImage imageNamed:@"right-Small"];
        [detialListView addSubview:rightView];
        [detialListView viewWithTag:i];
//        NSLog(@"+++++++++++++%ld",(long)sixView.tag);
        if (i==0||i==1||i==3||i==4) {
            UILabel *xianLabelSix = [[UILabel alloc]initWithFrame:CGRectMake(NameLabel.frame.origin.x, cellHeight-1, SCREEN_WIDTH-NameLabel.frame.origin.x, 1)];
            xianLabelSix.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
            [detialListView addSubview: xianLabelSix];
        }
    }
    
}


//点击“分类”每一行触发的事件
-(void)SelectedSixView:(UIControl *)sender
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [userDefault objectForKey:@"access_token"];
//    NSString *user_id = [userDefault objectForKey:@"user_id"];
    
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        sender.backgroundColor = [UIColor blackColor];
        sender.alpha = 0.2;
    } completion:^(BOOL finished) {
        sender.backgroundColor = [UIColor whiteColor];
        sender.alpha = 1;
    }];
    
    //用户未登录则跳入登录页面
    if (access_token==nil) {
        MustLogin *login = [[MustLogin alloc]init];
        [self presentViewController:login animated:YES completion:nil];
    }
    else
    {
        //点击每一行触发点击事件
//        NSLog(@"++++++++++++%@",Array);
//        NSLog(@"%d",sender.tag);
         rightBtnDetialTabView *vc = [[rightBtnDetialTabView alloc]init];
        if (sender.tag == 10000) {
            vc.type = @"1";
            vc.titleName = @"信用卡取现";
        }else if (sender.tag == 10001){
            vc.type = @"2";
            vc.titleName = @"银行卡取现取现";
        }else if (sender.tag == 10002){
           vc.type = @"6";
             vc.titleName = @"我要转账";
        }else if (sender.tag == 10003){
            vc.type = @"5";
             vc.titleName = @"我要存钱";
        }else if (sender.tag == 10004){
            vc.type = @"8";
             vc.titleName = @"我要换零钱";
        }else if (sender.tag == 10005){
            vc.type = @"7";
             vc.titleName = @"我要换整钱";
        }else if (sender.tag == 10006){
             vc.type = @"4";
             vc.titleName = @"我要换外汇";
        }else if (sender.tag == 10007){
           vc.type = @"3";
             vc.titleName = @"代收款";
        }
        [self presentViewController:vc animated:YES completion:nil];
       }
}


//左边的界面列表
-(void)leftTableView
{
    uiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 -44 - 49) style:UITableViewStylePlain];
    uiTableView.delegate =self;
    uiTableView.dataSource = self;
    uiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    uiTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [TwoScrollerView addSubview:uiTableView];
    __strong  SecondViewController *wakeSelf =self;
//      wakeSelf.page =0;
    [uiTableView addLegendHeaderWithRefreshingBlock:^{
         wakeSelf.page --;
        [wakeSelf viewTwoLeft:[NSString stringWithFormat:@"%ld",(long)wakeSelf.page]];
        [uiTableView.header endRefreshing];
    }];
    
    [uiTableView addLegendFooterWithRefreshingBlock:^{
          wakeSelf.page ++;
        [wakeSelf  viewTwoLeft:[NSString stringWithFormat:@"%ld",(long)wakeSelf.page]];
        [uiTableView.footer endRefreshing];

    }];
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


//‘全部“的列表界面
-(void)quanbu
{
    [quanbuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [fenleiButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [quanbuButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [fenleiButton.titleLabel setFont:[UIFont systemFontOfSize:15]];

    xianLabel.frame = CGRectMake(0, 106, SCREEN_WIDTH/2, 2);
    [TwoScrollerView setContentOffset:CGPointMake(0, 0) animated:NO];
}

//”分类“的列表界面
-(void)fenlei
{
    [fenleiButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [quanbuButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [quanbuButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [fenleiButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    xianLabel.frame = CGRectMake(SCREEN_WIDTH/2, 106, SCREEN_WIDTH/2, 2);
    [TwoScrollerView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
}


//当前一个提到的减速完毕、滚动视图停止移动时会得到通知，收到这个通知的时刻，滚动视图contentOffset属性会反映出滚动条最终停止位置
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //scrollView当前界面
    int index = fabs(scrollView.contentOffset.x)/scrollView.frame.size.width;
//    NSLog(@"%d",index);
    
    //scrollView第一个界面时两按钮的样式
    if (index == 0) {
        [quanbuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [fenleiButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [quanbuButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [fenleiButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        xianLabel.frame = CGRectMake(0, 106, SCREEN_WIDTH/2, 2);
    }
    
    // //scrollView第二个界面时两按钮的样式
    if (index == 1) {
        [fenleiButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [quanbuButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [quanbuButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [fenleiButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        xianLabel.frame = CGRectMake(SCREEN_WIDTH/2, 106, SCREEN_WIDTH/2, 2);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//点击列表事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DingDanZhuangtai *detail = [[DingDanZhuangtai alloc]init];
    detail.xiangQingArray = Array[indexPath.row];
//    NSLog(@"=========1111111111===========%@",Array[indexPath.row]);
    [self presentViewController:detail animated:NO completion:nil];
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
