//
//  ViewController.m
//  FDanmakuDemo
//
//  Created by allison on 2018/5/17.
//  Copyright © 2018年 allison. All rights reserved.
//

#import "ViewController.h"
#import "FDanmakuView.h"
#import "FDanmakuModel.h"

@interface ViewController ()<FDanmakuViewProtocol>
@property(nonatomic,weak)FDanmakuView *danmakuView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FDanmakuView *danmaView = [[FDanmakuView alloc]initWithFrame:CGRectMake(100, 50, 250, 200)];
    danmaView.backgroundColor = [UIColor orangeColor];
    danmaView.delegate = self;
    self.danmakuView = danmaView;
    [self.view addSubview:danmaView];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    FDanmakuModel *model1 = [[FDanmakuModel alloc]init];
    model1.beginTime = 3;
    model1.liveTime = 5;
    model1.content = @"哈哈哈~😊🙂😎~~~";
    
    FDanmakuModel *model2 = [[FDanmakuModel alloc]init];
    model2.beginTime = 3.2;
    model2.liveTime = 8;
    model2.content = @"23322333";
    
    [self.danmakuView.modelsArr addObject:model1];
    [self.danmakuView.modelsArr addObject:model2];    
    
}

-(NSTimeInterval)currentTime {
    static double time = 0;
    time += 0.1 ;
    return time;
}

- (UIView *)danmakuViewWithModel:(FDanmakuModel*)model {
    
    UILabel *label = [UILabel new];
    label.text = model.content;
    [label sizeToFit];
    return label;
    
}
- (void)danmuViewDidClick:(UIView *)danmuView at:(CGPoint)point {
    NSLog(@"%@ %@",danmuView,NSStringFromCGPoint(point));
}

- (IBAction)pauseClick:(UIButton *)sender {
    [self.danmakuView pause];
}

- (IBAction)resumeClick:(UIButton *)sender {
    [self.danmakuView resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
