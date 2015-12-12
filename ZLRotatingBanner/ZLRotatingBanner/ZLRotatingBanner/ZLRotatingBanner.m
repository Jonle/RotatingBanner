//
//  ZLRotatingBanner.m
//  ZLRotatingBanner
//
//  Created by qianfeng on 15/12/10.
//  Copyright © 2015年 jonle. All rights reserved.
//

#import "ZLRotatingBanner.h"
#import "UIImageView+WebCache.h"
#import "MyImageView.h"

@interface ZLRotatingBanner ()<UIScrollViewDelegate>
{
    NSInteger _currentIndex;
    NSTimer * _timer;
}
@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic, weak) UIPageControl * pageControl;
@property (nonatomic, copy) void(^index)(NSInteger index);

@end

@implementation ZLRotatingBanner

+ (instancetype)defaultRotatingBannerWithFrame:(CGRect)frame {
    
    return [[self alloc] initRotatingBannerWithFrame:frame];
}

- (instancetype)initRotatingBannerWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
    }
    return self;
}

+ (instancetype)defaultRotatingBannerWithFrame:(CGRect)frame duration:(CGFloat)duration{
    
    return [[self alloc] initRotatingBannerWithFrame:frame duration:duration];
}

- (instancetype)initRotatingBannerWithFrame:(CGRect)frame  duration:(CGFloat)duration{
    
    if (self = [super initWithFrame:frame]) {
        
        [self initialize];
        
        _duration = duration;
    }
    return self;
}


//初始化默认数据
- (void)initialize {
    
    _pageControlHeight = 50;
    _currentIndex = 1;
    _placeHolderImage = nil;
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView {
    
    if (!_scrollView) {
        
        UIScrollView * scr = [[UIScrollView alloc] init];
        
        scr.pagingEnabled = YES;
        scr.bounces = NO;
        scr.showsHorizontalScrollIndicator = NO;
        scr.showsVerticalScrollIndicator = NO;
        scr.delegate = self;
        
        _scrollView = scr;
        
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}
- (UIPageControl *)pageControl {
    
    if (!_pageControl) {
        
        UIPageControl * page = [[UIPageControl alloc] init];
        
        _pageControl = page;
        
        page.currentPage = 0;
        page.userInteractionEnabled = NO;
        page.currentPageIndicatorTintColor = [UIColor whiteColor];
        page.pageIndicatorTintColor = [UIColor grayColor];
        
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}


#pragma mark - setter和getter方法

- (void)setImgsNameArray:(NSArray *)imgsNameArray {
    
    _imgsNameArray = imgsNameArray;
    _imgsUrlArray = imgsNameArray;
    [self setFun:imgsNameArray.count];
}

- (void)setImgsUrlArray:(NSArray *)imgsUrlArray {
    
    _imgsUrlArray = imgsUrlArray;
    _imgsNameArray = imgsUrlArray;
    [self setFun:imgsUrlArray.count];
}

- (void)setFun:(NSInteger)count {
    
     self.pageControl.numberOfPages = count;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * count, 0);
}

#pragma mark - 创建计时器

- (void)createTimer {
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_duration target:self selector:@selector(scrollBanner:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
- (void)scrollBanner:(NSTimer *)timer {
    
    NSInteger count = _imgsNameArray.count == 0 ? _imgsUrlArray.count : _imgsNameArray.count;
    
    NSInteger index = _currentIndex == count ? _currentIndex - 1 : _currentIndex;
    
    [_scrollView setContentOffset:CGPointMake(++index * CGRectGetWidth(_scrollView.frame), 0) animated:NO];
    
    [self scrollViewDidEndScrollingAnimation:_scrollView];
    
}

#pragma mark - scrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    //取消定时器
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //创建定时器
    [self createTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self setpage:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setpage:scrollView];
}

- (void)setpage:(UIScrollView *)scrollView {
    
    NSInteger page = scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame);
    
    if (page > 1) {
        
        _currentIndex += 1;
        
        _currentIndex == _imgsNameArray.count + 1 ? _currentIndex = 1 : _currentIndex;
        
    }
    if (page < 1) {
        
        _currentIndex -= 1;
        
        _currentIndex == 0 ? _currentIndex = _imgsNameArray.count : _currentIndex;
        
    }
    
    _pageControl.currentPage = _currentIndex - 1;
    
    [self loadImage];

}

#pragma mark - 加载图片
- (void)loadImage {
    
    NSArray * array = _scrollView.subviews;
    NSInteger leftIndex = _currentIndex - 1 == 0 ? _imgsNameArray.count : _currentIndex - 1;
    NSInteger rightIndex = _currentIndex + 1 == _imgsNameArray.count + 1 ? 1 : _currentIndex + 1;
    
    if (_imgsNameArray.count && ![self isWebImagesUrl]) {
        
        ((MyImageView *)array[0]).image = [UIImage imageNamed:_imgsNameArray[leftIndex - 1]];
        ((MyImageView *)array[1]).image = [UIImage imageNamed:_imgsNameArray[_currentIndex - 1]];
        ((MyImageView *)array[2]).image = [UIImage imageNamed:_imgsNameArray[rightIndex - 1]];
        
    }else if (_imgsNameArray.count && [self isWebImagesUrl]){
        
        [((MyImageView *)array[0]) sd_setImageWithURL:_imgsNameArray[leftIndex - 1] placeholderImage:_placeHolderImage];
        [((MyImageView *)array[1]) sd_setImageWithURL:_imgsNameArray[leftIndex - 1] placeholderImage:_placeHolderImage];
        [((MyImageView *)array[2]) sd_setImageWithURL:_imgsNameArray[leftIndex - 1] placeholderImage:_placeHolderImage];
        
    }

    [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.frame), 0) animated:NO];
}

- (BOOL)isWebImagesUrl {
    
    if ([self.imgsNameArray[0] hasPrefix:@"http"]) return YES;
    
    return NO;
}


#pragma mark -

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    [super willMoveToSuperview:newSuperview];

}

- (void)didMoveToSuperview {
    
    [super didMoveToSuperview];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    self.pageControl.frame = CGRectMake(0, CGRectGetHeight(self.frame) - _pageControlHeight, CGRectGetWidth(self.bounds), _pageControlHeight);
    
    [self bringSubviewToFront:_pageControl];
    
    [self createBannerViews];
    
    [self createTimer];
}
#pragma mark - 创建ImageView

- (void)createBannerViews {
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    for (int i = 0; i<3; i++) {
        
        MyImageView * imgView = [[MyImageView alloc]initWithFrame:CGRectMake(width * i, 0, width, height)];
        [_scrollView addSubview:imgView];
        
        [imgView addTarget:self action:@selector(imgAction:)];
    }
    [self loadImage];
}

- (void)imgAction:(UIImageView *)img {
    
    if (self.index) {
        
        self.index(_currentIndex);
    }
}

- (void)clickWithBlock:(void(^)(NSInteger index))index{
    
    self.index = index;
}

@end
