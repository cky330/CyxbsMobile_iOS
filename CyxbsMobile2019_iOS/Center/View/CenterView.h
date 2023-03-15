//
//  CenterView.h
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2023/3/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

// 此类为游乐场界面View
#import <UIKit/UIKit.h>
#import "CenterPromptBoxView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CenterView : UIView

/// 游乐场的封面
@property (nonatomic, strong) UIImageView *fontCoverImgView;

/// 顶部提示框
@property (nonatomic, strong) CenterPromptBoxView *centerPromptBoxView;

/// 点击对应按钮跳转具体内容
@property (nonatomic, strong) UIButton *detailsBtn;

/// 上面的按钮存放在一个数组里
@property (nonatomic, copy) NSMutableArray *detailsBtnsArray;


@end

NS_ASSUME_NONNULL_END
