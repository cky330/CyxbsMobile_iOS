//
//  DiscoverADController.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverADController.h"

#import "DiscoverADBannerView.h"

#import "DiscoverADModel.h"

#pragma mark - DiscoverADController ()

@interface DiscoverADController () <
    DiscoverADBannerViewDelegate,
    DiscoverADModelDelegate
>

/// 广告视图
@property (nonatomic, strong) DiscoverADBannerView *ADBannerView;

/// 广告Model
@property (nonatomic, strong) DiscoverADModel <UICollectionViewDataSource> *ADModel;

/// timer
@property (nonatomic, weak) NSTimer *timer;

@end

#pragma mark - DiscoverADController

@implementation DiscoverADController

#pragma mark - Init

- (instancetype)initWithViewFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    [self.view addSubview:self.ADBannerView];
    
    // 网络请求
    [self.ADModel
     requestBannerSuccess:^{
        [self.ADBannerView reloadData];
    }
     failure:^(NSError * _Nonnull error) {
        NSLog(@"error");
    }];
}

#pragma mark - Lazy

- (DiscoverADModel *)ADModel {
    if (_ADModel == nil) {
        _ADModel = [[DiscoverADModel alloc] init];
        
        _ADModel.delegate = self;
    }
    return _ADModel;
}

- (DiscoverADBannerView *)ADBannerView {
    if (_ADBannerView == nil) {
        _ADBannerView = [[DiscoverADBannerView alloc] initWithFrame:self.view.SuperFrame];
        
        _ADBannerView.bannerDelegate = self;
        _ADBannerView.dataSource = self.ADModel;
    }
    return _ADBannerView;
}

#pragma mark - <DiscoverADBannerViewDelegate>

- (void)discoverADBannerView:(DiscoverADBannerView *)bannerView didSelectedAtItem:(NSUInteger)item {
    // -----待实现确认-----
}

#pragma mark - <DiscoverADModelDelegate>

- (__kindof UICollectionViewCell *)discoverAD:(DiscoverAD *)AD cellForCollectionView:(UICollectionView *)collectionView {
    return AD == nil ?
        self.ADBannerView.getReusableDiscoverADItem.withDefaultStyle :
        [self.ADBannerView.getReusableDiscoverADItem
            setImgURL:AD.pictureUrl];
}

@end
