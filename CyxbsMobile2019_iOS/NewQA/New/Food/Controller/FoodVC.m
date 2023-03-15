//
//  FoodVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/2/15.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "FoodVC.h"
#import "BTCollectionViewCell.h"
#import "FootViewController.h"
#import "FoodHomeModel.h"

@interface FoodVC ()<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
// 数组1
@property (nonatomic, strong) NSMutableArray *Ary1;

@property (nonatomic, strong) UIView *topView;
/// Home数据模型
@property (nonatomic, strong) FoodHomeModel *homeModel;

@end

@implementation FoodVC{
    NSArray <NSArray *> *_homeAry;
}

#pragma mark - ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    //获取主页数据,成功加载主页 失败加载失败页
    [self loadHomeData];
    
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self._getAry.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self._getAry[section].count;
}

//具体数据
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DemoCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    
    [cell.lab setText:[NSString stringWithFormat:@"%@", self._getAry[indexPath.section][indexPath.item]]];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    // 区头
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        view.backgroundColor = UIColor.redColor;
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        lab.text = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
        lab.backgroundColor = UIColor.systemBlueColor;
        [view addSubview:lab];
        return view;
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选择了%ld - %ld: %@", indexPath.section, indexPath.item, self._getAry[indexPath.section][indexPath.item]);
    
    //点击向数组添加
    if (indexPath.section == 0){
        [self.Ary1 addObject:self._getAry[indexPath.section][indexPath.item]];
    }
    
    //部分单选
    if (indexPath.section != 1)
        return;
    
    NSArray<NSIndexPath*>* selectedIndexes = collectionView.indexPathsForSelectedItems;
    for (int i = 0; i < selectedIndexes.count; i++) {
        NSIndexPath* currentIndex = selectedIndexes[i];
        if (![currentIndex isEqual:indexPath] && currentIndex.section == 1) {
            [collectionView deselectItemAtIndexPath:currentIndex animated:YES];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"取消了%ld - %ld: %@", indexPath.section, indexPath.item, self._getAry[indexPath.section][indexPath.item]);
    
    //再次点击移除
    if (indexPath.section == 0){
        [self.Ary1 removeObject:self._getAry[indexPath.section][indexPath.item]];
    }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeMake(74, 29);//每个cell的宽高
    return size;
}

// 设置区头尺寸高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(SCREEN_WIDTH, 60);
    return size;
}

#pragma mark - Method

- (void)loadHomeData {
    [self.homeModel requestSuccess:^{
        //加载主页数据
        [self addHomePage];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"美食主页数据获取失败");
    }];
}

- (void)addHomePage {
    //添加头视图
    [self addTopView];
    [self.view addSubview:self.collectionView];
    //添加脚视图
    [self addFootView];
}

- (void)addTopView {
    //头视图
    self.collectionView.contentInset = UIEdgeInsetsMake(self.topView.frame.size.height, 0, 0, 0);
    
    CGRect originFrame = self.topView.frame;
    originFrame.origin.y = - self.topView.frame.size.height;
    self.topView.frame = originFrame;
    self.collectionView.alwaysBounceVertical=true;
    [self.collectionView addSubview:self.topView];
}

- (void)addFootView {
    FootViewController *vc = [[FootViewController alloc] init];
    vc.view.frame = CGRectMake(0, 700, SCREEN_WIDTH, 103);
    [self addChildViewController:vc];
    [self.view addSubview:vc.view];
}


- (void)chooseMark:(UIButton *)sender {
    BTCollectionViewCell *cell = [[BTCollectionViewCell alloc] init];
    for (NSIndexPath *a in self.collectionView.indexPathsForSelectedItems) {
        cell = (BTCollectionViewCell *) [self.collectionView cellForItemAtIndexPath:a];
        NSLog(@"选择了%@",cell.lab.text);
    }
}


#pragma mark - Getter
- (NSMutableArray *)Ary1 {
    if (!_Ary1) {
        _Ary1 = [[NSMutableArray alloc] init];
    }
    return _Ary1;
}



#pragma mark - Lazy
- (NSArray <NSArray *> *)_getAry {
    if (_homeAry == nil) {
        _homeAry = @[
            self.homeModel.eat_areaAry,
            self.homeModel.eat_numAry,
            self.homeModel.eat_propertyAry
        ];
    }
    return _homeAry;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //最小列间距
        layout.minimumLineSpacing = 10;
        //最小行间距
        layout.minimumInteritemSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 25, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        
        _collectionView.allowsMultipleSelection = YES;
        
        [_collectionView registerClass:BTCollectionViewCell.class forCellWithReuseIdentifier:DemoCollectionViewCellReuseIdentifier];
        // 注册区头
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }
    return _collectionView;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.245)];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:_topView.frame];
        [imgView sd_setImageWithURL:[NSURL URLWithString:self.homeModel.pictureURL]];
        [_topView addSubview:imgView];
    }
    return _topView;
}

- (FoodHomeModel *)homeModel{
    if(!_homeModel) {
        _homeModel = [[FoodHomeModel alloc] init];
    }
    return _homeModel;
}

@end
