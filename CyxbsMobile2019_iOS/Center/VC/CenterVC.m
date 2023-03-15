//
//  CenterVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 宋开开 on 2023/3/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "CenterVC.h"
#import "CenterView.h"
#import "ClassTabBar.h"
#import <Accelerate/Accelerate.h>

@interface CenterVC ()

/// 封面View
@property (nonatomic, strong) CenterView *centerView;

/// 虚化模糊效果Array
@property (nonatomic, copy) NSArray <UIImageView *> *blurImgViewArray;

@end

@implementation CenterVC

#pragma mark - Life Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.blurImgViewArray = [NSArray array];
    // 不做上拉课表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideBottomClassScheduleTabBarView" object:nil userInfo:nil];
    // 颜色
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc]init];
        appearance.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.tabBarController.tabBar.scrollEdgeAppearance = appearance;
        self.tabBarController.tabBar.standardAppearance = appearance;
    }
    
    if (self.blurImgViewArray.count != 0) {
        [self.tabBarController.tabBar addSubview:self.blurImgViewArray[0]];
    } else {
        [self test2];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testTabBar];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    // 恢复背景颜色
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc]init];
        appearance.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#2C2C2C" alpha:1]];
        self.tabBarController.tabBar.scrollEdgeAppearance = appearance;
        self.tabBarController.tabBar.standardAppearance = appearance;
    }
    [self.blurImgViewArray[0] removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBottomClassScheduleTabBarView" object:nil userInfo:nil];
}

#pragma mark - Method

- (void)testTabBar {
    if (@available(iOS 15.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc]init];
        appearance.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.tabBarController.tabBar.scrollEdgeAppearance = appearance;
        self.tabBarController.tabBar.standardAppearance = appearance;
    }
    [self test2];
}

// MARK: 毛玻璃

- (void)test2 {

    CGRect rect = CGRectMake(0, 0, (self.tabBarController.tabBar.frame.size.width)/3, self.tabBarController.tabBar.frame.size.height);
    UIImage *img = [self captureTabBarImageInRect:rect];
    // showImgView
    UIImageView *imgView = [self boxblurImage:img withBlurNumber:0.05];
    imgView.frame = rect;
    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObject:imgView];
    self.blurImgViewArray = tempArray;
    [self.tabBarController.tabBar addSubview:self.blurImgViewArray[0]];
}

// 去除毛玻璃
- (void)removeToolBar {
    
}

// 截取内容转换成UIImage
- (UIImage *)captureTabBarImageInRect:(CGRect)rect {
    // 获取需要截图的区域
    CGRect screenRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);

    // 开始截图
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, -screenRect.origin.x, -screenRect.origin.y);

    // 将截取的区域渲染到图像上下文中
    CGContextConcatCTM(ctx, CGAffineTransformMakeScale(1.0f, 1.0f));
    [self.tabBarController.tabBar.layer renderInContext:ctx];

    // 获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    // 结束图像上下文
    UIGraphicsEndImageContext();
    return image;
}

// 图片模糊算法
- (UIImageView *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    // 从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    // 设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    for (int y = 0; y < outBuffer.height; y++) {
        for (int x = 0; x < outBuffer.width; x++) {
            uint8_t *pixel = outBuffer.data + y * outBuffer.rowBytes + x * 4;
            pixel[3] *= 0.5;
        }
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:returnImage];
    return imgView;
}

@end
