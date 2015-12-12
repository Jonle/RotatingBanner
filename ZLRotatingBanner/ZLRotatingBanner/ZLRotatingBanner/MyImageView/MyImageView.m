//
//  MyImageView.m
//  ZLRotatingBanner
//
//  Created by qianfeng on 15/12/11.
//  Copyright © 2015年 jonle. All rights reserved.
//

#import "MyImageView.h"

@interface MyImageView ()

@property (nonatomic, retain)id target;
@property (nonatomic) SEL action;

@end

@implementation MyImageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action {
    
    self.target = target;
    self.action = action;
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([self.target respondsToSelector:self.action]) {
        
        [self.target performSelector:self.action withObject:self];
    }
}



@end
