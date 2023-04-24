//
//  CyxbsTabBarController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "CyxbsTabBarController.h"

#import "FastLoginViewController.h"
#import "UserAgreementViewController.h"
#import "ScheduleShareCache.h"

#import "SchedulePresenter.h"
#import "ScheduleController.h"
#import "TransitioningDelegate.h"

#import "ScheduleTabBar.h"
#import "ScheduleBottomBar.h"

@interface CyxbsTabBarController () <
    UITabBarControllerDelegate,
    FastLoginViewControllerDelegate
>
@property (nonatomic, strong) ScheduleTabBar *scheduleTabBar;
@property (nonatomic, strong) SchedulePresenter *schedulePresenter;

// 你可以在这里枚举所有的controller，并在代理中确定哪些需要显示。

@end

@implementation CyxbsTabBarController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    [self setValue:self.scheduleTabBar forKey:@"tabBar"];
    [self.scheduleTabBar reload];
    
    self.schedulePresenter = [[SchedulePresenter alloc] init];
    
    self.viewControllers = @[
        self._test1
    ];
    
}

#pragma mark - Method

- (void)presentControllerWhatIfNeeded {
    if (self.presentedViewController) { return; }
    BOOL hadReadAgreement = [NSUserDefaults.standardUserDefaults boolForKey:@"UDKey_hadReadAgreement"];
    if (!hadReadAgreement) {
        // 用户协议以及登录请在这里进行改变
        UIViewController *vc = [[UserAgreementViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:vc animated:YES completion:nil];
        self.selectedIndex = 1;
    } else {
        ScheduleIdentifier *main = [ScheduleShareCache memoryKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyMain];
        ScheduleIdentifier *other = [ScheduleShareCache memoryKeyForKey:nil forKeyName:ScheduleWidgetCacheKeyOther];
        if (!main) { return; }
        if (other.useWidget == YES) {
            [self.schedulePresenter setWithMainKey:main otherKey:other];
        } else {
            [self.schedulePresenter setWithMainKey:main];
        }
        [self presentScheduleControllerWithPan:nil completion:nil];
    }
}

- (void)reloadScheduleBar {
    [_scheduleTabBar reload];
}

- (void)presentScheduleControllerWithPan:(UIPanGestureRecognizer * _Nullable)pan completion:(void (^ __nullable)(UIViewController *vc))completion {
    if (self.presentedViewController) {
        if (completion) { completion(self.presentedViewController); }
        return;
    }
    UIViewController *vc = [[ScheduleController alloc] initWithPresenter:self.schedulePresenter];
    TransitioningDelegate *delegate = [[TransitioningDelegate alloc] init];
    delegate.transitionDurationIfNeeded = 0.3;
    delegate.panInsetsIfNeeded = UIEdgeInsetsMake(StatusBarHeight(), 0, self.tabBar.height, 0);
    delegate.supportedTapOutsideBackWhenPresent = NO;
    if (pan) {
        delegate.panGestureIfNeeded = pan;
    }
    
    vc.transitioningDelegate = delegate;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion) { completion(vc); }
        });
    }];
}

#pragma mark - Private

- (void)_tap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self presentScheduleControllerWithPan:nil completion:nil];
    }
}

- (void)_pan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self presentScheduleControllerWithPan:pan completion:nil];
    }
}

#pragma mark - Lazy

- (ScheduleTabBar *)scheduleTabBar {
    if (_scheduleTabBar == nil) {
        _scheduleTabBar = [[ScheduleTabBar alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tap:)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_pan:)];
        [_scheduleTabBar.bottomBar addGestureRecognizer:tap];
        [_scheduleTabBar.bottomBar addGestureRecognizer:pan];
    }
    return _scheduleTabBar;
}

#pragma mark - Setter

- (void)setScheduleBarHidden:(BOOL)scheduleBarHidden {
    self.scheduleTabBar.scheduleBarHidden = scheduleBarHidden;
}

#pragma mark - Getter

- (BOOL)isScheduleBarHidden {
    return self.scheduleTabBar.scheduleBarHidden;
}

#pragma mark - <UITabBarControllerDelegate>

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    self.scheduleTabBar.scheduleBarHidden = YES;
}














#pragma mark - Method

- (UIViewController *)_test1 {
    FastLoginViewController *vc = [[FastLoginViewController alloc] init];
    vc.presenter = self.schedulePresenter;
    vc.delegate = self;
    return [[UINavigationController alloc] initWithRootViewController:vc];
}

- (void)viewControllerTapBegin:(FastLoginViewController *)vc {
    [ScheduleShareCache memoryCacheKey:vc.mainID forKeyName:ScheduleWidgetCacheKeyMain];
    [ScheduleShareCache memoryCacheKey:vc.otherID forKeyName:ScheduleWidgetCacheKeyOther];
    
    [self reloadScheduleBar];
    [self presentScheduleControllerWithPan:nil completion:nil];
}

@end