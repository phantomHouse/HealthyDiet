//
//  DLChioceStoreListViewController.h
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/13.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLBaseViewController.h"
@interface DLChioceStoreListViewController : DLBaseViewController

@property(assign,nonatomic)ChioceType type;

@property(copy,nonatomic)void(^selectStore)(DLStoreListInfo *storeInfo);
@end
