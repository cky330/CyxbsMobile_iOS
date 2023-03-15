//
//  CenterPromptBoxView.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2023/3/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "CenterPromptBoxView.h"

@implementation CenterPromptBoxView

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
//        self.backgroundColor = [UIColor colorWithHexString:<#(nonnull NSString *)#>];
        [self addSubview:self.nameLab];
        [self addSubview:self.daysLab];
        [self addSubview:self.avatarImgView];
        [self setPosition];
    }
    return self;
}

#pragma mark - Method

- (void)setPosition {
    // avatarImgView
    [self.avatarImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    // nameLab
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.centerY).offset(-10);
        make.left.equalTo(self).offset(30);
        make.right.equalTo(self.avatarImgView.mas_left);
        make.height.mas_equalTo(30);
    }];
    // daysLab
    [self.daysLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.centerY).offset(10);
        make.left.right.height.equalTo(self.nameLab);
    }];
}



#pragma mark - Getter

- (UILabel *)nameLab {
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.text = @"Hi, 宋开开";
        _nameLab.font = [UIFont systemFontOfSize:20];
        _nameLab.textColor = UIColor.blackColor;
//        _nameLab.font = [UIFont fontWithName:<#(nonnull NSString *)#> size:<#(CGFloat)#>];
//        _nameLab.textColor = [UIColor colorWithHexString:<#(nonnull NSString *)#>];
        
    }
    return _nameLab;
}

- (UILabel *)daysLab {
    if (_daysLab == nil) {
        _daysLab = [[UILabel alloc] init];
        _daysLab.textAlignment = NSTextAlignmentLeft;
        _daysLab.text = @"这是你来到属于你的邮乐园的第10天";
        _daysLab.font = [UIFont systemFontOfSize:20];
        _daysLab.textColor = UIColor.blackColor;
//        _daysLab.font = [UIFont fontWithName:<#(nonnull NSString *)#> size:<#(CGFloat)#>];
//        _daysLab.textColor = [UIColor colorWithHexString:<#(nonnull NSString *)#>];
    }
    return _daysLab;
}

- (UIImageView *)avatarImgView {
    if (_avatarImgView == nil) {
        _avatarImgView = [[UIImageView alloc] init];
        _avatarImgView.image = [UIImage imageNamed:@"复制链接"];
        _avatarImgView.layer.cornerRadius = 15;
    }
    return _avatarImgView;
}



@end
