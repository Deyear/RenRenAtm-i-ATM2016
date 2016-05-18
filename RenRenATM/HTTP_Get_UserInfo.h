//
//  HTTP_Get_UserInfo.h
//  RenRenATM
//
//  Created by 牛牛 on 16/5/11.
//  Copyright © 2016年 com.fsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTP_Get_UserInfo : NSObject

+(void)setUserInfo:(void (^)(NSDictionary * dic))blok;

@end
