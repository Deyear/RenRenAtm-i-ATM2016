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
#import "xiangqingViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface HomeVCTestViewController ()<CLLocationManagerDelegate>{
    
    float currentLatitude,currentLongtitude;                      //当前的经纬度
    
    UILabel *NilLabel;                                            //暂无订单
    
    BFPaperButton *threeButton;                                   //(“时间”、“金额”。“位置”)
  
    NSString *typeStr,*SortType;
    
    CLLocationManager *_locationManager;                          //定位
    
    UITableView *uiTableView;                                     //tableview
    
    NSArray *Array;                                               //订单数据
    
    NSUserDefaults *userDefaults ;

}
@end

@implementation HomeVCTestViewController
@synthesize mMenuHriZontal;
@synthesize xiangqingArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initValue];                     //初始值
    
    [self naviView];                      //上面的导航界面
    
    [self initThreeButton];               //三个点击按钮
    
    [self commInit];                      //初始化UI
    
    [self initLocation];                  //初始化地理定位
        
}

#pragma mark - init Value
-(void)initValue{

    //刷新监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuaxin) name:@"tongzhi111" object:nil];
    SortType = @ "time_limit";
    
    //获取当前的经纬度
    userDefaults = [NSUserDefaults standardUserDefaults];
    currentLatitude = [userDefaults floatForKey:@"currentLatitude"];
    currentLongtitude = [userDefaults floatForKey:@"currentLongtitude"];
    
}

//初始化地理定位
-(void)initLocation{
    
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

#pragma mark - init Views
//上面的导航界面
-(void)naviView{
    
    //顶部图片
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topImageView.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [self.view addSubview:topImageView];
    
    //发单
    UILabel *fadanLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-44)/2, 20, 44, 44)];
    fadanLabel.textColor = [UIColor whiteColor];
    fadanLabel.text =@"接单";
    fadanLabel.backgroundColor = [UIColor clearColor];
    fadanLabel.textAlignment =NSTextAlignmentCenter;
    [topImageView addSubview:fadanLabel];
    
}

//三个点击按钮
-(void)initThreeButton{
    
    UIImageView *imageInButton;         //按钮上的图片
    UILabel *labelInButton;             //按钮上显示的标题
    
    for (int i = 0; i<3; i++) {
        
        threeButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 * i , 64, SCREEN_WIDTH/3, 64)];
        threeButton.backgroundColor = [UIColor whiteColor];
        threeButton.shadowColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
        threeButton.tag = i;
        [self.view addSubview:threeButton];
        
        imageInButton = [[UIImageView alloc]initWithFrame:CGRectMake((threeButton.frame.size.width - threeButton.frame.size.height/10*5) / 2, threeButton.frame.size.height/20*3, threeButton.frame.size.height/10*5, threeButton.frame.size.height/20*10)];
        [threeButton addSubview:imageInButton];
        
        labelInButton =[[UILabel alloc]initWithFrame:CGRectMake((threeButton.frame.size.width - threeButton.frame.size.height/10*5) / 2, threeButton.frame.size.height/20*14, threeButton.frame.size.height/20*10, threeButton.frame.size.height/20*5)];
        labelInButton.adjustsFontSizeToFitWidth = YES;
        [threeButton addSubview:labelInButton];
        
        if (threeButton.tag == 0) {
            
            [threeButton addTarget:self action:@selector(whichSortOne) forControlEvents:UIControlEventTouchUpInside];
            imageInButton.image = [UIImage imageNamed:@"home_time"];
            labelInButton.text = @"时间";
            
        }else if (threeButton.tag == 1){
            
            [threeButton addTarget:self action:@selector(whichSortTwo) forControlEvents:UIControlEventTouchUpInside];
            imageInButton.image = [UIImage imageNamed:@"home_amount"];
            labelInButton.text = @"金额";
            
        }else if (threeButton.tag == 2){
            
            [threeButton addTarget:self action:@selector(whichSortThree) forControlEvents:UIControlEventTouchUpInside];
            imageInButton.image = [UIImage imageNamed:@"home_position"];
            labelInButton.text = @"地点";
            
        }
        
    }
    
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
                                  @{NOMALKEY: @"23242424",
                                    HEIGHTKEY:@"",
                                    TITLEKEY:@"快递",
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

//数据获取完成构成tableView
-(void)getUITableView
{
    uiTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 64 + 40, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 64 -40 - 49) style:UITableViewStylePlain];
    uiTableView.backgroundColor = [UIColor colorWithRed:240.0f/255.0f green:239.0f/255.0f blue:245.0f/255.0f alpha:1];
    uiTableView.delegate =self;
    uiTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    uiTableView.dataSource = self;
    [self.view addSubview:uiTableView];
    
    [uiTableView addLegendHeaderWithRefreshingBlock:^{
        [self reLoadTable];
        [uiTableView.footer endRefreshing];
    }];
    
}

