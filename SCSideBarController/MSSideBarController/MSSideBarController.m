//
//  MSTabMenuController.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/5.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSSideBarController.h"
#import "FXBlurView.h"
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
#define kFontSizeHigh 20.0
#define kFontSizeNormal 18.0

@interface MSSideBarController ()<UITableViewDataSource, UITableViewDelegate>
/**
 *  侧边菜单视图
 */
@property (nonatomic, weak) UIView *sideBar;
/**
 *  毛玻璃视图
 */
@property (nonatomic, weak) FXBlurView *blurView;
@end

@implementation MSSideBarController

static NSString *sideBarCellID = @"sideBarCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // 每次切换控制器后 重新添加手势
    [self addGesture];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 如果没有添加子控制器, 则自动创建一个
    if (!self.childViewControllers.count) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor grayColor];
        [self addChildViewController:[[UINavigationController alloc] initWithRootViewController:vc]];
    }
    // 切换至第一个子控制器
    [self chooseController:self.selectedIndex];
}

- (void)chooseController:(NSUInteger)selectedIndex
{
    self.viewControllers = self.childViewControllers;
    self.selectedIndex = selectedIndex;
    // 移除旧控制器的view
    [self.selectedViewController.view removeFromSuperview];
    // 添加新控制器的view
    UIViewController *vc = self.viewControllers[selectedIndex];
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


#pragma mark - 触发事件
- (void)addGesture {
    // 给子控制器视图添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMenu:)];
    [self.selectedViewController.view addGestureRecognizer:pan];
}

- (void)panMenu:(UIPanGestureRecognizer *)pan {
    
    CGPoint p = [pan translationInView:self.sideBar];
    CGPoint v = [pan velocityInView:self.sideBar];
    
    if (self.sideBar.frame.origin.x + p.x > 0) {
        self.sideBar.frame = CGRectMake(0, kY, kW, kH);
    } else if (CGRectGetMaxX(self.sideBar.frame) + p.x < 0) {
        self.sideBar.frame = CGRectMake(kX, kY, kW, kH);
    } else {
        self.sideBar.frame = CGRectMake(self.sideBar.frame.origin.x + p.x, kY, kW, kH);
    }
    [pan setTranslation:CGPointMake(0, 0) inView:self.view];
    
    CGFloat percent = CGRectGetMaxX(self.sideBar.frame)/(kScreenWidth*2/3);
    self.blurView.alpha = percent;
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (v.x > kVelocity) { // 向右快速滑动
            [self animateWithPop];
        } else if (v.x < -kVelocity) { // 向左快速滑动
            [self animateWithDismiss];
        } else { // 正常拖拽结束
            if (self.sideBar.frame.origin.x >= -kW/2) {
                [self animateWithPop];
            } else {
                [self animateWithDismiss];
            }
        }
    }
    // 拖拽结束
    if (pan.state == UIGestureRecognizerStateBegan) {
    }
}

- (void)animateWithPop {
    if (!_sideBar) { // 防止sideBar没有创建导致内部控件出现异常动画
        [self sideBar];
    }
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.sideBar.frame = CGRectMake(0, kY, kW, kH);
        self.blurView.alpha = 1.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)animateWithDismiss {
    [UIView animateWithDuration:kTimeInterval animations:^{
        self.sideBar.frame = CGRectMake(kX, kY, kW, kH);
        self.blurView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.sideBar removeFromSuperview];
    }];
}

- (void)switchViewController:(int)index {
    [self chooseController:index];
    // 给showingVc重新添加手势
    [self addGesture];
    // 隐藏毛玻璃
    [self.blurView removeFromSuperview];
    [self animateWithDismiss];
}


- (void)tapBlurView:(UITapGestureRecognizer *)tap {
    [self animateWithDismiss];
}

#pragma mark - 惰性实例化
- (UIView *)sideBar {
    if (!_sideBar) {
        UIView *sideBar = [[UIView alloc] initWithFrame:CGRectMake(kX, kY, kW, kH)];
        sideBar.backgroundColor = [UIColor blackColor];
        sideBar.alpha = kAlpha;
        [self.view addSubview:sideBar];
        
        // 设置tableView
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kW, kH-64)];
        [tableView registerClass:[MSSideBarCell class] forCellReuseIdentifier:sideBarCellID];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.bounces = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [sideBar addSubview:tableView];
        
        // 给菜单视图添加手势
        UIPanGestureRecognizer *panInMenu = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMenu:)];
        [sideBar addGestureRecognizer:panInMenu];
        
        // 给毛玻璃视图添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlurView:)];
        [self.blurView addGestureRecognizer:tap];
        
        _sideBar = sideBar;
    }
    return _sideBar;
}

- (FXBlurView *)blurView {
    if (!_blurView) {
        FXBlurView *blurView = [[FXBlurView alloc] initWithFrame:self.selectedViewController.view.frame];
        blurView.alpha = 0.0;
        blurView.dynamic = NO;
        blurView.blurRadius = 20.0;
        blurView.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        [self.selectedViewController.view addSubview:blurView];
        _blurView = blurView;
    }
    return _blurView;
}

- (NSUInteger)selectedIndex {
    if (!_selectedIndex) {
        _selectedIndex = 0;
    }
    return _selectedIndex;
}

- (NSArray *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSArray array];
    }
    return _viewControllers;
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
    
    UIViewController *vc = self.viewControllers[indexPath.row];
#warning 这里要修改
//    if ([vc isKindOfClass:[UINavigationController class]]) {
//        UIViewController *rootVc = vc.childViewControllers[0];
//        cell.titleLabel.text = rootVc.tabBarItem.title;
//        cell.iconView.image = rootVc.tabBarItem.image;
//        cell.iconView.image = rootVc.tabBarItem.selectedImage;
//    } else {
//        cell.titleLabel.text = vc.tabBarItem.title;
//        cell.iconView.image = vc.tabBarItem.image;
//        cell.iconView.image = vc.tabBarItem.selectedImage;
//    }
    cell.titleLabel.text = [self tabBarItemTitle:vc];
    cell.iconView.image = [self tabBarItemImage:vc];
    cell.iconView.highlightedImage = [self tabBarItemSelectedImage:vc];
    
    if (indexPath.row == self.selectedIndex) {
        cell.titleLabel.highlighted = YES;
        cell.iconView.highlighted = YES;
//        cell.titleLabel.font = [UIFont systemFontOfSize:kFontSizeHigh];
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

//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    MSSideBarCell *cell = (MSSideBarCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.titleLabel.font = [UIFont systemFontOfSize:kFontSizeHigh];
//}

//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row != self.selectedIndex) {
//        MSSideBarCell *cell = (MSSideBarCell *)[tableView cellForRowAtIndexPath:indexPath];
//        cell.titleLabel.font = [UIFont systemFontOfSize:kFontSizeNormal];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != self.selectedIndex) {
        MSSideBarCell *preCell = (MSSideBarCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
        preCell.titleLabel.highlighted = NO;
        preCell.iconView.highlighted = NO;
//        preCell.titleLabel.font = [UIFont systemFontOfSize:kFontSizeNormal];
    }
    
//    MSSideBarCell *cell = (MSSideBarCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.titleLabel.font = [UIFont systemFontOfSize:kFontSizeHigh];
    [self switchViewController:(int)indexPath.row];
}



@end
