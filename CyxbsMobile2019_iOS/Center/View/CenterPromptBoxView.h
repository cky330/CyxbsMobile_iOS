//
//  CenterPromptBoxView.h
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2023/3/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CenterPromptBoxView : UIView

/// 名字文本
@property (nonatomic, strong) UILabel *nameLab;

/// 天数文本
@property (nonatomic, strong) UILabel *daysLab;

/// 头像
@property (nonatomic, strong) UIImageView *avatarImgView;

@end

NS_ASSUME_NONNULL_END
