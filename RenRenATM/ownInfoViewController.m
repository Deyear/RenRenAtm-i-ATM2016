//
//  ownInfoViewController.m
//  RenRenATM
//
//
//
//个人信息

#define changeViewFrame  (changgeView.frame.size)

#import "ownInfoViewController.h"
#import "MustLogin.h"

@interface ownInfoViewController ()<UIAlertViewDelegate,UITextFieldDelegate>{

    NSString *name,*sex,*callNumber,*address,*birth,*mail,*service;
    
    NSString *access_token,*urlString,*phoneNumber,*user_id;
    
    NSString *openTime,*closeTime;
    
    NSDictionary *parameters;                                     //参数
    
    UIView *changgeView;                        //更改信息的view
    UIControl *backClick;                       //可点击的背景
    BFPaperButton *queDingButton;                    //更改的确定按钮
    LRTextField *niCheng;                        //昵称
    BFPaperButton *sexBUtton1,*sexBUtton2;       //男女性别
  
    IBOutlet UITextField *hourOne;

    IBOutlet UITextField *secondOne;
    
    IBOutlet UITextField *hourTwo;
    
    IBOutlet UITextField *secondTwo;
    
    IBOutlet UIButton *changTimeButton;
    
}

@property (strong, nonatomic) IBOutlet UITextField *nameText;

@property (strong, nonatomic) IBOutlet UITextField *sexText;

@property (strong, nonatomic) IBOutlet UITextField *callNumberText;

@property (strong, nonatomic) IBOutlet UITextField *addressText;

@property (strong, nonatomic) IBOutlet UITextField *mailText;

@property (strong, nonatomic) IBOutlet UITextField *serviceText;

@property (strong, nonatomic) IBOutlet UIButton *changeNameButton;

@end

@implementation ownInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initValues];
    
    [self getInfo];             //得到用户信息
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 }

