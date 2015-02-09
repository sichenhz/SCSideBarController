//
//  MSTabMenuController.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/5.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FXBlurView;

@interface MSSideBarController : UIViewController

/**
 *  当前选中的控制器下标
 */
@property(nonatomic) NSUInteger selectedIndex;
/**
 *  当前选中的控制器
 */
@property(nonatomic,weak) UIViewController *selectedViewController;
/**
 *  所有的子控制器
 */
@property(nonatomic,copy) NSArray *viewControllers;

@end