//
//  YFLookImageView.m
//  NewRefactorEasyCar
//
//  Created by 王雪剑 on 2018/1/11.
//  Copyright © 2018年 张凯翔. All rights reserved.
//

#import "YFLookImageView.h"
#import "UIImageView+WebCache.h"

@implementation YFLookImageView

-(id)initWithUrlStr:(NSString *)imageStr{
    if (self = [super init]) {
        UIImageView *imageView = [[UIImageView alloc]init];
        if (notNull(imageStr)) {
            [imageView  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"car_easy_add_loading_icon"]];
        }else{
            imageView.image = [UIImage imageNamed:@"car_easy_add_loading_icon"];
        }
        [self createViewWithImage:imageView.image];
    }
    return self;
}

-(id)initWithImage:(UIImage *)image{
    if (self = [super init]) {
        [self createViewWithImage:image];
    }
    return self;
}

#pragma mark ********【界面】********创建界面
-(void)createViewWithImage:(UIImage *)image{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    self.userInteractionEnabled = YES;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, kSelfWidth, kSelfHeight)];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    imageView.center = self.center;
    [self addSubview:imageView];
    
    //包含返回按钮
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kSelfWidth, 44)];
//    headView.backgroundColor = [UIColor blackColor];
//    [self addSubview:headView];
//    
//    //返回按钮
//    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(kSize(48), (44-kSize(72))/2, kSize(72), kSize(72));
//    [leftBtn setImage:[UIImage imageNamed:@"icon1_3"] forState:UIControlStateNormal];
//    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [headView addSubview:leftBtn];
//    
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftBtn.frame), 0, kSelfWidth-2*CGRectGetMaxX(leftBtn.frame), 44)];
//    label.font = [UIFont systemFontOfSize:kFont(48)];
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = @"查看图片";
//    [headView addSubview:label];
    
 
    
   
    
    
    //仿原生系统的弹出效果
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:popAnimation forKey:nil];
}

-(void)animationStyle{
    // 缩放动画
    CABasicAnimation *a2 = [CABasicAnimation animation];
    a2.keyPath = @"transform.scale";
    a2.toValue = @(0.0);
    // 组动画
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.delegate = self;
    groupAnima.animations = @[a2];
    
    //设置组动画的时间
    groupAnima.duration = 0.4;
    groupAnima.fillMode = kCAFillModeForwards;
    groupAnima.removedOnCompletion = NO;
    groupAnima.repeatCount = 1;
    [self.layer addAnimation:groupAnima forKey:nil];
}

-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"--开始动画--");
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"--结束动画--");
    [self.superview removeFromSuperview];
}

#pragma mark ********【操作】********返回
-(void)leftBtnClick:(UIButton *)sender{
    [self animationStyle];
}

- (void)handleCancel:(id)sender {
   [self animationStyle];
}


- (void)show{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    UIView *backView = [[UIView alloc] initWithFrame:window.bounds];
    backView.backgroundColor = [UIColor clearColor];
    [window addSubview:backView];
    
    UIView *view = [[UIView alloc] initWithFrame:window.bounds];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [backView addSubview:view];
    
    self.center = backView.center;
    [backView addSubview:self];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCancel:)];
    [self addGestureRecognizer:tapGR];
}

@end
