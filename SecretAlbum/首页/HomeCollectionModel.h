//
//  HomeCollectionModel.h
//  SecretAlbum
//
//  Created by 王雪剑 on 17/11/27.
//  Copyright © 2017年 zkml－wxj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCollectionModel : NSObject

@property (nonatomic,copy) NSString *imageStr;
@property (nonatomic,copy) NSString *saveToLocal;//YES:保存到了本地
@property (nonatomic,copy) NSString * isShowSelectBtn;//是否显示选中按钮
@property (nonatomic,copy) NSString * isSelected;//是否被选中

@end
