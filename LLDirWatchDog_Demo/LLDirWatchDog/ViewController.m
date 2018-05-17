//
//  ViewController.m
//  LLDirWatchDog
//
//  Created by leoliu on 2018/4/19.
//  Copyright © 2018年 leoliu. All rights reserved.
//

#import "ViewController.h"
#import "LLDirWatchDog.h"

@interface ViewController ()
@property (nonatomic, strong) LLDirWatchDog *watchDog;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *rootPath = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"projectPath"];
    self.watchDog = [[LLDirWatchDog alloc] initWithPath:rootPath update:^{
        NSLog(@"-------");
    }];
    [self.watchDog start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
