//
//  CustomAnnotationView.h
//  RenRenATM
//
//  Created by 方少言 on 16/2/23.
//  Copyright © 2016年 com.fsy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCalloutView.h"
#import <MAMapKit/MAMapKit.h>
@interface CustomAnnotationView : MAAnnotationView
@property (nonatomic, readonly) CustomCalloutView *calloutView;
@end
