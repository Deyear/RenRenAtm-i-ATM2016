//
//  rightBtnDetialTabView.h
//  RenRenATM
//
//  Created by 牛牛 on 16/3/3.
//  Copyright © 2016年 com.fsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rightBtnDetialTabView : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSString *type;
    NSString *titleName;
}
@property(nonatomic,strong) NSString *type;
@property(nonatomic,strong) NSString *titleName;
@property(assign,nonatomic)NSInteger page;
@end
