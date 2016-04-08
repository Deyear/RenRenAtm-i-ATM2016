//
//  HomeVCTestViewController.m
//  RenRenATM
//
//
//
//接单界面



#define ydp (SCREEN_HEIGHT/1400)
#define xdp (SCREEN_WIDTH/750)
#define cellHeight SCREEN_HEIGHT/7.5
#define MENUHEIHT 40

#import "HomeVCTestViewController.h"
#import "AllTableViewCell.h"
#import "AFNetworking/AFNetworking.h"
#import "MJRefresh.h"
#import "xiangqingViewController.h"
#import <CoreLocation/CoreLocation.h>

//立体按钮——第三方
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"


@interface HomeVCTestViewController ()<CLLocationManagerDelegate>
{
    UIView *ViewOne,*ViewTwo,*ViewThree;
    UITableView *uiTableView;
    UILabel *NilLabel;
    NSString *typeStr;
    NSArray *Array;
    float latitude,longtitude,currentLatitude,currentLongtitude;
    UILabel *tipLabel,*paotuiLabel,*placeLabel,*timeLimitLabel,*juliLabel,*moneyLabel;
    NSString *SortType;
    HTPressableButton *dingdanzhuangtaiButton;
    CLLocationManager *_locationManager;
    NSUserDefaults *userDefaults ;
}
@end

@implementation HomeVCTestViewController
@synthesize mMenuHriZontal;\


- (void)viewDidLoad {
    [super viewDidLoad];
    
     //刷新监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxin) name:@"tongzhi111" object:nil];
    SortType =@ "time_limit";
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    currentLatitude = [userDefaults floatForKey:@"currentLatitude"];
    currentLongtitude = [userDefaults floatForKey:@"currentLongtitude"];
//    NSLog(@"--------latitude----------%lf----%lf",currentLatitude,currentLongtitude);
    [self commInit];                      //初始化UI
    [self naviView];                      //上面的导航界面
    [self initLocation];                  //初始化地理定位
}


 //刷新
-(void)shuaxin
{
    [self reLoadTable];
}


//初始化地理定位
-(void)initLocation
{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.distanceFilter = 50;
        [_locationManager requestWhenInUseAuthorization];
       
    }else {
        //提示用户无法进行定位操作
    }
    // 开始定位
     [_locationManager startUpdatingLocation];
}


//获取当前经纬度
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
     CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    latitude =  coor.latitude;
    longtitude = coor.longitude;
    //将当前位置存储在本地
    [userDefaults setFloat:latitude forKey:@"currentLatitude"];
    [userDefaults setFloat:longtitude forKey:@"currentLongtitude"];
    [userDefaults synchronize];
//    NSLog(@"===========longtitude========%lf",longtitude);
}


//刷新订单
-(void)reLoadTable
{
    [NilLabel removeFromSuperview];
    [uiTableView removeFromSuperview];
//    NSLog(@"SortType2:%@",SortType);
    
    NSString *str = [NSString stringWithFormat:@"http://114.215.203.95:82/v1/orders?relation=sender,senderAvgOfGeneralEvaluation"];
    
    //    NSLog(@"%@",str);
    NSString *search = [NSString stringWithFormat:@"[\"and\",  [\"=\", \"status\", \"101\"], [\"=\", \"service_item_id\", \"%@\"], [\"=\", \"deleted\", \"0\"]]",typeStr];
//        NSLog(@"===========search=============%@",search);
    
    NSDictionary *paratemetrs = @{@"search":search,
                                  @"sort":SortType};
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session GET:str parameters:paratemetrs progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"------------%@",responseObject);
        Array = responseObject;
        if (Array.count == 0) {
            //            NSLog(@"000");
            NilLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREEN_HEIGHT/2-20, SCREEN_WIDTH - 60 , 40)];
            NilLabel.text = @"暂无该类型订单~~~";
            NilLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:NilLabel];
        }
        else
        {
            [self getUITableView];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"没进去");
    }];
}


//数据获取完成构成tableView
-(void)getUITableView
{
    uiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 64 + 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 64 -40 - 49) style:UITableViewStylePlain];
    uiTableView.delegate =self;
    uiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    uiTableView.dataSource = self;
    [self.view addSubview:uiTableView];
    
    [uiTableView addLegendHeaderWithRefreshingBlock:^{
        [self reLoadTable];
        [uiTableView.footer endRefreshing];
    }];
}



