//
//  ZLRotatingBanner.h
//  ZLRotatingBanner
//
//  Created by qianfeng on 15/12/10.
//  Copyright © 2015年 jonle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZLRotatingBanner : UIView

/** 页码指示器的高 */
@property (nonatomic, assign) CGFloat pageControlHeight;

/** 本地图片名数组 */
@property (nonatomic, retain) NSArray * imgsNameArray;
/** 网络图片Url数组 */
@property (nonatomic, retain) NSArray * imgsUrlArray;

/** 显示加载网络图片前的Image */
@property (nonatomic, retain) UIImage * placeHolderImage;

/** 计时器计时的间隔 */
@property (nonatomic, assign) CGFloat duration;

+ (instancetype)defaultRotatingBannerWithFrame:(CGRect)frame;

- (instancetype)initRotatingBannerWithFrame:(CGRect)frame;

+ (instancetype)defaultRotatingBannerWithFrame:(CGRect)frame duration:(CGFloat)duration;

- (instancetype)initRotatingBannerWithFrame:(CGRect)frame  duration:(CGFloat)duration;

/** 点击图片返回索引 */
- (void)clickWithBlock:(void(^)(NSInteger index))index;

@end
