//
//  MSTabMenuController.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/5.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import "UIView+Extension.h"

@interface MSSideBarController : UIViewController <UITableViewDataSource, UITableViewDelegate>
/**
 *  当前选中的控制器下标
 */
@property(nonatomic) NSUInteger selectedIndex;
/**
 *  当前选中的控制器
 */
@property(nonatomic, weak) UIViewController *selectedViewController;
/**
 *  侧边菜单视图
 */
@property (nonatomic, weak) UIView *sideBar;
/**
 *  侧边菜单视图内的tableView
 */
@property (nonatomic, weak) UITableView *tableView;
/**
 *  毛玻璃视图
 */
@property (nonatomic, weak) FXBlurView *blurView;
@end