// UI初始化
-(void)commInit{
    NSArray *vButtonItemArray = @[@{NOMALKEY: @"23242424",
                                    HEIGHTKEY:@"",
                                    TITLEKEY:@"信用卡取现",
                                    TITLEWIDTH:[NSNumber numberWithFloat:100]
                                    },
                                  @{NOMALKEY: @"23242424",
                                    HEIGHTKEY:@"",
                                    TITLEKEY:@"银行卡取现",
                                    TITLEWIDTH:[NSNumber numberWithFloat:100]
                                    },
                                  @{NOMALKEY: @"23242424",
                                    HEIGHTKEY:@"",
                                    TITLEKEY:@"代收款",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"23242424",
                                    HEIGHTKEY:@"",
                                    TITLEKEY:@"外汇",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"23242424",
                                    HEIGHTKEY:@"",
                                    TITLEKEY:@"存钱",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"23242424",
                                    HEIGHTKEY:@"",
                                    TITLEKEY:@"转账",
                                    TITLEWIDTH:[NSNumber numberWithFloat:40*2]
                                    },
                                  @{NOMALKEY: @"23242424",
                                    HEIGHTKEY:@"",
                                    TITLEKEY:@"换整",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"23242424",
                                    HEIGHTKEY:@"",
                                    TITLEKEY:@"换零",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  ];
    
    if (mMenuHriZontal == nil) {
        mMenuHriZontal = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 64 + 64, SCREEN_WIDTH, MENUHEIHT) ButtonItems:vButtonItemArray];
        mMenuHriZontal.delegate = self;
    }
    [mMenuHriZontal clickButtonAtIndex:0];
    [self.view addSubview:mMenuHriZontal];
}


//上面的导航界面
-(void)naviView
{
    //顶部图片
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topImageView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [self.view addSubview:topImageView];
    
    //发单
    UILabel *fadanLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-44)/2, 20, 44, 44)];
    fadanLabel.textColor = [UIColor whiteColor];
    fadanLabel.text =@"发单";
    fadanLabel.backgroundColor = [UIColor clearColor];
    fadanLabel.textAlignment =NSTextAlignmentCenter;
    [topImageView addSubview:fadanLabel];
    
    
    for (int i = 0; i<3; i++) {
        if (i==0) {
            ViewOne = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 64*3)/6 , 64, 64, 64)];
            [self.view addSubview:ViewOne];
            
            UIImageView *imageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake(ViewOne.frame.size.width/20*5, ViewOne.frame.size.width/20*3, ViewOne.frame.size.width/10*5, ViewOne.frame.size.width/20*10)];
            imageViewOne.image = [UIImage imageNamed:@"home_time"];
            [ViewOne addSubview:imageViewOne];
            
            UILabel *labelOne =[[UILabel alloc]initWithFrame:CGRectMake(ViewOne.frame.size.width/20*5, ViewOne.frame.size.width/20*14, ViewOne.frame.size.width/20*10, ViewOne.frame.size.width/20*5)];
            labelOne.text =@"时间";
            labelOne.adjustsFontSizeToFitWidth = YES;
            [ViewOne addSubview:labelOne];
            
            //点击动作
            UITapGestureRecognizer * TapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whichSortOne)];
            ViewOne.userInteractionEnabled = YES;
            [ViewOne addGestureRecognizer:TapGestureRecognizer];
            
        }
        if (i==1) {
            ViewTwo = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 -32, 64, 64, 64)];
            [self.view addSubview:ViewTwo];
            
            UIImageView *imageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(ViewOne.frame.size.width/20*5, ViewOne.frame.size.width/20*3, ViewOne.frame.size.width/10*5, ViewOne.frame.size.width/20*10)];
            imageViewTwo.image = [UIImage imageNamed:@"home_amount"];
            [ViewTwo addSubview:imageViewTwo];
            
            UILabel *labelTwo =[[UILabel alloc]initWithFrame:CGRectMake(ViewOne.frame.size.width/20*5, ViewOne.frame.size.width/20*14, ViewOne.frame.size.width/20*10, ViewOne.frame.size.width/20*5)];
            labelTwo.text =@"金额";
            labelTwo.adjustsFontSizeToFitWidth = YES;
            [ViewTwo addSubview:labelTwo];
            
            //点击动作
            UITapGestureRecognizer * TapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whichSortTwo)];
            ViewTwo.userInteractionEnabled = YES;
            [ViewTwo addGestureRecognizer:TapGestureRecognizer];
        }
        if (i==2) {
            ViewThree = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-64- (SCREEN_WIDTH - 64*3)/6, 64, 64, 64)];
            [self.view addSubview:ViewThree];
            
            UIImageView *imageViewThree = [[UIImageView alloc]initWithFrame:CGRectMake(ViewOne.frame.size.width/20*5, ViewOne.frame.size.width/20*3, ViewOne.frame.size.width/10*5, ViewOne.frame.size.width/20*10)];
            imageViewThree.image = [UIImage imageNamed:@"home_position"];
            [ViewThree addSubview:imageViewThree];
            
            UILabel *labelThree =[[UILabel alloc]initWithFrame:CGRectMake(ViewOne.frame.size.width/20*5, ViewOne.frame.size.width/20*14, ViewOne.frame.size.width/20*10, ViewOne.frame.size.width/20*5)];
            labelThree.text =@"位置";
            labelThree.adjustsFontSizeToFitWidth = YES;
            [ViewThree addSubview:labelThree];
            
            //点击动作
            UITapGestureRecognizer * TapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(whichSortThree)];
            ViewThree.userInteractionEnabled = YES;
            [ViewThree addGestureRecognizer:TapGestureRecognizer];
        }
    }
}


