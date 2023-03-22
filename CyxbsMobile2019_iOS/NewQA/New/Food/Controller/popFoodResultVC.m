//
//  popFoodResultVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/3/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "popFoodResultVC.h"

@interface popFoodResultVC ()

///信息说明的contentView，他是一个button，用来保证点击空白处可以取消
@property (nonatomic, weak) UIButton * informationContentView;

@end

@implementation popFoodResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF" alpha:0];
    [self popInformation];
}

//#pragma mark -弹出信息
- (void)popInformation {
#pragma mark - 灰色背景板
    //添加灰色背景板
    UIButton * contentView = [[UIButton alloc] initWithFrame:self.view.frame];
    self.informationContentView = contentView;
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    contentView.alpha = 0;

    [UIView animateWithDuration:0.3 animations:^{
        contentView.alpha = 1;
        self.tabBarController.tabBar.userInteractionEnabled = NO;
    }];
    [contentView addTarget:self action:@selector(cancelLearnAbout) forControlEvents:UIControlEventTouchUpInside];

#pragma mark - 弹窗视图
    UIView *learnView = [[UIView alloc]init];
    //设置圆角
    learnView.layer.cornerRadius = 8;
    learnView.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"美食背景"].CGImage);

#pragma mark - 美食图片
    
    UIImageView *foodImgView = [[UIImageView alloc] init];
    [foodImgView sd_setImageWithURL:[NSURL URLWithString:self.ImgURL]];
    
#pragma mark - 美食标题
    
    self.foodNameText = @"千喜鹤";
    
    //标题
    UILabel *foodNameLab = [[UILabel alloc] init];
    foodNameLab.text = self.foodNameText;
    foodNameLab.font = [UIFont fontWithName:PingFangSCMedium size:18];
    foodNameLab.textColor = [UIColor colorWithHexString:@"#15315B" alpha:1];
    foodNameLab.frame = CGRectMake(0, 0, 0, 18);
    [foodNameLab sizeToFit];//计算高度
    
#pragma mark - 内容
    //内容
    UILabel *contentLab = [[UILabel alloc] init];
    contentLab.text = self.contentText;
    contentLab.font = [UIFont fontWithName:PingFangSCMedium size: 14];
    contentLab.numberOfLines = 0;
    contentLab.textAlignment = NSTextAlignmentCenter;
    contentLab.textColor = [UIColor colorWithHexString:@"#15315B" alpha:0.5];
    contentLab.frame = CGRectMake(0, 0, 225, 0);
    [contentLab sizeToFit];//计算高度
    
        
#pragma mark - 取消按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 93, 34)];
    //背景渐变色
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = cancelBtn.bounds;
    //起点和终点表示的坐标系位置，（0，0)表示左上角，（1，1）表示右下角
    gl.startPoint = CGPointMake(0, 1);
    gl.endPoint = CGPointMake(1, 0);
    gl.colors = @[
        (__bridge id)[UIColor colorWithHexString:@"#4841E2"].CGColor,
        (__bridge id)[UIColor colorWithHexString:@"#5D5DF7"].CGColor
    ];
    gl.locations = @[@(0),@(1.0f)];
    [cancelBtn.layer addSublayer: gl];
    
    [cancelBtn setTitle:@"点赞" forState:normal];
    cancelBtn.titleLabel.textColor = [UIColor colorWithHexString:@"#5C5CF6"];
    cancelBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 14];
    cancelBtn.layer.cornerRadius = 16;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(cancelLearnAbout) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:learnView];
    [learnView addSubview:foodImgView];
    [learnView addSubview:foodNameLab];
    [learnView addSubview:contentLab];
    [learnView addSubview:cancelBtn];
    
#pragma mark - 布局
    [learnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(60);
        make.right.equalTo(self.view).offset(-60);
        make.height.equalTo(@(271 + contentLab.size.height));
    }];
    
    [foodImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(learnView);
        make.top.equalTo(learnView).offset(35);
        make.height.equalTo(@125);
        make.width.equalTo(@193);
    }];
    
    [foodNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(learnView);
        make.top.equalTo(foodImgView.mas_bottom).offset(20);
    }];
    
    [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(learnView).offset(15);
        make.top.equalTo(foodNameLab.mas_bottom).offset(10);
        make.right.equalTo(learnView).offset(-15);
    }];
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(learnView);
        make.top.equalTo(contentLab.mas_bottom);
        make.width.equalTo(@93);
        make.height.equalTo(@34);
    }];
    
}

#pragma mark - Lazy
- (void)cancelLearnAbout {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setFoodNameText:(NSString *)foodNameText {
    _foodNameText = foodNameText;
}

- (void)setContentText:(NSString *)contentText {
    _contentText = contentText;
}

- (void)setImgURL:(NSString *)ImgURL {
    _ImgURL = ImgURL;
}

- (void)setPraiseNum:(NSString *)praiseNum {
    _praiseNum = praiseNum;
}
@end
