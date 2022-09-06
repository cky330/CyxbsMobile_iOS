//
//  RisingUIKitExtension.h
//  Rising
//
//  Created by SSR on 2022/7/11.
//

#import <UIKit/UIKit.h>

#ifndef RisingUIKitExtension_h
#define RisingUIKitExtension_h

UIKIT_STATIC_INLINE NSIndexPath *IndexPathForRange(NSRange range) {
    return [NSIndexPath indexPathForItem:range.length inSection:range.location];
}

UIKIT_EXTERN NSString *const UICollectionElementKindSectionLeading;
UIKIT_EXTERN NSString *const UICollectionElementKindSectionTrailing;

@interface UIApplication (Rising)

@property (nonatomic, readonly, class) UIViewController *topViewController;

+ (UIViewController *)topViewControllerWithBase:(UIViewController *)VC;

@end

#endif /* RisingUIKitExtention_h */