#pragma mark - Button Click Action
//时间排列
-(void)whichSortOne{
    
     if ([SortType isEqualToString:@"time_limit"]) {
         
        SortType = @"-time_limit";
         
    }else{
        
        SortType = @"time_limit";
    
    }
    
    [self reLoadTable];

}

//金额排列
-(void)whichSortTwo{
    
     if ([SortType isEqualToString:@"money"]) {
         
        SortType = @"-money";
    
     }else{
         
         SortType = @"money";
         
    }
    
    [self reLoadTable];

}

//位置排列
-(void)whichSortThree{
    
    if ([SortType isEqualToString:@"send_at"]) {
        
        SortType = @"-send_at";
    
    }else{
 
        SortType = @"send_at";
    
    }
    
    [self reLoadTable];

}

//点击按钮跳转到详情页
-(void)dingDanAction:(UIButton *)sender{
    
    UITableViewCell *cell = sender.superview;
    NSIndexPath *path = [uiTableView indexPathForCell: cell];
    xiangqingViewController *detail = [[xiangqingViewController alloc]init];
    detail.xiangqingArray = Array[path.row];
    [self presentViewController:detail animated:NO completion:nil];
    
}

#pragma mark - Other action
 //刷新
-(void)shuaxin{
    
    [self reLoadTable];

}

//刷新订单
-(void)reLoadTable{
    
    [NilLabel removeFromSuperview];
    [uiTableView removeFromSuperview];
    
    NSString *str = [NSString stringWithFormat:@"http://114.215.203.95:82/v1/orders?relation=sender,senderAvgOfGeneralEvaluation"];
      NSString *search = [NSString stringWithFormat:@"[\"and\",  [\"=\", \"status\", \"101\"], [\"=\", \"service_item_id\", \"%@\"], [\"=\", \"deleted\", \"0\"]]",typeStr];
    
    NSDictionary *paratemetrs = @{@"search":search,
                                  @"sort":SortType};
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session GET:str parameters:paratemetrs progress:^(NSProgress * _Nonnull downloadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
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
     }];
    
}



#pragma mark - tableView
//每行CELL的高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    return  320*ydp;
    
}

//多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  Array.count;

}

