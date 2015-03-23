### 如何使用-SCSideBarController

![icon](http://img01.taobaocdn.com/imgextra/i1/135480037/TB2dK5KcXXXXXXTXpXXXXXXXXXX_!!135480037.gif)

1.创建类, 导入基类并继承于SCSideBarController

    #import "SCSideBarController.h"
    @interface ViewController : SCSideBarController
    @end

2.实例化一些控制器, 并添加为当前类的子控制器

    UIViewController *vc = [[UIViewController alloc] init];
    [self addChildViewController:vc];
    
3.如果需要设置标题和icon,则需要设置子控制器的tabBarItem属性

    vc.tabBarItem.title = @"首页";
    vc.tabBarItem.image = [UIImage imageNamed:@"xxx"];

4.如果需要设置文字的属性,可调用tabBarItem的setTitleTextAttributes方法
(目前支持设置字体大小和selected状态下和normal状态下的字体颜色)

    [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor orangeColor]} forState:UIControlStateSelected];
    
5.也可通过tablew代理方法自定义cell来自定义菜单栏, 但在选中cell时候需要调用swichViewController:来切换控制器

    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self switchViewController:(int)indexPath.row];
    }

