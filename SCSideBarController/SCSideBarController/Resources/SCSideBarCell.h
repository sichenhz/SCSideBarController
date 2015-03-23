//
//  MSSideBarCell.h
//  MeiliShop
//
//  Created by 2014-763 on 15/2/9.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCSideBarCell : UITableViewCell
/**
 *  侧拉菜单的icon
 */
@property (nonatomic, weak) UIImageView *iconView;
/**
 *  侧拉菜单的title
 */
@property (nonatomic, weak) UILabel *titleLabel;
/**
 *  icon和title位置的偏移量
 */
@property (nonatomic, assign) CGFloat offsetX;
/**
 *  icon的宽
 */
@property (nonatomic, assign) CGFloat iconW;
@end
