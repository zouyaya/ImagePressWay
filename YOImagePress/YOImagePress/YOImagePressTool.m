//
//  YOImagePressTool.m
//  YOImagePress
//
//  Created by yangou on 2020/3/31.
//  Copyright © 2020 hello. All rights reserved.
//

#import "YOImagePressTool.h"

@implementation YOImagePressTool

+ (UIImage *)compressedImageFiles:(UIImage *)image LimitImageKB:(CGFloat)fImageKBytes
{
    //二分法压缩图片
      CGFloat compression = 1;
      NSData *imageData = UIImageJPEGRepresentation(image, compression);
      NSUInteger fImageBytes = fImageKBytes * 1000;//需要压缩的字节Byte，iOS系统内部的进制1000
      if (imageData.length <= fImageBytes){
        UIImage *resultImage = [self createImageForData:imageData maxPixelSize:MAX(image.size.width, image.size.height)];
        return resultImage;
      }
      CGFloat max = 1;
      CGFloat min = 0;
      //指数二分处理，s首先计算最小值
      compression = pow(2, -6);
      imageData = UIImageJPEGRepresentation(image, compression);
      if (imageData.length < fImageBytes) {
          //二分最大10次，区间范围精度最大可达0.00097657；最大6次，精度可达0.015625
          for (int i = 0; i < 6; ++i) {
              compression = (max + min) / 2;
              imageData = UIImageJPEGRepresentation(image, compression);
              //容错区间范围0.9～1.0
              if (imageData.length < fImageBytes * 0.9) {
                  min = compression;
              } else if (imageData.length > fImageBytes) {
                  max = compression;
              } else {
                  break;
              }
          }
          
          UIImage *resultImage = [self createImageForData:imageData maxPixelSize:MAX(image.size.width, image.size.height)];
          return resultImage;

      }
      
      // 对于图片太大上面的压缩比即使很小压缩出来的图片也是很大，不满足使用。
      //然后再一步绘制压缩处理
      UIImage *resultImage = [UIImage imageWithData:imageData];
      while (imageData.length > fImageBytes) {
          @autoreleasepool {
              CGFloat ratio = (CGFloat)fImageBytes / imageData.length;
              //使用NSUInteger不然由于精度问题，某些图片会有白边
              CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                       (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
              resultImage = [self createImageForData:imageData maxPixelSize:MAX(size.width, size.height)];
              imageData = UIImageJPEGRepresentation(resultImage, compression);
          }
      }
      
    return resultImage;
      //   整理后的图片尽量不要用UIImageJPEGRepresentation方法转换，后面参数1.0并不表示的是原质量转换。

    

    
}


+ (UIImage *)createImageForData:(NSData *)data maxPixelSize:(NSUInteger)size {
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                                                                      (NSString *)kCGImageSourceThumbnailMaxPixelSize : @(size),
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                                                                      });
    CFRelease(source);
    CFRelease(provider);
    if (!imageRef) {
        return nil;
    }
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    return toReturn;
}


@end
