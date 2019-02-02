//
//  RootTabBarController.m
//  SecretAlbum
//
//  Created by 王雪剑 on 17/11/27.
//  Copyright © 2017年 zkml－wxj. All rights reserved.
//

#import "RootTabBarController.h"
#import "HomeMainViewController.h"
#import "VideoMainViewController.h"
#import "CenterViewController.h"
#import "TabBar.h"
#import "MyMainViewController.h"
#import "VoiceMainViewController.h"

@interface RootTabBarController ()
{
    HomeMainViewController *homeVc;
    VideoMainViewController *videoVc;
    MyMainViewController *myVc;
    VoiceMainViewController *voiceVc;
}
@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createChildVc];
}

-(void)createChildVc{
    TabBar *tabBar = [[TabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    
    [tabBar setDidClickPublishBtn:^{
        CenterViewController *hmpositionVC = [[CenterViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hmpositionVC];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    
    
    homeVc = [[HomeMainViewController alloc]init];
    [self addChildVc:homeVc title:@"照片" image:@"car_easy_tabbar_hand_normal" selectImage:@"car_easy_tabbar_hand_press"];
    
    videoVc = [[VideoMainViewController alloc]init];
    [self addChildVc:videoVc title:@"视频" image:@"car_easy_tabbar_travel_normal" selectImage:@"car_easy_tabbar_travel_press"];
    
    voiceVc = [[VoiceMainViewController alloc]init];
    [self addChildVc:voiceVc title:@"语音" image:@"car_easy_tabbar_travel_normal" selectImage:@"car_easy_tabbar_travel_press"];
    
    myVc = [[MyMainViewController alloc]init];
    [self addChildVc:myVc title:@"我的" image:@"car_easy_tabbar_travel_normal" selectImage:@"car_easy_tabbar_travel_press"];
}

- (void)addChildVc:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage{
    
    childVC.title = title;
    childVC.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YFColor(123, 123, 123);
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *selectAttrs = [NSMutableDictionary dictionary];
    selectAttrs[NSForegroundColorAttributeName] = YFColor(66, 172, 253);
    [childVC.tabBarItem setTitleTextAttributes:selectAttrs forState:UIControlStateSelected];
    
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:childVC];
    
    [self addChildViewController:navVC];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
