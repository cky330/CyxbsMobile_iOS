//
//  BTCollectionViewCell.m
//  food
//
//  Created by 潘申冰 on 2023/2/3.
//

#import "BTCollectionViewCell.h"
#define ZLUnselectedColor [UIColor colorWithRed:(241)/255.0 green:(242)/255.0 blue:(243)/255.0 alpha:1.0]
#define ZLSelectedColor [UIColor colorWithRed:(74)/255.0 green:(68)/255.0 blue:(228)/255.0 alpha:1.0]
NSString *DemoCollectionViewCellReuseIdentifier = @"DemoCollectionViewCell";

@implementation BTCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.lab];
    }
    return self;
}

//- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
//    self.lab.frame = CGRectMake(0, 0, layoutAttributes.size.width, layoutAttributes.size.height);
//}

- (UILabel *)lab{
    if(!_lab){
        _lab = [[UILabel alloc] initWithFrame:CGRectMake(0,0,74,29)];
        _lab.textAlignment = NSTextAlignmentCenter;//居中
        //默认底色
        _lab.backgroundColor = ZLUnselectedColor;
        
        //按钮的边框弧度
        _lab.layer.cornerRadius = 8;
        _lab.layer.masksToBounds = YES;
        //设置字体
        _lab.font = [UIFont boldSystemFontOfSize:14];
        _lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _lab.textColor = [UIColor colorWithRed:(21)/255.0 green:(49)/255.0 blue:(91)/255.0 alpha:0.4];
    }
    return _lab;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if(selected) {
        self.lab.textColor = ZLSelectedColor;
    }else{
        self.lab.textColor = [UIColor colorWithRed:(21)/255.0 green:(49)/255.0 blue:(91)/255.0 alpha:0.4];
    }
}

@end
