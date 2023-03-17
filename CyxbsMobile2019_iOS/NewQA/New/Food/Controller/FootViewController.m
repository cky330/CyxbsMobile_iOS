//
//  FootViewController.m
//  food
//
//  Created by 潘申冰 on 2023/3/14.
//

#import "FootViewController.h"
#import "UDScrollAnimationView.h"

@interface FootViewController ()
@property (nonatomic, strong)UIButton *checkBtn;
@property (nonatomic, strong) UDScrollAnimationView *v;

@end

@implementation FootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.v];
    [self.view addSubview:self.checkBtn];
}

- (UDScrollAnimationView *)v {
    if(!_v) {
        _v = [[UDScrollAnimationView alloc] initWithFrame:CGRectMake(0, 0, 238, 51) TextArry:[[NSArray alloc] initWithObjects:@"ni",@"hao",@"1",@"2",@"3", nil] FinalText:@"ni"];
        _v.layer.cornerRadius = 8;
        _v.layer.masksToBounds = YES;
        _v.font = [UIFont fontWithName:PingFangSCMedium size:16];
        _v.textColor = [UIColor colorWithRed:0.184 green: 0.314 blue: 0.522 alpha: 1];
        _v.labColor = [UIColor colorWithRed: 0.937 green: 0.957 blue: 1 alpha: 1];
    }
    return _v;
}


- (void)buttonClick {
    int i = arc4random_uniform((int)self.v.textArr.count);
    NSString *str = [NSString stringWithFormat:@"%@", self.v.textArr[i]];
    _v.finalText = str;
    [self.v startAnimation];
}

- (UIButton *)checkBtn{
    if (_checkBtn == nil) {
        _checkBtn = [[UIButton alloc]init];
        _checkBtn.frame =CGRectMake(200, 0, 91, 34);
        //给控件加圆角
        _checkBtn.layer.cornerRadius = 15;
        [_checkBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [_checkBtn setTitle:@"随机生成" forState:UIControlStateNormal];
        _checkBtn.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:14];
        _checkBtn.backgroundColor = [UIColor colorWithRed: 0.365 green: 0.365 blue: 0.969 alpha: 1];
    }
    return _checkBtn;
}

@end
