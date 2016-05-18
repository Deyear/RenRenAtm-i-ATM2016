//
//  httpATM.m
//  RenRenATM
//
//   
//
//

#import "httpATM.h"
#import "AFNetworking/AFNetworking.h"


@implementation httpATM

+(void)setint:(void (^)(NSArray * dic))blok{
    
    NSString *str = [NSString stringWithFormat:@"http://114.215.203.95:82/v1/atm?relation=services,evaluations"];    
   NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   float currentLatitude = [userDefaults floatForKey:@"currentLatitude"];
   float currentLongtitude = [userDefaults floatForKey:@"currentLongtitude"];
    NSString *longitudelongitude = [NSString stringWithFormat:@"%f",currentLongtitude];
    NSString *latitudelatitude = [NSString stringWithFormat:@"%f",currentLatitude];
    NSDictionary *paratemetrs = @{@"longitude":longitudelongitude,
                                  @"latitude":latitudelatitude,
                                  @"radius":@"300000"};
    //                NSLog(@"========%@",paratemetrs);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    [session GET:str parameters:paratemetrs progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //                    NSLog(@"-------------%@",responseObject);
        
        blok(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

+(void)setUserid: (AMapNearbySearchResponse *)geTiIDs setGeTiXinxi :(void (^)(NSArray * geTiInFoArray))blok{

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString * access_token = [userDefault objectForKey:@"access_token"];
    
    NSMutableArray *geTiArray = [[NSMutableArray alloc]init];
 
    NSData* originData = [[NSString stringWithFormat:@"%@%@",access_token,@":"] dataUsingEncoding:NSASCIIStringEncoding];
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *token = [NSString stringWithFormat:@"Basic %@",encodeResult];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    if(geTiIDs.infos.count == 0){
        
         return;
        
    }else{
        
         for (AMapNearbyUserInfo *info in geTiIDs.infos){
            
             NSString *userids = [NSString stringWithFormat:@"%@",info.userID];

        NSString * str =[NSString stringWithFormat:@"http://114.215.203.95:82/v1/users/%@?relation=roles,services",userids];
        
        [session GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [geTiArray addObject:responseObject];
            
            blok(geTiArray);
            

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
        }];
        
         }
   
    }
    
//    blok(geTiArray);
 
}

@end
