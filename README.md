# SCSideBarController
仿网易新闻的sideBarController

##基本用法
*创建一个新的控制器并继承于MSSideBarController  
*创建其他子控制器并添加为MSSideBarController的子控制器

    UIViewController *vc = [[UIViewController alloc] init];
    [self addChildViewController:vc];

*如果需要设置标题和文字,则需要设置子控制器的tabBarItem属性

    vc1.tabBarItem.title = @"发现";
    vc1.tabBarItem.image = [UIImage imageNamed:@"xxx"];

*如果有包装导航栏控制器或者tabBar控制器,默认优先取父控制器的值, 如果父控制器没有赋值, 则判断子控制器数组中的第一个控制器是否有赋值, 依次循环 (图片也一样)
  
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc1];
    navController.tabBarItem.title = @"设置2";

![icon](http://img02.taobaocdn.com/imgextra/i2/135480037/TB2SRNVbVXXXXbiXXXXXXXXXXXX_!!135480037.png)
