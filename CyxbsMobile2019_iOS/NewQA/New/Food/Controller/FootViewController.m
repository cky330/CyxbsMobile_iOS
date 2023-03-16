//
//  FootViewController.m
//  food
//
//  Created by 潘申冰 on 2023/3/14.
//

#import "FootViewController.h"
#import "UDScrollAnimationView.h"

@interface FootViewController ()
@property (nonatomic, strong)UIButton *loginButton;
@property (nonatomic, strong) UDScrollAnimationView *v;

@end

@implementation FootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.v];
    [self.view addSubview:self.loginButton];
}

- (UDScrollAnimationView *)v{
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


- (void)buttonClick{
    int i = arc4random_uniform((int)self.v.textArr.count);
    NSString *str = [NSString stringWithFormat:@"%@", self.v.textArr[i]];
    _v.finalText = str;
    [self.v startAnimation];
}

- (UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc]init];
        _loginButton.frame =CGRectMake(200, 0, 91, 34);
        //给控件加圆角
        _loginButton.layer.cornerRadius = 15;
        [_loginButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [_loginButton setTitle:@"随机生成" forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont fontWithName:PingFangSCMedium size:14];
//        [_loginButton setTitle:@"生成中..." forState:UIControlStateHighlighted];
        _loginButton.backgroundColor = [UIColor colorWithRed: 0.365 green: 0.365 blue: 0.969 alpha: 1];
    }
    return _loginButton;
}

@end
