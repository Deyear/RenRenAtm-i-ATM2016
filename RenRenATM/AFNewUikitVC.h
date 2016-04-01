//
//  AFNewUikitVC.h
//  RenRenATM
//
//  Created by 方少言 on 16/1/7.
//  Copyright © 2016年 com.fsy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFNewUikitVC : NSObject
//个人注册
+(void)users:(NSString*) username   password:(NSString*)password  password_repeat:(NSString*) password_repeat  setint:(void (^)(NSDictionary * dic))blok;
@end
