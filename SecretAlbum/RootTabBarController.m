//
//  RootTabBarController.m
//  SecretAlbum
//
//  Created by 王雪剑 on 17/11/27.
//  Copyright © 2017年 zkml－wxj. All rights reserved.
//

#import "RootTabBarController.h"
#import "HomeViewController.h"

@interface RootTabBarController ()
{
    HomeViewController *homeVc;
}
@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    homeVc = [[HomeViewController alloc]init];
    [self addChildVc:homeVc title:@"首页" image:@"car_easy_tabbar_realtime_normal" selectImage:@"car_easy_tabbar_realtime_press"];
    
   
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