//自定义cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * str =@"cell";
    UITableViewCell  *cell =[tableView dequeueReusableCellWithIdentifier:str];
   
    //谁发起和交易类型和金额label
    UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(125*xdp, 35*ydp, 450*xdp, 40*ydp)];
    [moneyLabel setFont:[UIFont fontWithName:@"Helvetica" size:17]];
    moneyLabel.font = [UIFont systemFontOfSize:17];
    moneyLabel.adjustsFontSizeToFitWidth = YES;
    
    //订单状态按钮
    UIButton *dingdanzhuangtaiButton = [[BFPaperButton alloc] initWithFrame:CGRectMake(600*xdp, 120*ydp, 140*xdp, 60*ydp)];
    [dingdanzhuangtaiButton setTitle:@"接单" forState:UIControlStateNormal];
    dingdanzhuangtaiButton.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    dingdanzhuangtaiButton.userInteractionEnabled = YES;
    [dingdanzhuangtaiButton addTarget:self action:@selector(dingDanAction:) forControlEvents:UIControlEventTouchUpInside];
    dingdanzhuangtaiButton.titleLabel.font = [UIFont systemFontOfSize:15];
    dingdanzhuangtaiButton.titleLabel.adjustsFontSizeToFitWidth = YES;

    //左边的头像
    UIImageView *leftAvatarView = [[UIImageView alloc]initWithFrame:CGRectMake(20*xdp, 50*ydp, 100*xdp, 100*xdp)];
    leftAvatarView.image = [UIImage imageNamed:@"home_user"];

    //地点的图片
    UIImageView *leftPlaceView = [[UIImageView alloc]initWithFrame:CGRectMake(125*xdp, 237.5*ydp, 25*xdp, 25*ydp)];
    leftPlaceView.image = [UIImage imageNamed:@"home_order_receiving_positioon"];

    //时间限制的图片
    UIImageView *timeLimitView = [[UIImageView alloc]initWithFrame:CGRectMake(125*xdp, 182.5*ydp, 25*xdp, 25*xdp)];
    timeLimitView.image = [UIImage imageNamed:@"home_order_receiving_time"];

    //距离的图片
    UIImageView *juliView = [[UIImageView alloc]initWithFrame:CGRectMake(600*xdp,45*ydp,25*xdp, 30*xdp)];
    juliView.image = [UIImage imageNamed:@"home_order_receiving_distance"];

    //上面的灰色
    UIImageView *topGrayView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15*ydp)];
    topGrayView.image = [UIImage imageNamed:@"RenRenGray"];

    //赏金label
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(125*xdp, 125*ydp, 120*xdp, 30*ydp)];
  
    //跑腿label
    UILabel *paotuiLabel = [[UILabel alloc]initWithFrame:CGRectMake(250*xdp, 125*ydp, 130*xdp, 30*ydp)];

    //地点label
    UILabel *placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(155*xdp, 210*ydp, 430*xdp, 80*xdp)];
    placeLabel.numberOfLines = 0;

    //时间限制label
    UILabel *timeLimitLabel = [[UILabel alloc]initWithFrame:CGRectMake(155*xdp, 180*ydp, 430*xdp, 30*xdp)];

    //地点距离label
    UILabel *juliLabel = [[UILabel alloc]initWithFrame:CGRectMake(640*xdp,35*ydp,90*xdp, 50*xdp)];

     if (!cell){
        
        cell =[[[NSBundle mainBundle]loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil]objectAtIndex:0];
        
        [cell addSubview:moneyLabel];
        
        [cell addSubview:dingdanzhuangtaiButton];

        [cell addSubview:leftAvatarView];

        [cell addSubview:leftPlaceView];

        [cell addSubview:timeLimitView];

        [cell addSubview:juliView];
        
        [cell addSubview:topGrayView];
       
        [cell addSubview:tipLabel];
        
        [cell addSubview:paotuiLabel];

        [cell addSubview:placeLabel];
        
        [cell addSubview:timeLimitLabel];

        [cell addSubview:juliLabel];
        
    }

    //创建个人中心 显示个人中心列表数据
    NSUInteger row = [indexPath row];
    int moneyTip =[Array[row][@"tip"] intValue];
    int moneuService  = [Array[row][@"service_charge"] intValue];
    
    //谁交易类型和金额
    NSString *moneyWho= Array[row][@"sender"][@"username"];
    NSArray  *all_service_itemArray = [[NSArray alloc]initWithObjects:@"",@"信用卡取现",@"银行卡取现",@"代收款",@"外汇",@"存钱",@"转账",@"换整",@"换零",@"快递", nil];
    NSString *moneyType=all_service_itemArray[[Array[row][@"service_item_id"] intValue]];
    NSString *moneyCount = Array[row][@"money"];
    
    NSString *status0 =[NSString stringWithFormat:@"%@",Array[row][@"status"]];
    if ([status0 isEqualToString:@"101"]) {

        NSString *str1 = [moneyWho substringWithRange:NSMakeRange(0, 7)];
        moneyLabel.text = [NSString stringWithFormat:@"%@**** %@ %@¥",str1,moneyType,moneyCount];
 
    }
    
    moneyLabel.font = [UIFont systemFontOfSize:15];
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
    else{
        
    placeLabel.text =[NSString stringWithFormat:@"%@",Array[row][@"dealt_at"]];
 
    }
    placeLabel.font = [UIFont systemFontOfSize:11];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:[Array[row][@"time_limit"] intValue]/1];
    
    timeLimitLabel.text = [[NSString stringWithFormat:@"%@",d] substringToIndex:19];
    timeLimitLabel.font = [UIFont systemFontOfSize:13];
    float arrayLatitude = [Array[row][@"latitude"] floatValue];
    
    float arrayLongtitude = [Array[row][@"longitude"] floatValue];
    //距离
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
 
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    return cell;

}

 //点击列表事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    xiangqingViewController *detail = [[xiangqingViewController alloc]init];
    detail.xiangqingArray = Array[indexPath.row];
    [self presentViewController:detail animated:NO completion:nil];

}

#pragma mark MenuHrizontalDelegate
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
 
    int whichType = [[NSString stringWithFormat:@"%ld",(long)aIndex] intValue] + 1 ;
    NSLog(@"\n\n%ld",(long)aIndex);
    typeStr = [NSString stringWithFormat:@"%d",whichType];
 
    [self reLoadTable];

}

#pragma mark ScrollPageView  Delegate
-(void)didScrollPageViewChangedPage:(NSInteger)aPage{
 
    [mMenuHriZontal changeButtonStateAtIndex:aPage];
 
}

#pragma mark - locationManager  Delegate
//获取当前经纬度
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    
    float latitude =  coor.latitude;
    float longtitude = coor.longitude;
    
    //将当前位置存储在本地
    [userDefaults setFloat:latitude forKey:@"currentLatitude"];
    [userDefaults setFloat:longtitude forKey:@"currentLongtitude"];
    [userDefaults synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 推送





@end
