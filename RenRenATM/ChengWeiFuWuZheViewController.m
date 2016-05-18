
//
//  ChengWeiFuWuZheViewController.m
//  RenRenATM
//
//
//
//成为服务者

#import "ChengWeiFuWuZheViewController.h"

@interface ChengWeiFuWuZheViewController (){

    BFPaperButton *submitButton;

    NSString *ONE,*TWO,*THREE,*FOUR,*FIVE,*SIX,*SEVEN,*EIGHT;  //1~0
    
    NSString *phoneNumber,*access_token;                      //用户手机号
    
    NSMutableArray *servics_idsArr;             //用于存储服务类型
    
    NSString *ownGeRen;

    IBOutlet UIButton *geRenButton;
}

@end

@implementation ChengWeiFuWuZheViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initButton];               //初始化确定按钮
    
    [self initValue];                 //初始值
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

#pragma mark - init
-(void)initValue{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    phoneNumber = [userDefault objectForKey:@"user_name"];
    access_token = [userDefault objectForKey:@"access_token"];
    
    servics_idsArr = [[NSMutableArray alloc]init];
    
    //八个功能选择
    ONE=@"1";
    TWO=@"2";
    THREE =@"3";
    FOUR = @"4";
    FIVE =@"5";
    SIX = @"6";
    SEVEN =@"7";
    EIGHT = @"8";


}
-(void)initButton{

    submitButton = [[BFPaperButton alloc]initWithFrame:CGRectMake(40, SCREEN_HEIGHT *450/568, SCREEN_WIDTH - 80, SCREEN_HEIGHT * 40/568)];
    submitButton.titleLabel.numberOfLines = 0;
    submitButton.layer.cornerRadius =20;
    submitButton.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    submitButton.cornerRadius = SCREEN_HEIGHT * 22/568;
    [submitButton setTitle:@"确定" forState:UIControlStateNormal];
     [submitButton setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.f]];
    [submitButton addTarget:self action:@selector(queDing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];


}
#pragma mark - Button Click Action
//返回
- (IBAction)goBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//打勾的按钮事件
- (IBAction)daGouButton:(UIButton *)sender {
 
    if (sender.tag == 10) {
        
        [sender setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        
        ownGeRen = @"个人";
        
    }else{
        
        [sender setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateNormal];
        NSString *tagStr = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        
        if (servics_idsArr.count >0) {
            
            for (int i = 0; i < servics_idsArr.count; i++) {
                
                NSString *str  = servics_idsArr[i];
                if (str == tagStr) {
                    
                    [servics_idsArr removeObject:str];
                    
                }else{
                    
                    [servics_idsArr addObject:tagStr];
                    
                }
            }

        }else{
        
            
        }
        
        [servics_idsArr addObject:tagStr];

    }

 
}

//成为服务者
-(void)queDing{
    
    NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    if ([ownGeRen  isEqual: @"个人"]) {
        
        //服务类型
        NSMutableString *service_item_ids;
        if (servics_idsArr.count == 0) {
            
            UIAlertView *notiAlert = [[UIAlertView alloc]
                                      initWithTitle:nil
                                      message:@"请选择服务项目"
                                      delegate:nil
                                      cancelButtonTitle:@"确定"
                                      otherButtonTitles:nil, nil];
            [notiAlert show];
            
        }else{
            
            service_item_ids = [[NSMutableString alloc]init];
            for (int i = 0; i<servics_idsArr.count; i++) {
                if (i == 0) {
                    
                    [service_item_ids appendString:[NSString stringWithFormat:@"%@",servics_idsArr[i] ] ];
                    
                }else{
                    
                    [service_item_ids appendString:[NSString stringWithFormat:@",%@",servics_idsArr[i] ] ];
                    
                }
                
            }
            
            
        }
        
//        NSLog(@"--------numbrer---------%@",phoneNumber);
//        NSLog(@"--------service_item_ids---------%@",service_item_ids);
//        NSLog(@"\n-------servics_idsArr---------\n%@",servics_idsArr);
        
        
        NSString * URL =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/user/server-update"];
        
        
        NSDictionary *parameters = @{@"username":phoneNumber,
                                         @"role":@"个体服务者",
                                         @"service_item_ids":service_item_ids};
        
        NSLog(@"\n\n\n%@",parameters);
        
            [session POST:URL
               parameters:parameters
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                      NSLog(@"\n\n\n\n\n\n\n----------responseObject---------\n%@",responseObject);
                      UIAlertView *notiAlert = [[UIAlertView alloc]
                                                initWithTitle:nil
                                                message:@"欢迎成为服务者！"
                                                delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
        
                      [notiAlert show];
        
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
                      UIAlertView *notiAlert = [[UIAlertView alloc]
                                                initWithTitle:nil
                                                message:@"欢迎成为服务者！"
                                                delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
                      
                      [notiAlert show];
//                      NSLog(@"\n\n\n\n\n\n\n----------erroe---------\n%@",error);
        
                  }];

    }else{
    
        UIAlertView *notiAlert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:@"请选择服务者类型！"
                                  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil, nil];
        
        [notiAlert show];

    }


}

@end
