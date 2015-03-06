//
//  MSTabMenuController.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/5.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSSideBarController.h"
#import "MSSideBarCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kRatio 3/4.0
#define kTimeInterval 0.2
#define kVelocity 500.0
#define kAlpha 0.85

#define kX -kScreenWidth * kRatio
#define kY 0
#define kW kScreenWidth * kRatio
#define kH kScreenHeight - kY

#define kRowHeight 65.0

@interface MSSideBarController ()
@property (nonatomic, strong) UITapGestureRecognizer *tapInBlurView;
@end

@implementation MSSideBarController

static NSString *sideBarCellID = @"sideBarCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)addChildViewController:(UIViewController *)childController {
    [super addChildViewController:childController];
    if (!self.selectedViewController) {
        [self chooseController:0]; // 默认选中第一个子控制器
    }
}


#pragma mark - 触发事件
- (void)chooseController:(NSUInteger)selectedIndex
{
    self.selectedIndex = selectedIndex;
    // 移除旧控制器的view
    [self.selectedViewController.view removeFromSuperview];
    // 添加新控制器的view
    UIViewController *vc = self.childViewControllers[selectedIndex];
    [self.view addSubview:vc.view];
    // 切换控制器时, 需要将菜单移至视图顶部
    if (_sideBar) {
        [self.view bringSubviewToFront:self.sideBar];
    }
    
    // 子控制器包装有导航栏控制器
    if ([vc isKindOfClass:[UINavigationController class]] && vc.childViewControllers.count) {
        [self setUpleftBarButtonItem:vc];
    }
    
    if ([vc isKindOfClass:[UITabBarController class]] && vc.childViewControllers.count) {
        for (UIViewController *childVc in vc.childViewControllers) {
            if ([childVc isKindOfClass:[UINavigationController class]] && childVc.childViewControllers.count) {
                [self setUpleftBarButtonItem:childVc];
            }
        }
    }
    self.selectedViewController = vc;
}

- (void)setUpleftBarButtonItem:(UIViewController *)vc {
    UIBarButtonItem *leftBarButtonItem = [vc.childViewControllers[0] navigationItem].leftBarButtonItem;
    // 设置导航栏的leftBarButtonItem
    if (leftBarButtonItem) { // 如果自定义了item
        leftBarButtonItem.target = self;
        leftBarButtonItem.action = @selector(animateWithPop);
    } else { // 使用默认的汉堡按钮
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"sideBarResource.bundle/top_navigation_menuicon"]] forState:UIControlStateNormal];        
        
        CGRect frame = button.frame;
        frame.size = button.currentBackgroundImage.size;
        button.frame = frame;
        
        [button addTarget:self action:@selector(animateWithPop) forControlEvents:UIControlEventTouchUpInside];
        
        [vc.childViewControllers[0] navigationItem].leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
}


- (void)panMenu:(UIPanGestureRecognizer *)pan {
    if (!_tableView) { // 手动调用tableView
        [self tableView];
    }
    
    CGPoint p = [pan translationInView:self.sideBar];
    CGPoint v = [pan velocityInView:self.sideBar];
    
    CGFloat y = self.sideBar.y;
    CGFloat w = self.sideBar.width;
    CGFloat h = self.sideBar.height;
    
    if (self.sideBar.frame.origin.x + p.x > 0) {
        self.sideBar.frame = CGRectMake(0, y, w, h);
    } else if (CGRectGetMaxX(self.sideBar.frame) + p.x < 0) {
        self.sideBar.frame = CGRectMake(-w, y, w, h);
    } else {
        self.sideBar.frame = CGRectMake(self.sideBar.frame.origin.x + p.x, y, w, h);
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    
    CGFloat percent = CGRectGetMaxX(self.sideBar.frame) / w;
    self.blurView.alpha = percent;
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (v.x > kVelocity) { // 向右快速滑动
            [self animateWithPop];
        } else if (v.x < -kVelocity) { // 向左快速滑动
            [self animateWithDismiss];
        } else { // 正常拖拽结束
            if (self.sideBar.frame.origin.x >= (-w) / 2) {
                [self animateWithPop];
            } else {
                [self animateWithDismiss];
            }
        }
    }
}

