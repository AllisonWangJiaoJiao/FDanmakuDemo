//
//  FDanmakuView.h
//  FDanmakuDemo
//
//  Created by allison on 2018/5/17.
//  Copyright © 2018年 allison. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDanmakuModelProtocol.h"

@protocol FDanmakuViewProtocol <NSObject>
@property (nonatomic,readonly)NSTimeInterval currentTime;
- (UIView *)danmakuViewWithModel:(id<FDanmakuModelProtocol>)model;
- (void)danmuViewDidClick:(UIView *)danmuView at:(CGPoint)point;

@end

@interface FDanmakuView : UIView
@property (nonatomic, weak) id<FDanmakuViewProtocol> delegate;
@property (nonatomic,strong) NSMutableArray <id <FDanmakuModelProtocol>> *modelsArr;
/// 暂停
- (void)pause;
/// 继续
- (void)resume;
@end
