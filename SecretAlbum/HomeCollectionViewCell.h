//
//  HomeCollectionViewCell.h
//  SecretAlbum
//
//  Created by 王雪剑 on 17/11/27.
//  Copyright © 2017年 zkml－wxj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCollectionModel.h"

@protocol HomeCollectionViewCellDelegate <NSObject>
-(void)handleLongGestureOnClick:(NSInteger)index;
@end

@interface HomeCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) HomeCollectionModel *model;
@property (nonatomic,weak) id<HomeCollectionViewCellDelegate>delegate;

@end
