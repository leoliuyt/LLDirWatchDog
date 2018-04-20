//
//  LLDirWatchDog.m
//  LLDirWatchDog
//
//  Created by leoliu on 2018/4/19.
//  Copyright © 2018年 leoliu. All rights reserved.
//

#import "LLDirWatchDog.h"
@interface LLDirWatchDog()
{
    dispatch_source_t _dirQueueSource;
    int _dirFD;
}

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) void(^update)(void);



@end

@implementation LLDirWatchDog

+ (id)watchtdogOnDocumentsDir:(void (^)(void))update
{
    return [[self alloc] initWithPath:[self documentsPath] update:update];
}

- (id)initWithPath:(NSString *)path update:(void (^)(void))update
{
    if ((self = [super init])) {
        _path = path;
        _update = [update copy];
    }
    return self;
}

+ (NSString *)documentsPath {
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",documentsPaths[0]);
    return documentsPaths[0]; // Path to the application's "Documents" directory
}


- (void)start {
    NSString* docPath = self.path;
    if (!docPath) return;
    
    int dirFD = open([docPath fileSystemRepresentation], O_EVTONLY);
    if (dirFD < 0) {return;}
    
    _dirQueueSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, dirFD, DISPATCH_VNODE_WRITE, dispatch_get_main_queue());
    
    if (!_dirQueueSource)
    {
        close(dirFD);
    }
    _dirFD = dirFD;
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_dirQueueSource, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.update) {
            strongSelf.update();
        }
    });
    dispatch_source_set_cancel_handler(_dirQueueSource, ^{close(dirFD);});
    dispatch_resume(_dirQueueSource);
}

- (void)stop
{
    dispatch_source_cancel(_dirQueueSource);
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [self stop];
}

@end
