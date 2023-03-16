//
//  CenterView.h
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2023/3/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

// 此类为游乐园界面View
#import <UIKit/UIKit.h>
#import "CenterPromptBoxView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CenterView : UIView

/// 游乐场的封面
@property (nonatomic, strong) UIImageView *frontCoverImgView;

/// 顶部提示框
@property (nonatomic, strong) CenterPromptBoxView *centerPromptBoxView;



@end

NS_ASSUME_NONNULL_END
