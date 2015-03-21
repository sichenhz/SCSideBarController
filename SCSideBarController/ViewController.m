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
    [self addOneChildVc:[[UIViewController alloc] init] title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    [self addOneChildVc:[[UIViewController alloc] init] title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    [self addOneChildVc:[[UIViewController alloc] init] title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discover_selected"];
    [self addOneChildVc:[[UIViewController alloc] init] title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
}

- (void)addOneChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    [vc.tabBarItem setTitleTextAttributes:@{
                                            NSForegroundColorAttributeName : [UIColor orangeColor]
                                            } forState:UIControlStateSelected];
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    vc.view.backgroundColor = kRandomColor;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}


@end
