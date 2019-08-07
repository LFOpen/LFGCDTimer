//
//  LFGCDTImer.h
//  GCD
//
//  Created by ArcherLj on 2019/8/7.
//  Copyright © 2019 ArcherLj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 GCDTimer 不会强引用UIViewController，不存在NSTimer的RunLoopMode的缺陷。
 定义所在的UIViewController销毁的时候会自动销毁，不需要显示调用invalidate.
 */
@interface LFGCDTimer : NSObject

+(LFGCDTimer *)scheduledTimerWithTimeInterval:(float)interval
                              repeats:(BOOL)repeat
                                block: (void(^)(void))block;

+(LFGCDTimer *)timerWithTimeInterval:(float)interval
                              target:(id)target
                            selector:(SEL)selector
                            userInfo:(id)userInfo
                             repeats:(BOOL)repeat;

-(void)invalidate;
@end

NS_ASSUME_NONNULL_END