#pragma mark -  init Values
-(void)initValues{
    
    _nameText.enabled = NO;

    _sexText.enabled = NO;

    _addressText.enabled = NO;

    _mailText.enabled = NO;

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    access_token = [userDefault objectForKey:@"access_token"];
    phoneNumber = [userDefault objectForKey:@"user_name"];
    user_id = [userDefault objectForKey:@"user_id"];
    urlString =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/user/edit-user"];
    //更改页面
    changgeView = [[UIView alloc] initWithFrame:CGRectMake(20, (SCREEN_HEIGHT - 200)/2, SCREEN_WIDTH - 40, SCREEN_HEIGHT * 150 / 568)];  //所有添加的view
    changgeView.backgroundColor = [UIColor whiteColor];
    
    //灰色可点击背景
    backClick = [[UIControl alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backClick.backgroundColor = [UIColor blackColor];
    backClick.alpha = 0.5;
    [backClick addTarget:self
                  action:@selector(backClickAction)
        forControlEvents:UIControlEventTouchUpInside];
    
    //更改页面的确定按钮
    queDingButton = [[BFPaperButton alloc] initWithFrame:CGRectMake( (changeViewFrame.width - 80)/2,changeViewFrame.height * 85 / 150, 80, changeViewFrame.height * 45 / 150)];
    [queDingButton setTitle:@"确定" forState:UIControlStateNormal];
    [queDingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    queDingButton.backgroundColor = [UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1];
    [queDingButton addTarget:self
                      action:@selector(changVIewAction:)
            forControlEvents:UIControlEventTouchUpInside];
    
    if (access_token==nil) {

        UIAlertView *_alert = [[UIAlertView alloc]
                               initWithTitle:@"您尚未登录！"
                               message:@"请先登录后操作"
                               delegate:self
                               cancelButtonTitle:@"确定"
                               otherButtonTitles:nil, nil];
        [_alert show];
        
    }
    
}

-(void)getInfo{
    
    NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];

    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/users/%@?relation=roles",user_id];
    
    [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//                    NSLog(@"全部订单数据%@",downloadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"\n\n\n%@",responseObject);
        NSDictionary *arr1 = responseObject;
        NSArray *Arr = arr1[@"roles"];
        if (Arr.count == 0) {
            
            service = @"";
            
        }else{
        
            service = Arr[0][@"name"];
            if ([service isEqual:[NSNull null]]) {
                
                service = @"";
                
            }

        }
        
        address = arr1[@"address"];
        if ([address isEqual:[NSNull null]]) {
            
            address = @"";
            
        }

        birth = arr1[@"birthday"];
        if ([birth isEqual:[NSNull null]]) {
            
            birth = @"";
            
        }
        
        mail = arr1[@"email"];
        if ([mail isEqual:[NSNull null]]) {
            
            mail = @"";
            
        }
        
        name = arr1[@"nickname"];
        if ([name isEqual:[NSNull null]]) {
            
            name = @"";
            
        }
       
        if ([sex isEqual:[NSNull null]]) {
            
            sex = @"";
            
        }else if ( [arr1[@"sex"] isEqualToString:@"woman"] ){
        
            sex = @"女";

        }else{
        
            sex = @"男";
        }

        callNumber = arr1[@"username"];
        if ([callNumber isEqual:[NSNull null]]) {
            
            callNumber = @"";
            
        }
        
        openTime = arr1[@"opening_time"];
        closeTime = arr1[@"closing_time"];

        if ([openTime isEqual:[NSNull null]]) {
            
            hourOne.text = @"";
            hourOne.enabled = NO;
            secondOne.text = @"";
            secondOne.enabled = NO;
            
            hourTwo.text = @"";
            hourTwo.enabled = NO;
            secondTwo.text = @"";
            secondTwo.enabled = NO;

            changTimeButton.hidden = YES;
            
        }else{
        
            if ([service isEqual: @"普通用户"]) {
                
                hourOne.text = @"";
                hourOne.enabled = NO;
                secondOne.text = @"";
                secondOne.enabled = NO;
                
                hourTwo.text = @"";
                hourTwo.enabled = NO;
                secondTwo.text = @"";
                secondTwo.enabled = NO;
                
                changTimeButton.hidden = YES;
            }else{
                
                NSInteger openTimeInt = [openTime intValue];
                NSInteger openHour = openTimeInt / 3600000;
                hourOne.text = [NSString stringWithFormat:@"%ld",(long)openHour];
                long openSeconds = openTimeInt / 60000;
                long openMinutes = openSeconds % 60;
                if (openMinutes < 10) {
                    
                    secondOne.text = [NSString stringWithFormat:@"0%ld",(long)openMinutes];
                    
                }else{
                    
                    secondOne.text = [NSString stringWithFormat:@"%ld",(long)openMinutes];
                    
                }
                
                
                closeTime = arr1[@"closing_time"];
                NSInteger closeTimeInt = [closeTime intValue];
                NSInteger closeHour = closeTimeInt / 3600000;
                hourTwo.text = [NSString stringWithFormat:@"%ld",(long)closeHour];
                long closeSeconds = closeTimeInt / 60000;
                long closeMinutes = closeSeconds % 60;
                if (closeMinutes < 10) {
                    
                    secondTwo.text = [NSString stringWithFormat:@"0%ld",(long)closeMinutes];
                    
                }else{
                    
                    secondTwo.text = [NSString stringWithFormat:@"%ld",(long)closeMinutes];
                    
                }
                
                changTimeButton.hidden = NO;
                
            }
        
        }
      
        self.sexText.text = sex;
        
        self.callNumberText.text = callNumber;
        
        self.addressText.text = address;

        self.mailText.text = mail;
        
        self.nameText.text = name;
        
        self.serviceText.text = service;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

#pragma mark -  Button Click Action
//背景点击事件
-(void)backClickAction{

    [backClick removeFromSuperview];
    [changgeView removeFromSuperview];

}

//确定按钮的点击事件
-(void)changVIewAction:(UIButton *)sender {

    if ( sender.tag == 0) {
        
        _nameText.text = niCheng.text;
        
        parameters = @{@"username":callNumber,
                       @"nickname":_nameText.text};
        
        [backClick removeFromSuperview];
        [changgeView removeFromSuperview];
        
    }else if (sender.tag == 2){
    
        _addressText.text = niCheng.text;

        parameters = @{@"username":callNumber,
                       @"address":_addressText.text};

        [backClick removeFromSuperview];
        [changgeView removeFromSuperview];

    }else if (sender.tag == 3){
    
        _mailText.text = niCheng.text;
        
        parameters = @{@"username":callNumber,
                       @"address":_mailText.text};
        
        [backClick removeFromSuperview];
        [changgeView removeFromSuperview];
        
    }

    [self changgeHttp];
}

//选择性别
-(void)selectSex:(UIButton *)sender{

    NSLog(@"%ld",(long)sender.tag);
    if ( sender.tag == 1) {
        
//        NSString *sexCurent;
//        if ( [_sexText.text isEqualToString:@"男"] ) {
//            
//            sexCurent = @"man";
//            
//        }else{
//            
//            sexCurent = @"woman";
//        }
        
        _sexText.text = @"男";
        parameters = @{@"username":callNumber,
                       @"sex":@"man"};
        
        [backClick removeFromSuperview];
        [changgeView removeFromSuperview];
        
    }else if (sender.tag == 2){
        
        _sexText.text = @"女";

        parameters = @{@"username":callNumber,
                       @"sex":@"woman"};
        
        [backClick removeFromSuperview];
        [changgeView removeFromSuperview];
    
    }
    
    [self changgeHttp];
}
//返回
- (IBAction)goBack:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)initNiCheng{

    [self.view addSubview:backClick];
    [self.view addSubview:changgeView];

    [niCheng removeFromSuperview];
    [sexBUtton1 removeFromSuperview];
    [sexBUtton2 removeFromSuperview];
    
    niCheng = [[LRTextField alloc] initWithFrame:CGRectMake(20, changeViewFrame.height * 20 / 150, changeViewFrame.width - 40, changeViewFrame.height * 45 / 150)];
    niCheng.textAlignment = NSTextAlignmentCenter;
    niCheng.delegate = self;
    niCheng.borderStyle = UITextBorderStyleNone;

}
//更改按钮
- (IBAction)changeButtons:(UIButton *)sender {
  
    if (sender.tag == 0) {
        
        [self initNiCheng];
        niCheng.placeholder = @"请输入您的昵称";
        [changgeView addSubview:niCheng];
        queDingButton.tag = 0;
        [changgeView addSubview:queDingButton];
        
    }else if (sender.tag == 1){
    
        [self.view addSubview:backClick];
        [self.view addSubview:changgeView];
        
        [sexBUtton1 removeFromSuperview];
        [sexBUtton2 removeFromSuperview];
        [niCheng removeFromSuperview];
        
        sexBUtton1 = [[BFPaperButton alloc ] initWithFrame:CGRectMake(0, 0, changeViewFrame.width, changeViewFrame.height / 2 )];
        sexBUtton1.backgroundColor = [UIColor whiteColor];
        [sexBUtton1 setTitle:@"男" forState:UIControlStateNormal];
        [sexBUtton1 setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
        sexBUtton1.tag = 1;
        [sexBUtton1 addTarget:self
                       action:@selector(selectSex:)
             forControlEvents:UIControlEventTouchUpInside];

        sexBUtton2 = [[BFPaperButton alloc ] initWithFrame:CGRectMake(0, changeViewFrame.height / 2, changeViewFrame.width, changeViewFrame.height / 2 )];
        sexBUtton2.backgroundColor = [UIColor whiteColor];
        [sexBUtton2 setTitle:@"女" forState:UIControlStateNormal];
        [sexBUtton2 setTitleColor:[UIColor colorWithRed:71.0f/255.0f green:116.0f/255.0f blue:184.0f/255.0f alpha:1] forState:UIControlStateNormal];
        sexBUtton2.tag = 2;
        [sexBUtton2 addTarget:self
                       action:@selector(selectSex:)
             forControlEvents:UIControlEventTouchUpInside];

        [changgeView addSubview:sexBUtton1];
        [changgeView addSubview:sexBUtton2];
        
    }else if (sender.tag == 2){

        [self initNiCheng];
        niCheng.placeholder = @"请输入您的地理位置";
        [changgeView addSubview:niCheng];
        queDingButton.tag = 2;
        [changgeView addSubview:queDingButton];
        
    }else if (sender.tag == 3){
  
        [self initNiCheng];
         niCheng.placeholder = @"请输入您的邮箱";
        [changgeView addSubview:niCheng];
        queDingButton.tag = 3;
        [changgeView addSubview:queDingButton];
        
    }else if (sender.tag == 4){
        
        [changgeView removeFromSuperview];
        [backClick removeFromSuperview];
        NSString *hourOpenStr = hourOne.text;
        NSInteger openHourInt = [hourOpenStr intValue];
        NSString *minutesOpenStr = secondOne.text;
        NSInteger openMinutesInt = [minutesOpenStr intValue];
        NSInteger  openSetTime = openHourInt * 3600000 + openMinutesInt * 60000;
        NSString *openStr = [NSString stringWithFormat:@"%ld",(long)openSetTime];
        
        NSString *hourCloseStr = hourTwo.text;
        NSInteger closeHourInt = [hourCloseStr intValue];
        NSString *minutesCloseStr = secondTwo.text;
        NSInteger closeMinutesInt = [minutesCloseStr intValue];
        NSInteger  closeSetTime = closeHourInt * 3600000 + closeMinutesInt * 60000;
        NSString *closeStr = [NSString stringWithFormat:@"%ld",(long)closeSetTime];

        parameters = @{@"username":callNumber,
                       @"opening_time":openStr,
                       @"closing_time":closeStr} ;
        
        [self changgeHttp];
        
    }

 }

#pragma mark - other Action
-(void)changgeHttp{
    
    NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    [session POST:urlString
       parameters:parameters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              NSLog(@"\n\n\n\n\n\n\n----------responseObject---------\n%@",responseObject);
              UIAlertView *notiAlert = [[UIAlertView alloc]
                                        initWithTitle:nil
                                        message:@"更改成功！"
                                        delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
              
              [notiAlert show];
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
              UIAlertView *notiAlert = [[UIAlertView alloc]
                                        initWithTitle:nil
                                        message:@"更改失败！"
                                        delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
              
              [notiAlert show];
              
          }];
    
}

#pragma mark - alertView 代理
//提示框消失后跳转到登录界面
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    MustLogin *login = [[MustLogin alloc]init];
    [self presentViewController:login animated:YES completion:nil];
}

#pragma mark  UITextField
//点击Return键盘回收
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // 回收键盘,取消第一响应者
    [textField resignFirstResponder];
    
    return YES;
    
}

//#pragma mark -  UITabView 代理
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 60;
//    
//}
//
//-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
//    
//    return  44;
//    
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return 2;
//
//}
//
////第section组有多少行
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    
//   if (0 == section) {
//          // 第0组有多少行
//             return 2;
//           }else
//              {
//                      // 第1组有多少行
//                       return 3;
//                    }
//    }
//
// - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
// 
//      if (0 == indexPath.section) {
//          
//           if (0 == indexPath.row){
//               
//                cell.textLabel.text = @"奥迪";
//               
//            }else if (1 == indexPath.row){
//                
//                cell.textLabel.text = @"宝马";
//                
//            }
//       
//        }else if (1 == indexPath.section){
//            
//            if (0 == indexPath.row) {
//                
//                cell.textLabel.text = @"本田";
//                
//            }else if (1 == indexPath.row){
//                
//                cell.textLabel.text = @"丰田";
//                
//            }else if (2 == indexPath.row){
//                
//                cell.textLabel.text = @"马自达";
//                
//            }
//            
//        }
//     
//     return cell;
// 
// }
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//  
//    if (0 == section) {
//     
//        return @"德系品牌";
//      
//    }else
//        
//    {
//        
//        return @"日韩品牌";
//        
//    }
//  
//}

  /*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