- (void)animateWithPop {
    if (!_tableView) { // 防止sideBar没有创建导致内部控件出现异常动画
        [self tableView];
    }
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.sideBar.frame = CGRectMake(0, self.sideBar.y, self.sideBar.width, self.sideBar.height);
        self.blurView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)animateWithDismiss {
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.sideBar.frame = CGRectMake(-self.sideBar.width, self.sideBar.y, self.sideBar.width, self.sideBar.height);
        self.blurView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.blurView removeFromSuperview];
    }];
}

- (void)switchViewController:(int)index {
    [self chooseController:index];
    // 移除毛玻璃
    [self.blurView removeFromSuperview];
    [self animateWithDismiss];
}


- (void)tapBlurView:(UITapGestureRecognizer *)tap {
    [self animateWithDismiss];
}



#pragma mark - 惰性实例化
- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    if (_selectedViewController != selectedViewController) {
        [selectedViewController.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMenu:)]];
        _selectedViewController = selectedViewController;
    }
}

- (UIView *)sideBar {
    if (!_sideBar) {
        UIView *sideBar = [[UIView alloc] initWithFrame:CGRectMake(kX, kY, kW, kH)];
        sideBar.backgroundColor = [UIColor blackColor];
        sideBar.alpha = kAlpha;
        [self.view addSubview:sideBar];
        
        // 给菜单视图添加手势
        UIPanGestureRecognizer *panInSideBar = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMenu:)];
        [sideBar addGestureRecognizer:panInSideBar];
        
        _sideBar = sideBar;
    }
    return _sideBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.sideBar.width, self.sideBar.height - 64)];
        [tableView registerClass:[MSSideBarCell class] forCellReuseIdentifier:sideBarCellID];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.bounces = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.sideBar addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (FXBlurView *)blurView {
    if (!_blurView) {
        FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:self.selectedViewController.view.frame];
        blurView.alpha = 0.0;
        blurView.dynamic = NO;
        blurView.blurRadius = 20.0;
        blurView.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        // 给毛玻璃视图添加手势
        [blurView addGestureRecognizer:self.tapInBlurView];
        
        [self.selectedViewController.view addSubview:blurView];
        _blurView = blurView;
    }
    return _blurView;
}

- (UITapGestureRecognizer *)tapInBlurView {
    if (!_tapInBlurView) {
        _tapInBlurView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlurView:)];
    }
    return _tapInBlurView;
}

#pragma mark - tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.childViewControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MSSideBarCell *cell = [tableView dequeueReusableCellWithIdentifier:sideBarCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[MSSideBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sideBarCellID];
    }
    
    UIViewController *vc = self.childViewControllers[indexPath.row];
    cell.titleLabel.text = [self tabBarItemTitle:vc];
    cell.iconView.image = [self tabBarItemImage:vc];
    cell.iconView.highlightedImage = [self tabBarItemSelectedImage:vc];
    
    if (indexPath.row == self.selectedIndex) {
        cell.titleLabel.highlighted = YES;
        cell.iconView.highlighted = YES;
    }
    
    return cell;
}

- (NSString *)tabBarItemTitle:(UIViewController *)vc {
    if (vc.tabBarItem.title) {
        return vc.tabBarItem.title;
    } else {
        if (vc.childViewControllers.count) {
            return [self tabBarItemTitle:vc.childViewControllers[0]];
        } else {
            return nil;
        }
    }
}

- (UIImage *)tabBarItemImage:(UIViewController *)vc {
    if (vc.tabBarItem.image) {
        return vc.tabBarItem.image;
    } else {
        if (vc.childViewControllers.count) {
            return [self tabBarItemImage:vc.childViewControllers[0]];
        } else {
            return nil;
        }
    }
}

- (UIImage *)tabBarItemSelectedImage:(UIViewController *)vc {
    if (vc.tabBarItem.selectedImage) {
        return vc.tabBarItem.selectedImage;
    } else {
        if (vc.childViewControllers.count) {
            return [self tabBarItemSelectedImage:vc.childViewControllers[0]];
        } else {
            return nil;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kRowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.selectedIndex) {
        MSSideBarCell *preCell = (MSSideBarCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
        preCell.titleLabel.highlighted = NO;
        preCell.iconView.highlighted = NO;
    }
    
    [self switchViewController:(int)indexPath.row];
}



@end
