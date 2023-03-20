//
//  ExpressPickPutModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 艾 on 2023/2/5.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 表态投票
@interface ExpressPickPutModel : NSObject

- (void)requestPickDataWithId:(NSNumber *)theID Choice:(NSString *)choice Success:(void(^)(NSArray *array))success Failure:(void(^)(void))failure;

@end

NS_ASSUME_NONNULL_END