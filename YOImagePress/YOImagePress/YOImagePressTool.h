//
//  YOImagePressTool.h
//  YOImagePress
//
//  Created by yangou on 2020/3/31.
//  Copyright © 2020 hello. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YOImagePressTool : NSObject

/**
 内存处理，循环压缩处理，图片处理过程中内存不会爆增

 @param image 原始图片
 @param fImageKBytes 限制最终的文件大小
 @param block 处理之后的数据返回，data类型
 */
+ (UIImage *)compressedImageFiles:(UIImage *)image LimitImageKB:(CGFloat)fImageKBytes;




@end

NS_ASSUME_NONNULL_END
