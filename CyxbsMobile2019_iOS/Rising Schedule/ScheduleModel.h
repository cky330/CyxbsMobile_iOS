//
//  ScheduleModel.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScheduleCourse.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ScheduleModel

@interface ScheduleModel : NSObject

/// 开始的时间
@property (nonatomic, readonly, nonnull) NSDate *startDate;

/// 当周
/// 0代表整周
/// setter里面为once
@property (nonatomic) NSUInteger nowWeek;

/// 课程数组
@property (nonatomic, readonly, nonnull) NSMutableArray <NSMutableArray <ScheduleCourse *> *> *courseAry;

/// 新增一类课，同时在整周添加
/// @param course 课程
- (void)appendCourse:(ScheduleCourse *)course;

/// 删除一类课，同时在整周删除
/// @param course 课程
- (void)removeCourse:(ScheduleCourse *)course;

@end

NS_ASSUME_NONNULL_END