//每行CELL的高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    return  320*ydp;
}


//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  Array.count;
}


//自定义cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    NSString * str =@"cell";
    AllTableViewCell  *cell =[tableView dequeueReusableCellWithIdentifier:str];
    
    if (!cell)
    {
        cell =[[[NSBundle mainBundle]loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil]objectAtIndex:0];
        
        //谁发起和交易类型和金额label
        moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(125*xdp, 35*ydp, 450*xdp, 40*ydp)];
//        moneyLabel.backgroundColor = [UIColor blueColor];
        [moneyLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
        moneyLabel.font = [UIFont systemFontOfSize:17];
        moneyLabel.adjustsFontSizeToFitWidth = YES;
//        moneyLabel.text = @"fsy 信用卡取现 2.0¥";
        [cell addSubview:moneyLabel];
        
        //订单状态按钮
        CGRect frame = CGRectMake(600*xdp, 120*ydp, 140*xdp, 60*ydp);
        dingdanzhuangtaiButton = [[HTPressableButton alloc] initWithFrame:frame buttonStyle:HTPressableButtonStyleRounded];
        dingdanzhuangtaiButton.buttonColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
        dingdanzhuangtaiButton.shadowColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:0.5];
        dingdanzhuangtaiButton.userInteractionEnabled = YES;
        dingdanzhuangtaiButton.titleLabel.font = [UIFont systemFontOfSize:15];
        dingdanzhuangtaiButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [cell addSubview:dingdanzhuangtaiButton];
//
        //左边的头像
        UIImageView *leftAvatarView = [[UIImageView alloc]initWithFrame:CGRectMake(20*xdp, 50*ydp, 100*xdp, 100*xdp)];
        leftAvatarView.image = [UIImage imageNamed:@"home_user"];
        [cell addSubview:leftAvatarView];
//
        //地点的图片
        UIImageView *leftPlaceView = [[UIImageView alloc]initWithFrame:CGRectMake(125*xdp, 237.5*ydp, 25*xdp, 25*ydp)];
//        leftPlaceView.backgroundColor = [UIColor greenColor];
        leftPlaceView.image = [UIImage imageNamed:@"home_order_receiving_positioon"];
        [cell addSubview:leftPlaceView];
//
        //时间限制的图片
        UIImageView *timeLimitView = [[UIImageView alloc]initWithFrame:CGRectMake(125*xdp, 182.5*ydp, 25*xdp, 25*xdp)];
//        timeLimitView.backgroundColor = [UIColor redColor];
        timeLimitView.image = [UIImage imageNamed:@"home_order_receiving_time"];
        [cell addSubview:timeLimitView];

        //距离的图片
        UIImageView *juliView = [[UIImageView alloc]initWithFrame:CGRectMake(600*xdp,45*ydp,25*xdp, 30*xdp)];
        juliView.image = [UIImage imageNamed:@"home_order_receiving_distance"];
        [cell addSubview:juliView];
        
        //上面的灰色
        UIImageView *topGrayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15*ydp)];
        topGrayView.image = [UIImage imageNamed:@"RenRenGray"];
        [cell addSubview:topGrayView];
       
       
        //赏金label
        tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(125*xdp, 125*ydp, 120*xdp, 30*ydp)];
//        tipLabel.backgroundColor = [UIColor blueColor];
        [cell addSubview:tipLabel];
        
        //跑腿label
        paotuiLabel = [[UILabel alloc]initWithFrame:CGRectMake(250*xdp, 125*ydp, 130*xdp, 30*ydp)];
//        paotuiLabel.backgroundColor = [UIColor blueColor];
        [cell addSubview:paotuiLabel];

        //地点label
       placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(155*xdp, 210*ydp, 430*xdp, 80*xdp)];
