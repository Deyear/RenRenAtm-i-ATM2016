//
//  AFNewUikitVC.m
//  RenRenATM
//
//  Created by 方少言 on 16/1/7.
//  Copyright © 2016年 com.fsy. All rights reserved.
//

#import "AFNewUikitVC.h"
#import "AFNetworking.h"
#define API   @"114.215.203.95:82/v1"
@implementation AFNewUikitVC
//注册
+(void)users:(NSString*) username   password:(NSString*)password  password_repeat:(NSString*) password_repeat  setint:(void (^)(NSDictionary * dic))blok
{
//    NSString * str =[NSString stringWithFormat:@"%@/users",API];
//    
//    AFHTTPRequestOperationManager * manager =[AFHTTPRequestOperationManager manager];
//    NSDictionary * parameters =@{@"username":username,@"password":password,@"password_repeat":password_repeat};
//    [manager POST:str parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];

}
@end
