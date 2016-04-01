//
//  HomeVCTestViewController.h
//  RenRenATM
//
//
//
//

#import <UIKit/UIKit.h>
#import "MenuHrizontal.h"
//#import "ScrollPageView.h"
@interface HomeVCTestViewController : UIViewController<MenuHrizontalDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MenuHrizontal *mMenuHriZontal;
//    ScrollPageView *mScrollPageView;
      NSDictionary *xiangqingArray;
}
@property(nonatomic,strong) MenuHrizontal *mMenuHriZontal;
//@property(nonatomic,strong) ScrollPageView *mScrollPageView;
@property(nonatomic,strong) NSDictionary *xiangqingArray;
@end
