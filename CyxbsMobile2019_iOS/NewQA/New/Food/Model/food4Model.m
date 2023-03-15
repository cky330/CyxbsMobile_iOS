//
//  food4Model.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/1/25.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "food4Model.h"

@implementation food4Model

- (void)getname:(NSString *)name requestSuccess:(void (^)(void))success failure:(void (^)(NSError * _Nonnull))failure{
    
    NSDictionary *paramters = @{
        @"name":name
    };
    
    [HttpTool.shareTool
     request:Discover_GET_GPA_API
     type:HttpToolRequestTypeGet
     serializer:HttpToolRequestSerializerJSON
     bodyParameters:paramters
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"🟢%@:\n%@", self.class, object);
        self.status = [object[@"status"] intValue];
        if (self.status == 10000) {
            NSDictionary *data = object[@"data"];
            self.name = [data[@"name"] stringValue];
            self.pictureURL = [data[@"picture"] stringValue];
            self.introduce = [data[@"introduce"] stringValue];
            self.praise_num = [data[@"praise_num"] intValue];
            self.praise_is = [data[@"praise_is"] boolValue];
        }
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"🔴%@:\n%@", self.class, error);
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
