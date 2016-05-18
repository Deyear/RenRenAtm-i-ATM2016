//
//  HTTP_Get_UserInfo.m
//  RenRenATM
//
//
//
//

#import "HTTP_Get_UserInfo.h"

@implementation HTTP_Get_UserInfo

+(void)setUserInfo:(void (^)(NSDictionary * dic))blok{

    NSString *access_token,*user_id;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    access_token = [userDefault objectForKey:@"access_token"];
    user_id = [userDefault objectForKey:@"user_id"];

    
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
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
           blok(responseObject);
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    

}

@end
