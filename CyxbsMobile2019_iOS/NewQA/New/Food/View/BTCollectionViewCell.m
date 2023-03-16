//
//  BTCollectionViewCell.m
//  food
//
//  Created by 潘申冰 on 2023/2/3.
//

#import "BTCollectionViewCell.h"
#define UnselectedColor [UIColor colorWithHexString:@"#15315B" alpha:0.4]
#define SelectedColor [UIColor colorWithHexString:@"#4A44E4" alpha:1]
NSString *DemoCollectionViewCellReuseIdentifier = @"DemoCollectionViewCell";

@implementation BTCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.lab];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
        [self.lab addSubview:img];
    }
    
    return self;
}

- (UILabel *)lab{
    if(!_lab){
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,74,29)];
        _lab.textAlignment = NSTextAlignmentCenter;//居中
        //默认底色
        _lab.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8" alpha:1];
        
        //按钮的边框弧度
        _lab.layer.cornerRadius = 8;
        _lab.layer.masksToBounds = YES;
        //设置字体
        _lab.font = [UIFont boldSystemFontOfSize:14];
        _lab.font = [UIFont fontWithName:PingFangSCMedium size:12];
        _lab.textColor = UnselectedColor;
    }
    return _lab;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected) {
        self.lab.textColor = SelectedColor;
    }else{
        self.lab.textColor = UnselectedColor;

    }
    
}

@end
