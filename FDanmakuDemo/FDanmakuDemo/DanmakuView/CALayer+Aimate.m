//
//  CALayer+Aimate.m
//  FDanmakuDemo
//
//  Created by allison on 2018/5/21.
//  Copyright © 2018年 allison. All rights reserved.
//

#import "CALayer+Aimate.h"

@implementation CALayer (Aimate)

// 暂停动画
- (void)pauseAnimate {
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

// 恢复动画
- (void)resumeAnimate {
    
    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
    
}
@end
