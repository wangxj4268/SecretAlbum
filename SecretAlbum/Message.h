//
//  Message.h
//
//  Created by 谭 昱国 on 13-10-9.
//  Copyright (c) 2013年 AHITS. All rights reserved.
//

#import <UIKit/UIKit.h>

//实现程序中等待网络操作和提示信息的弹出

//考虑到任何时刻,用户只可能看到一个等待网络操作视图，所以本类使用了单例模式，并且所有方法都声明为类方法，避免产生多个等待网络操作视图

@interface Message : NSObject
{
    UIActivityIndicatorView *indicatorView;
}
//本类使用单例模式
+ (Message *)sharedMessage;

//显示等待网络操作视图
//两个方法都带了操作对象作为参数，以便于实现点击等待界面取消操作
 
- (void)showWaitingWithStopOperation:(void (^)(void))block;
- (void)showActivityIndicator:(NSString *)message ;
- (void)showActivityIndicator2;


-(void)hiddenActivityIndicator;
-(void)hiddenActivityIndicator2;

//隐藏等待网络操作视图
- (void)hideWaiting;

//在屏幕下方弹出一条提示消息，一段时间后自动消失。消息内容为message
- (void)showFlashMessage:(NSString *)message;

//在屏幕下方弹出一条带有图片的提示消息，一段时间后自动消失。消息内容为message
- (void)showImageMessage:(NSString *)message isCorrect:(BOOL)isCorrect;

@end
