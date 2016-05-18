//
//  AppDelegate.h
//  RenRenATM
//
//  Created by 方少言 on 15/12/22.
//  Copyright © 2015年 com.fsy. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *JiGuangappKey = @"9b9df0f0927309aa38765b2b";  //极光Key
//static NSString *JiGuangchannel = @"Publish channel";          //发布渠道
static BOOL JiGuangisProduction = NO;                       //是否生产


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *JiGuangchannel;

@end

