//
//  FDanmakuModelProtocol.h
//  FDanmakuDemo
//
//  Created by allison on 2018/5/17.
//  Copyright © 2018年 allison. All rights reserved.
//

@protocol FDanmakuModelProtocol <NSObject>

@required
@property (nonatomic,readonly)NSTimeInterval beginTime;
@property (nonatomic,readonly)NSTimeInterval liveTime;

@end
