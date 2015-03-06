
/**
 *  UIView基础分类
 */

#import <UIKit/UIKit.h>

@interface UIView (Extension)

/**
 *  便利设置变量的方法
 *  如:self.frame.origin.x = 2 可直接写 self.x = 2
 *
 *  便利读取变量的方法
 *  如:self.frame.origin.x 可直接写 self.x
 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;

/**
 *  快速加载xib，返回xib中的第一个视图
 *  @param  fileName  xib文件名
 **/
+ (instancetype)viewWithXib:(NSString *)fileName;

/**
 *  在当前视图居中展示一个提示框，然后消失
 *  @param  content  提示框需展示的文本
 **/
- (void)showSheetWithContent:(NSString *)content;
+ (void)showSheetFromView:(UIView *)view
                  content:(NSString *)content;

/**
 *  在当前视图居中展示一个提示框，然后消失
 *  @param  content  提示框需展示的文本
 *  @param  coorY  Y轴上的坐标值 0~1 (0在顶部,1在底部)
 **/
- (void)showSheetWithContent:(NSString *)content
                       coorY:(CGFloat)coorY;
+ (void)showSheetFromView:(UIView *)view
                  content:(NSString *)content
                    coorY:(CGFloat)coorY;


/**
 *  在当前视图居中展示一个提示框，然后消失
 *  @param  content  提示框需展示的文本
 *  @param  fontSize  内容的字体大小
 *  @param  fontColor  内容的字体颜色
 *  @param  backgroundColor  内容的背景颜色
 **/
- (void)showSheetWithContent:(NSString *)content
                    fontSize:(NSInteger)fontSize
                   fontColor:(UIColor *)fontColor
             backgroundColor:(UIColor *)backgroundColor;
+ (void)showSheetFromView:(UIView *)view
                  content:(NSString *)content
                 fontSize:(NSInteger)fontSize
                fontColor:(UIColor *)fontColor
          backgroundColor:(UIColor *)backgroundColor;

/**
 *  在当前视图居中展示一个提示框，然后消失
 *  @param  content  提示框需展示的文本
 *  @param  fontSize  内容的字体大小
 *  @param  fontColor  内容的字体颜色
 *  @param  backgroundColor  内容的背景颜色
 *  @param  Y轴上的坐标值 0~2 (0在顶部,1在底部)
 **/
- (void)showSheetWithContent:(NSString *)content
                    fontSize:(NSInteger)fontSize
                   fontColor:(UIColor *)fontColor
             backgroundColor:(UIColor *)backgroundColor
                       coorY:(CGFloat)coorY;
+ (void)showSheetFromView:(UIView *)view
                  content:(NSString *)content
                 fontSize:(NSInteger)fontSize
                fontColor:(UIColor *)fontColor
          backgroundColor:(UIColor *)backgroundColor
                    coorY:(CGFloat)coorY;


/**
 *  初始化自定义tabBar
 */
+ (instancetype)tabBar;


/**
 *  在屏幕上添加一块阴影蒙版
 */
+ (void)showCover;

/**
 *  将屏幕上的阴影蒙版删除
 */
+ (void)dismissCover;

@end
