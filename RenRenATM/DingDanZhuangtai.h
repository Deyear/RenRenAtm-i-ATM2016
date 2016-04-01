//
//  DingDanZhuangtai.h
//  RenRenATM
//
//  Created by 牛牛 on 16/3/25.
//  Copyright © 2016年 com.fsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DingDanZhuangtai : UIViewController
{
    NSDictionary *xiangQingArray;
    UIView *_pingFen;
}
 
@property(nonatomic,strong) UIView *_pingFen;

@property(nonatomic,strong) NSDictionary *xiangQingArray;
@end
