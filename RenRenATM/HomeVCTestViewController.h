//
//  HomeVCTestViewController.h
//  RenRenATM
//
//
//
//

#import <UIKit/UIKit.h>
#import "MenuHrizontal.h"
@interface HomeVCTestViewController : UIViewController<MenuHrizontalDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MenuHrizontal *mMenuHriZontal;
    NSDictionary *xiangqingArray;
}
@property(nonatomic,strong) MenuHrizontal *mMenuHriZontal;
@property(nonatomic,strong) NSDictionary *xiangqingArray;
@end
