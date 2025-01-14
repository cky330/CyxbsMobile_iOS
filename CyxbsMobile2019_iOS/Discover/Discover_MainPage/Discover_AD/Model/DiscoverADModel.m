//
//  DiscoverADModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/3/30.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "DiscoverADModel.h"

@implementation DiscoverADModel

#pragma mark - Init

- (void)requestBannerSuccess:(void (^)(void))setModel
                     failure:(void (^)(NSError *error))failure {
    
    [HttpTool.shareTool
     request:Discover_GET_bannerView_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"🟢AD:\n%@", object);
        
        DiscoverADs *ADs = [[DiscoverADs alloc] initWithDictionary:object];
        
        self.ADCollectionInformation = ADs;
        
        setModel();
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"🔴Discover AD Model Error:\n%@", error);
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - <UICollectionViewDataSource>

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 有代理才执行
    if (self.delegate) {
        // 如果这个最开始为空，则直接出去
        if (self.ADCollectionInformation == nil) {
            return [self.delegate discoverAD:nil cellForCollectionView:collectionView];
        }
        // 同理，个数为0啥也不是
        if (self.ADCollectionInformation.ADCollection.count == 0) {
            return [self.delegate discoverAD:nil cellForCollectionView:collectionView];
        }
        // 第0个传最后一个，其他的按取余方式传递
        if (indexPath.item == 0) {
            return [self.delegate discoverAD:self.ADCollectionInformation.ADCollection[self.ADCollectionInformation.ADCollection.count - 1] cellForCollectionView:collectionView];
        } else {
            return [self.delegate discoverAD:self.ADCollectionInformation.ADCollection[(indexPath.item - 1) % self.ADCollectionInformation.ADCollection.count] cellForCollectionView:collectionView];
        }
    }
    
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 如果没有或者个数为0，则有一个让collection显示默认，否则应该返回个数+2个，实现无限循环
    return self.ADCollectionInformation ? (self.ADCollectionInformation.ADCollection.count == 0 ? 1 : self.ADCollectionInformation.ADCollection.count + 2) : 1;
}

@end
