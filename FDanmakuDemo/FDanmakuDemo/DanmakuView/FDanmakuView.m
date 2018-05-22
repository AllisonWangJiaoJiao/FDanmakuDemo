//
//  FDanmakuView.m
//  FDanmakuDemo
//
//  Created by allison on 2018/5/17.
//  Copyright © 2018年 allison. All rights reserved.
//

#import "FDanmakuView.h"
#import "CALayer+Aimate.h"
//#define kClockSec  0.1
//#define kDandaoCount  5
static const CGFloat   kClockSec     = 0.1;
static const CGFloat   kDandaoCount  = 5;

@interface FDanmakuView()
{
    BOOL _isPause;
}
@property (nonatomic,weak)NSTimer *clock;
@property (nonatomic,strong)NSMutableArray *laneWaitTimeArr;
@property (nonatomic,strong)NSMutableArray *laneLeftTimeArr;
@property (nonatomic,strong)NSMutableArray *danmakuViewArr;

@end

@implementation FDanmakuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    CGPoint point = [tap locationInView:tap.view];
    for (UIView *danmuView in self.danmakuViewArr) {
        CGRect frame = danmuView.layer.presentationLayer.frame;
        BOOL isContain = CGRectContainsPoint(frame, point);
        if (isContain) {
            if ([self.delegate respondsToSelector:@selector(danmuViewDidClick:at:)]) {
                [self.delegate danmuViewDidClick:danmuView at:point];
            }
            break;
        }
    }
}

#pragma mark -- 生命周期方法
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self clock];
    self.layer.masksToBounds = YES;
}
-(void)dealloc {
    [self.clock invalidate];
    self.clock = nil;
}
#pragma mark -- 接口
/// 暂停
- (void)pause {
    _isPause = YES;
    [[self.danmakuViewArr valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(pauseAnimate)];
    
    [self.clock invalidate];
    self.clock = nil;
}
/// 继续
- (void)resume {
    _isPause = NO;
    [[self.danmakuViewArr valueForKeyPath:@"layer"] makeObjectsPerformSelector:@selector(resumeAnimate)];
    [self clock];
}

#pragma mark -- 私有方法
- (void)checkAndBiu {
    if (_isPause) {
        return;
    }
    // 实时更新弹道记录的时间信息
    for (int i = 0; i < kDandaoCount; i++) {
        double waitValue = [self.laneWaitTimeArr[i] doubleValue] - kClockSec;
        if (waitValue <= 0.0) {
            waitValue = 0.0;
        }
        self.laneWaitTimeArr[i] = @(waitValue);
        
        double leftValue = [self.laneLeftTimeArr[i] doubleValue] - kClockSec;
        if (leftValue <= 0.0) {
            leftValue = 0.0;
        }
        self.laneLeftTimeArr[i] = @(leftValue);
    }
    
    
    [self.modelsArr sortUsingComparator:^NSComparisonResult(id<FDanmakuModelProtocol>  _Nonnull obj1, id<FDanmakuModelProtocol>  _Nonnull obj2) {
        if (obj1.beginTime < obj2.beginTime) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending; //降序
    }];
    // 检测模型数组里面所有的模型，是否可以发射 如果可以,直接发射
    NSMutableArray *deleteModelArr = [NSMutableArray array];
    for (id<FDanmakuModelProtocol> model in self.modelsArr) {
        //1.检测开始时间是否有到达
        NSTimeInterval beginTime = model.beginTime;
        NSTimeInterval currentTime = self.delegate.currentTime;
        if (beginTime > currentTime) {
            break;
        }
        //2.检测碰撞
        BOOL result = [self checkBoomAndBiuWith:model];
        if (result) {
            [deleteModelArr addObject:model];
        }
    }
    [self.modelsArr removeObjectsInArray:deleteModelArr];
}
#pragma mark -- 检测碰撞
- (BOOL)checkBoomAndBiuWith:(id<FDanmakuModelProtocol>)model {
    
    CGFloat danmakuH = self.frame.size.height / kDandaoCount ;
    // 遍历所有的弹道，在每个弹道里面，进行检测（检测开始碰撞 检测结束碰撞）
    for (int i = 0 ; i < kDandaoCount; i++) {
        //1.获取该弹道的绝对等待时间
        NSTimeInterval waitTime = [self.laneWaitTimeArr[i] doubleValue];
        if (waitTime > 0.0) {
            continue;
        }
        //2.绝对等待时间没有 暂时可以发射 需要判断 是否与前一个弹幕视图产生碰撞
        UIView * danmakuView = [self.delegate danmakuViewWithModel:model];
        NSTimeInterval leftTime = [self.laneLeftTimeArr[i] doubleValue];
        // 速度 = (弹幕视图的宽度 + 弹幕背景的宽度)/liveTime
        double speed = ( danmakuView.frame.size.width + self.frame.size.width) / model.liveTime;
        double distance = leftTime * speed;
        if (distance > self.frame.size.width) {
            continue;
        }
        
        [self.danmakuViewArr addObject:danmakuView];
        
        //重置数据
        // 距离/秒 = 速度v
        self.laneWaitTimeArr[i] = @(danmakuView.frame.size.width / speed);
        self.laneLeftTimeArr[i] = @(model.liveTime);
        
        //3.弹幕肯定可以发射
        //3.1 先把弹幕视图，加到弹幕背景里面
        CGRect frame = danmakuView.frame;
        frame.origin = CGPointMake(self.frame.size.width, danmakuH * i);
        danmakuView.frame = frame;
        [self addSubview:danmakuView];
        
        [UIView animateWithDuration:model.liveTime delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect frame = danmakuView.frame;
            frame.origin.x = - danmakuView.frame.size.width;
            danmakuView.frame = frame;
        } completion:^(BOOL finished) {
            [danmakuView removeFromSuperview];
            [self.danmakuViewArr removeObject:danmakuView];
        }];
        
        return YES;
    }
    
    return NO;
}
#pragma mark --set  get
- (NSMutableArray *)modelsArr {
    if (!_modelsArr) {
        _modelsArr = [NSMutableArray array];
    }
    return  _modelsArr;
}

-(NSTimer *)clock {
    if (!_clock) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:kClockSec repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self checkAndBiu];
        }];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        _clock = timer;
    }
    return _clock;
}
- (NSMutableArray *)laneWaitTimeArr {
    if (!_laneWaitTimeArr) {
        _laneWaitTimeArr = [NSMutableArray arrayWithCapacity:kDandaoCount];
        for (int i = 0; i < kDandaoCount; i ++) {
            _laneWaitTimeArr[i] = @0.0;
        }
    }
    return _laneWaitTimeArr;
}

- (NSMutableArray *)laneLeftTimeArr {
    if (!_laneLeftTimeArr) {
        _laneLeftTimeArr = [NSMutableArray arrayWithCapacity:kDandaoCount];
        for (int i = 0; i < kDandaoCount; i ++) {
            _laneLeftTimeArr[i] = @0.0;
        }
    }
    return _laneLeftTimeArr;
}

- (NSMutableArray *)danmakuViewArr {
    if (!_danmakuViewArr) {
        _danmakuViewArr = [NSMutableArray array];
    }
    return  _danmakuViewArr;
}

@end




