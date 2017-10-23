/************************************************************
 Class    : UIImage+YZ.m
 Describe : 自定义UIImage的扩展类
 Company  : Prient
 Author   : Yanzheng 严正
 Date     : 2017-10-20
 Version  : 1.0
 Declare  : Copyright © 2017 Yanzheng. All rights reserved.
 ************************************************************/

#import "UIImage+YZ.h"

@implementation UIImage (YZ)

#pragma mark - 根据视图的大小来计算图片的大小
+ (UIImage *)imageNamed:(NSString *)name scaleToSize:(CGSize)size {
    
    UIImage *image = [UIImage imageNamed:name];
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}

#pragma mark - 根据指定大小裁剪图片
+ (UIImage *)clipImage:(UIImage *)image rect:(CGRect)rect {
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
    
}

@end
