//
//  ViewController.m
//  ZLRotatingBanner
//
//  Created by qianfeng on 15/12/10.
//  Copyright © 2015年 jonle. All rights reserved.
//

#import "ViewController.h"
#import "ZLRotatingBanner.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZLRotatingBanner * banner = [[ZLRotatingBanner alloc] initRotatingBannerWithFrame:self.view.bounds duration:3];

    [self.view addSubview:banner];
    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 5; i++) {
        
        [arr addObject:[NSString stringWithFormat:@"%d.jpg",i+1]];
    }
    
    //两者可以互换使用
    banner.imgsNameArray = arr;
    banner.imgsUrlArray = arr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