//                placeLabel.backgroundColor = [UIColor blueColor];
        placeLabel.numberOfLines = 0;
        [cell addSubview:placeLabel];
        
        //时间限制label
        timeLimitLabel = [[UILabel alloc]initWithFrame:CGRectMake(155*xdp, 180*ydp, 430*xdp, 30*xdp)];
        [cell addSubview:timeLimitLabel];

        //地点距离label
        juliLabel = [[UILabel alloc]initWithFrame:CGRectMake(640*xdp,35*ydp,90*xdp, 50*xdp)];
//        juliLabel.backgroundColor = [UIColor blueColor];
        [cell addSubview:juliLabel];
        
    }

    
    //创建个人中心 显示个人中心列表数据
    NSUInteger row = [indexPath row];
//    NSLog(@"%lu",(unsigned long)row);
    int moneyTip =[Array[row][@"tip"] intValue];
    int moneuService  = [Array[row][@"service_charge"] intValue];
//    NSLog(@"%@",Array[row]);
    
    //谁交易类型和金额
    NSString *moneyWho= Array[row][@"sender"][@"username"];
  NSArray  *all_service_itemArray = [[NSArray alloc]initWithObjects:@"",@"信用卡取现",@"银行卡取现",@"代收款",@"外汇",@"存钱",@"转账",@"换整",@"换零", nil];
    NSString *moneyType=all_service_itemArray[[Array[row][@"service_item_id"] intValue]];
    NSString *moneyCount = Array[row][@"money"];
    
    NSString *status0 =[NSString stringWithFormat:@"%@",Array[row][@"status"]];
    if ([status0 isEqualToString:@"101"]) {
//        NSString *jieDanTiShi = @"接单后显示服务者";
         NSString *str1 = [moneyWho substringWithRange:NSMakeRange(0, 7)];
        moneyLabel.text = [NSString stringWithFormat:@"%@**** %@ %@¥",str1,moneyType,moneyCount];
 

    }
    
    moneyLabel.font = [UIFont systemFontOfSize:15];
//    moneyLabel.backgroundColor = [UIColor greenColor];
    
    tipLabel.text =[NSString stringWithFormat:@"赏%d¥",moneyTip];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    tipLabel.adjustsFontSizeToFitWidth = YES;
    paotuiLabel.text =[NSString stringWithFormat:@"跑腿%d¥",moneuService];
    paotuiLabel.font = [UIFont systemFontOfSize:12];
    paotuiLabel.textColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    paotuiLabel.adjustsFontSizeToFitWidth = YES;
    if ([Array[row][@"dealt_at"] isEqual:[NSNull null]]) {
         placeLabel.text = @"";
    }
    else
    {
    placeLabel.text =[NSString stringWithFormat:@"%@",Array[row][@"dealt_at"]];
    }
    placeLabel.font = [UIFont systemFontOfSize:11];
//    timeLimitLabel.text =[NSString stringWithFormat:@"%@",Array[row][@"time_limit"]];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:[Array[row][@"time_limit"] intValue]/1];
    
    timeLimitLabel.text = [[NSString stringWithFormat:@"%@",d] substringToIndex:19];
    timeLimitLabel.font = [UIFont systemFontOfSize:13];
    float arrayLatitude = [Array[row][@"latitude"] floatValue];
    
    float arrayLongtitude = [Array[row][@"longitude"] floatValue];
    //距离

    
