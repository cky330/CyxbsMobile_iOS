//
//  ScheduleCollectionViewLayout.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

/**ScheduleCollectionViewLayout视图布局
 * 设置所有陈列出来的属性，来达到最佳的视觉效果
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleCollectionViewLayoutInvalidationContext

@interface ScheduleCollectionViewLayoutInvalidationContext : UICollectionViewLayoutInvalidationContext

/// 是否立刻重新布局顶视图
@property (nonatomic) BOOL invalidateHeaderSupplementaryAttributes;

/// 是否立刻重新布局左视图
@property (nonatomic) BOOL invalidateLeadingSupplementaryAttributes;

/// 是否立刻重新布局课表视图
@property (nonatomic) BOOL invalidateAllAttributes;

@end

#pragma mark - ScheduleCollectionViewLayoutDelegate

@class ScheduleCollectionViewLayout;

/// <#Description#>
@protocol ScheduleCollectionViewLayoutDataSource <NSObject>

@required

/// 星期几
/// @param collectionView 视图
/// @param layout 布局
/// @param indexPath 下标布局
- (NSUInteger)collectionView:(UICollectionView *)collectionView
                      layout:(ScheduleCollectionViewLayout *)layout
      weekForItemAtIndexPath:(NSIndexPath *)indexPath;

/// 第几节-长度
/// @param collectionView 视图
/// @param layout 布局
/// @param indexPath 下标
- (NSRange)collectionView:(UICollectionView *)collectionView
                   layout:(ScheduleCollectionViewLayout *)layout
  rangeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

/// 双人展示 - 对比两个重合的视图
/// @param collectionView 视图
/// @param layout 布局
/// @param originIndexPath 之前在视图里面的下标
/// @param conflictIndexPath 即将往视图里添加的下标
/// @param block 如果要重新绘制range就掉用，可以不掉用
- (NSComparisonResult)collectionView:(UICollectionView *)collectionView
                              layout:(ScheduleCollectionViewLayout *)layout
              compareOriginIndexPath:(NSIndexPath *)originIndexPath
               conflictWithIndexPath:(NSIndexPath *)conflictIndexPath
                   relayoutWithBlock:(void (^)(NSRange originRange, NSRange comflictRange))block;

/// 如果重合了，则会在这个代理方法里回传
/// 只要有这个协议，必定会掉用
/// @param collectionView 视图
/// @param layout 布局
/// @param indexPath 所展示的下标
- (void)collectionView:(UICollectionView *)collectionView
                layout:(ScheduleCollectionViewLayout *)layout
 mutiLayoutAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - ScheduleCollectionViewLayout

@interface ScheduleCollectionViewLayout : UICollectionViewLayout

/// 代理
@property (nonatomic, weak) id <ScheduleCollectionViewLayoutDataSource> dataSource;

/// 行间距
@property (nonatomic) CGFloat lineSpacing;

/// 列间距
@property (nonatomic) CGFloat columnSpacing;

/// 前部装饰视图宽
@property (nonatomic) CGFloat widthForLeadingSupplementaryView;

/// 头部装饰视图高
@property (nonatomic) CGFloat heightForHeaderSupplementaryView;

/// 双人课表callback，默认为NO
/// 如果是YES， 必掉用optional的**compareOrigin:conflictWith:**回掉
/// 否则则不会掉用
@property (nonatomic) BOOL callBack;

@end

NS_ASSUME_NONNULL_END
