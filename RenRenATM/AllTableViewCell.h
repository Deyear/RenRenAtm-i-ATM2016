//
//  AllTableViewCell.h
//  RenRenATM
//
//  Created by 方少言 on 16/1/14.
//  Copyright © 2016年 com.fsy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellClickedDelegate <NSObject>

- (void)onBtnClicked;

@end

@interface AllTableViewCell : UITableViewCell <CellClickedDelegate>

@property (nonatomic, weak) id delegate;

@end
