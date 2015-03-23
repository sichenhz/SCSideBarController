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
    [self addOneChildVc:[[UIViewController alloc] init] title:@"我的" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    [self addOneChildVc:[[UIViewController alloc] init] title:@"搜索" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    [self addOneChildVc:[[UIViewController alloc] init] title:@"设置" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
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

////     也可通过代理方法自定义菜单栏
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 6;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
//    }
//    cell.imageView.image = [UIImage imageNamed:@"tabbar_home"];
//    cell.textLabel.text = @"首页";
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self switchViewController:(int)indexPath.row];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60;
//}

@end