//    NSLog(@"---------%lf---------%lf",currentLatitude,currentLongtitude);
    //第一个坐标
    CLLocation *current=[[CLLocation alloc] initWithLatitude:currentLatitude longitude:currentLongtitude];
    //第二个坐标
    CLLocation *before=[[CLLocation alloc] initWithLatitude:arrayLatitude longitude:arrayLongtitude];
    // 计算距离
    CLLocationDistance meters=[current distanceFromLocation:before];
    float _meter = meters/1000;
    juliLabel.text =[NSString stringWithFormat:@"%.2f km",_meter];
    juliLabel.numberOfLines = 0;
    juliLabel.font = [UIFont systemFontOfSize:8];
    
    
    //右侧订单状态的按钮显示
    NSString *status =[NSString stringWithFormat:@"%@",Array[row][@"status"]];
    NSString *ordersStatus;
    if ([status isEqualToString:@"101"]) {
        ordersStatus = @"接单";
        [ dingdanzhuangtaiButton addTarget:self action:@selector(dingDanAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([status isEqualToString:@"102"]) {
        ordersStatus = @"订单已取消";
    }
    else if ([status isEqualToString:@"201"]) {
        ordersStatus = @"已接单";
    }
    else if ([status isEqualToString:@"202"]) {
        ordersStatus = @"暂停";
    }
    else if ([status isEqualToString:@"301"]) {
        ordersStatus = @"订单完成";
    }
    else if ([status isEqualToString:@"302"]) {
        ordersStatus = @"失败";
    }
    else
    {
        ordersStatus = @"数据异常";
    }

    //订单状态值
    [dingdanzhuangtaiButton setTitle:ordersStatus forState:UIControlStateNormal];

//    NSLog(@"------senderAvgOfGeneralEvaluation----------%ld",[Array[row][@"senderAvgOfGeneralEvaluation"] integerValue]);
     //五角星评分
    NSInteger fenshu = [Array[row][@"senderAvgOfGeneralEvaluation"] integerValue];
    for (int i = 0 ; i<5; i++) {
       
        UIImageView *FiveView = [[UIImageView alloc]initWithFrame:CGRectMake(125*xdp + 30*xdp*i, 80*ydp, 25*xdp, 25*xdp)];
        FiveView.userInteractionEnabled = NO;
        if (i < fenshu) {
             FiveView.image = [UIImage imageNamed:@"home_order_receiving_star1"];
        }else{
             FiveView.image = [UIImage imageNamed:@"home_order_receiving_star2"];
        }
        [cell addSubview:FiveView];
    }
    
    
    
//    if ([arr isEqual:@[] ]) {
//        wufenLabel.text = @"0分";
//    }else{
//        jieshoudingdanButton.hidden = YES;
//        wufenLabel.text = [NSString stringWithFormat:@"%@分",arr[0][@"general_evaluation"]];
//        NSArray * fenShuArr = @[yiFen,erFen,sanFen,siFen,wuFen];
//        for (int i = 0 ; i<[arr[0][@"general_evaluation"] integerValue] ; i++) {
//            UIImageView *_image = fenShuArr[i];
//            _image.image = [UIImage imageNamed:@"home_order_receiving_star1"];
//        }
//        //        NSLog(@"=======fenshu====%@", arr[0] );
//    }
    
    
    UIColor* color=[UIColor whiteColor];//通过RGB来定义颜色
    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];

    cell.selectedBackgroundView.backgroundColor=color;
    return cell;
}



//点击列表事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"点击了%ld",(long)indexPath.row);
    xiangqingViewController *detail = [[xiangqingViewController alloc]init];
    detail.xiangqingArray = Array[indexPath.row];
    [self presentViewController:detail animated:NO completion:nil];
}


//点击按钮跳转到详情页
-(void)dingDanAction:(UIButton *)sender
{
    UITableViewCell *cell = sender.superview;
    
    NSIndexPath *path = [uiTableView indexPathForCell: cell];
//    NSLog(@"%@",path);
    xiangqingViewController *detail = [[xiangqingViewController alloc]init];
    detail.xiangqingArray = Array[path.row];
    [self presentViewController:detail animated:NO completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 其他辅助功能
#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
//    NSLog(@"第%ld个Button点击了",(long)aIndex);
//    [mScrollPageView moveScrollowViewAthIndex:aIndex];
    int whichType = [[NSString stringWithFormat:@"%ld",(long)aIndex] intValue] + 1 ;
    typeStr = [NSString stringWithFormat:@"%d",whichType];
//    NSLog(@"第%d个类型，按什么排序",whichType);
    [self reLoadTable];
}

#pragma mark ScrollPageViewDelegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
//    NSLog(@"CurrentPage:%ld",(long)aPage);
    [mMenuHriZontal changeButtonStateAtIndex:aPage];
    //    if (aPage == 3) {
    //刷新当页数据
//    [mScrollPageView freshContentTableAtIndex:aPage];
    //    }
}
#pragma mark 定位
-(void)locationPlace
{
//    NSLog(@"%@",@"定位");
    
}
#pragma mark whichSort第一种排序
-(void)whichSortOne
{
    if ([SortType isEqualToString:@"time_limit"]) {
        SortType = @"-time_limit";
    }
    else
    {
//    NSLog(@"11");
    SortType = @"time_limit";
    }
    [self reLoadTable];
}
#pragma mark whichSort第二种排序
-(void)whichSortTwo
{
    if ([SortType isEqualToString:@"money"]) {
        SortType = @"-money";
    }
    else
    {
//    NSLog(@"22");
    SortType = @"money";
    }
    [self reLoadTable];
}
#pragma mark whichSort第三种排序
-(void)whichSortThree
{
    if ([SortType isEqualToString:@"send_at"]) {
        SortType = @"-send_at";
    }
    else
    {
        //    NSLog(@"22");
        SortType = @"send_at";
    }
    [self reLoadTable];
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
