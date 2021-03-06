//
//  DLConstants.m
//  DiLiRestaurant
//
//  Created by 地利 on 2017/3/10.
//  Copyright © 2017年 地利. All rights reserved.
//

#import "DLConstants.h"

@implementation DLConstants
/*登录*/
NSString * const LOGIN = @"/gateway/dis/prepose.action";
/*注册*/
NSString * const REGISTER = @"/gateway/dis/prepose.action";

/*获取验证码*/
NSString * const SMSCODE = @"/gateway/dis/prepose.action";
/*修改密码*/
NSString * const MODIFYPSD = @"/gateway/dis/prepose.action";
NSString * const LOGINOUT = @"/gateway/dis/prepose.action";

/*获取首页轮播图  */
NSString * const GETBANNER = @"/gateway/dis/prepose.action";
NSString * const UPDATA_USERINFOS = @"/gateway/dis/prepose.action";
NSString * const DISHEVALUATE = @"/gateway/dis/prepose.action";
/*获取自定义菜品成品分类 */
NSString * const GET_COSTOMER_FOOD_LIST = @"/gateway/dis/prepose.action";
/*获取自定义菜品搜索 */
NSString * const COSTOMER_SEARCH = @"/gateway/dis/prepose.action";
/* 上传头像 */
NSString * const UPLOAD_PHOTO = @"/gateway/dis/uploadByteArray.action";
/*获取  公共职业信息列表数据*/
NSString * const GET_WORK_TYPE = @"/gateway/dis/prepose.action";
/*获取  饮食禁忌的 食材*/
NSString * const GET_NO_EAT = @"/gateway/dis/prepose.action";
/*获取过敏食材*/
NSString * const GET_ALLERGY = @"/gateway/dis/prepose.action";
/* 首页获取门店供应列表 */
NSString * const GET_HOMELIST = @"/gateway/dis/prepose.action";
/* 自定义根据成品分类查询菜品列表 */
NSString * const CUSTOMER_FINDBY_CATEGORYID = @"/gateway/dis/prepose.action";

NSString * const APK_PATH = @"/sdcard/diliapp/apk/";

NSString * const AfterUrl = @"/tmpl/guide_after.html?";
NSString * const BeforeUrL = @"/tmpl/guide.html?";
NSString * const instructionUrL = @"/tmpl/using_help.html?";//使用说明web页面
NSString * const aboutUsUrL = @"/tmpl/about_us.html?";//关于我们web页面
NSString * const webHomeUrl = @"/tmpl/weekly_index.html";//关于我们web home页面
@end
