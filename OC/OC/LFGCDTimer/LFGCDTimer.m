//
//  LFGCDTImer.m
//  GCD
//
//  Created by ArcherLj on 2019/8/7.
//  Copyright © 2019 ArcherLj. All rights reserved.
//

#import "LFGCDTimer.h"

@interface LFGCDTimer()
@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation LFGCDTimer

+(LFGCDTimer *)scheduledTimerWithTimeInterval:(float)interval
                                      repeats:(BOOL)repeat
                                        block:(void(^)(void))block {
    
    LFGCDTimer *gcdTimer = [[LFGCDTimer alloc] init];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    gcdTimer.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_source_set_timer(gcdTimer.timer, start, (int64_t)(interval * NSEC_PER_SEC), 0);
    
    __weak typeof(LFGCDTimer *) weakGCDTimer = gcdTimer;
    dispatch_source_set_event_handler(gcdTimer.timer, ^{
        block();
        if (!repeat) {
            __strong typeof(LFGCDTimer *) strongGCDTimer = weakGCDTimer;
            dispatch_cancel(strongGCDTimer.timer);
            strongGCDTimer.timer = nil;
        }
    });
    
    dispatch_resume(gcdTimer.timer);
    return gcdTimer;
}

+(LFGCDTimer *)timerWithTimeInterval:(float)interval
                              target:(id)target
                            selector:(SEL)selector
                            userInfo:(id)userInfo
                             repeats:(BOOL)repeat {
    
    LFGCDTimer *gcdTimer = [[LFGCDTimer alloc] init];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    gcdTimer.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC));
    dispatch_source_set_timer(gcdTimer.timer, start, (int64_t)(interval * NSEC_PER_SEC), 0);
    
    __weak typeof([target class]) weakTarget = target;
    __weak typeof(LFGCDTimer *) weakGCDTimer = gcdTimer;
    
    dispatch_source_set_event_handler(gcdTimer.timer, ^{
        
        __strong typeof([weakTarget class]) strongTarget = weakTarget;
        __strong typeof(LFGCDTimer *) strongGCDTimer = weakGCDTimer;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [strongTarget performSelector:selector withObject:userInfo];
#pragma clang diagnostic pop
        
        if (!repeat) {
            dispatch_cancel(strongGCDTimer.timer);
            strongGCDTimer.timer = nil;
        }
    });
    
    dispatch_resume(gcdTimer.timer);
    return gcdTimer;
}

-(void)invalidate {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

-(void)dealloc {
    NSLog(@"GCDTimer dealloced...");
}

@end
