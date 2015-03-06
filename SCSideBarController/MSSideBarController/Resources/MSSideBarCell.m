//
//  MSSideBarCell.m
//  MeiliShop
//
//  Created by 2014-763 on 15/2/9.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "MSSideBarCell.h"

#define iconW 45
#define marginMiddle 25

@implementation MSSideBarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];

}

- (UIImageView *)iconView {
    if (!_iconView) {
        CGFloat cellW = self.frame.size.width;
        CGFloat cellH = self.frame.size.height;
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(cellW/2 - iconW - marginMiddle, 0, iconW, cellH)];
        iconView.contentMode = UIViewContentModeCenter;
        [self addSubview:iconView];
        _iconView = iconView;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGFloat cellW = self.frame.size.width;
        CGFloat cellH = self.frame.size.height;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconView.frame), 0, cellW - (CGRectGetMaxX(self.iconView.frame)), cellH)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.highlightedTextColor = [UIColor whiteColor];
        [self addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
@end
