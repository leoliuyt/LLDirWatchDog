//
//  LLDirWatchDog.h
//  LLDirWatchDog
//
//  Created by leoliu on 2018/4/19.
//  Copyright © 2018年 leoliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLDirWatchDog : NSObject

+ (id)watchtdogOnDocumentsDir:(void (^)(void))update;
- (id)initWithPath:(NSString *)path update:(void (^)(void))update;
- (void)start;
- (void)stop;
@end
