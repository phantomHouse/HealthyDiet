//
//  DLUserInfo.h
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/10.
//  Copyright © 2017年 地利. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLUser.h"
#import "DLUserDetail.h"
#import "DLStoreListInfo.h"
#import "DLCityCode.h"
@interface DLUserInfo : NSObject

+(void)SaveUserInfoFromDic:(NSDictionary *)dic;
+(DLUser *)getUser;
+(DLUserDetail *)getUserDetail;
+(void)removeUserInfo;

+(void)SaveStoreInfo:(DLStoreListInfo *)storeinfo;
+(DLStoreListInfo*)getUserStore;
+(VersionType)GetVersionType;
+(void)SaveVersionType:(VersionType)type;
+(void)SaveLocationCity:(NSDictionary *)dic;
+(DLCityCode *)getLocationCity;
@end
