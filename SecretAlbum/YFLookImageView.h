//
//  YFLookImageView.h
//  NewRefactorEasyCar
//
//  Created by 王雪剑 on 2018/1/11.
//  Copyright © 2018年 张凯翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFLookImageView : UIView <CAAnimationDelegate>

- (id)initWithUrlStr:(NSString *)imageStr;
- (id)initWithImage:(UIImage *)image;
- (void)show;

@end

//放大图片到全屏查看
