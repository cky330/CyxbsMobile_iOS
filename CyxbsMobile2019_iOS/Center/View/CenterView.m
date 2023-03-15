//
//  CenterView.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2023/3/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "CenterView.h"

@implementation CenterView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.detailsBtnsArray = [NSMutableArray array];
        [self addSubview:self.frontCoverImgView];
        [self addSubview:self.centerPromptBoxView];
        
        [self setPosition];
    }
    return self;
}

#pragma mark - Method

- (void)setPosition {
    // centerPromptBoxView
    [self.centerPromptBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(STATUSBARHEIGHT + 5);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.height.mas_equalTo(80);
    }];
}


#pragma mark - Getter

- (UIImageView *)frontCoverImgView {
    if (_frontCoverImgView == nil) {
        _frontCoverImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _frontCoverImgView;
}


- (CenterPromptBoxView *)centerPromptBoxView {
    if (_centerPromptBoxView == nil) {
        _centerPromptBoxView = [[CenterPromptBoxView alloc] init];
        
    }
    return _centerPromptBoxView;
}

- (UIButton *)detailsBtn {
    if (_detailsBtn == nil) {
        _detailsBtn = [[UIButton alloc] init];
        _detailsBtn.backgroundColor = UIColor.clearColor;
    }
    return _detailsBtn;
}
@end
