//
//  ViewController.m
//  SCSideBarController
//
//  Created by 2014-763 on 15/2/9.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

// 创建随机颜色
#define kRandomColor [UIColor colorWithRed: arc4random_uniform(255) / 255.0f green:arc4random_uniform(255) / 255.0f blue:arc4random_uniform(255) / 255.0f alpha:1.0]

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    UIViewController *vc2 = [[UIViewController alloc] init];
    UIViewController *vc3 = [[UIViewController alloc] init];
    UIViewController *vc4 = [[UIViewController alloc] init];
    
    vc1.view.backgroundColor = kRandomColor;
    vc2.view.backgroundColor = kRandomColor;
    vc3.view.backgroundColor = kRandomColor;
    vc4.view.backgroundColor = kRandomColor;

    vc1.tabBarItem.title = @"发现";
    vc2.tabBarItem.title = @"设置";
    vc3.tabBarItem.title = @"其他";
    vc4.tabBarItem.title = @"首页";
    
    vc1.tabBarItem.image = [UIImage imageNamed:@"night_icon_setting"];
    vc2.tabBarItem.image = [UIImage imageNamed:@"night_icon_setting"];
    vc3.tabBarItem.image = [UIImage imageNamed:@"night_icon_setting"];
    vc4.tabBarItem.image = [UIImage imageNamed:@"night_icon_setting"];
    
    vc1.tabBarItem.selectedImage = [UIImage imageNamed:@"night_icon_highlighted"];
    vc2.tabBarItem.selectedImage = [UIImage imageNamed:@"night_icon_highlighted"];
    vc3.tabBarItem.selectedImage = [UIImage imageNamed:@"night_icon_highlighted"];
    vc4.tabBarItem.selectedImage = [UIImage imageNamed:@"night_icon_highlighted"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc1];
    [self addChildViewController:navController];
    
    UITabBarController *tabController = [[UITabBarController alloc] init];
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    [tabController addChildViewController:navController2];
    [tabController addChildViewController:vc3];
    [tabController addChildViewController:[[UINavigationController alloc] init]];
    tabController.tabBarItem.title = @"设置2"; // 如果没有给父控制器设值, 则判断子控制器数组中的第一个控制器是否有值, 然后往下循环 (图片也一样)
    [self addChildViewController:tabController];
    
    [self addChildViewController:vc4];
}


@end
