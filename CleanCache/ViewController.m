//
//  ViewController.m
//  CleanCache
//
//  Created by sunzhaokai on 16/5/11.
//  Copyright © 2016年 孙赵凯. All rights reserved.
//

#import "ViewController.h"

#import "SZKCleanCache.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //输出缓存大小 m
    NSLog(@"%.2fm",[SZKCleanCache folderSizeAtPath]);
    
    //清楚缓存
    [SZKCleanCache cleanCache:^{
        NSLog(@"清除成功");
    }];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
