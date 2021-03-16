//
//  PraiseTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PraiseTableViewCell.h"

@interface PraiseTableViewCell()
@property(nonatomic,strong)UILabel *remarkLabel;
@end

@implementation PraiseTableViewCell
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self addRemarkLabel];
    }
    return self;
}

- (void)addRemarkLabel {
    UILabel *label = [[UILabel alloc] init];
    self.remarkLabel = label;
    [self.contentView addSubview:label];
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    label.font = [UIFont fontWithName:PingFangSCMedium size:15];
//    label.numberOfLines = 2;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0.1867*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.1987*SCREEN_WIDTH);
        make.right.equalTo(self.contentView).offset(-0.05*SCREEN_WIDTH);
    }];
    
}

- (void)setModel:(PraiseParseModel *)model {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ssZ";
    
    NSString *timeStr = [model.time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    NSDate *date = [formatter dateFromString:timeStr];
    if ([date isToday]) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:date];
        self.timeLabel.text = [NSString stringWithFormat:@"%ld.%ld.%ld %ld:%ld",components.year,components.month,components.day,components.hour,components.minute];
    }else {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
        self.timeLabel.text = [NSString stringWithFormat:@"%ld.%ld.%ld",components.year,components.month,components.day];
    }
    
    self.nickNameLabel.text = model.nick_name;
    if ([model.type isEqualToString:@"1"]) {
        self.interactionInfoLabel.text = @"赞了你的评论";
    }else {
        self.interactionInfoLabel.text = @"赞了你的动态";
    }
    if (model.avatar!=nil&&![model.avatar isEqualToString:@""]) {
        [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    }
    self.remarkLabel.text = model.from;
//    self.detailTextLabel.text = @"赞了你的评论/回复/动态";
}


- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
@end



