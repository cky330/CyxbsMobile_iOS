//
//  MainPageNumBtn.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "MainPageNumBtn.h"
#import "RedTipBall.h"
@interface MainPageNumBtn()
@property(nonatomic, strong)RedTipBall *redBall;
@end
@implementation MainPageNumBtn
- (instancetype)init
{
    self = [super init];
    if (self) {
        if (IS_IPHONESE) {
            self.titleLabel.font = [UIFont fontWithName:@"Impact" size:25];
        } else {
            self.titleLabel.font = [UIFont fontWithName:@"Impact" size:35];
        }
        
        if (@available(iOS 11.0, *)) {
            [self setTitleColor:[UIColor colorNamed:@"Mine_Main_QANumberLabelColor"] forState:UIControlStateNormal];
        } else {
            [self setTitleColor:[UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1] forState:UIControlStateNormal];
        }
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@(MAIN_SCREEN_W * 0.12));
        }];
        [self addBtnNameLabel];
        [self addBall];
    }
    return self;
}

- (void)addBtnNameLabel {
    UILabel *label = [[UILabel alloc] init];
    [self addSubview:label];
    self.btnNameLabel = label;
    
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"Mine_Main_QALableColor"];
    } else {
        label.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1];
    }
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.mas_bottom);
    }];
}

- (void)addBall {
    RedTipBall *redBall = [[RedTipBall alloc] init];
    self.redBall = redBall;
    [self addSubview:redBall];
    
    [redBall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(-5);
        make.centerY.equalTo(self.titleLabel.mas_top).offset(8);
    }];
}

- (void)setMsgCount:(NSString *)msgCount {
    _msgCount = msgCount;
    self.redBall.msgCount = msgCount;
}
@end