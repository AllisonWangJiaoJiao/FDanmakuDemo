//
//  FDanmakuModel.h
//  FDanmakuDemo
//
//  Created by allison on 2018/5/21.
//  Copyright © 2018年 allison. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FDanmakuModelProtocol.h"

@interface FDanmakuModel : NSObject <FDanmakuModelProtocol>

@property (nonatomic,assign)NSTimeInterval beginTime;
@property (nonatomic,assign)NSTimeInterval liveTime;
@property (nonatomic,copy)NSString *content;

@end
