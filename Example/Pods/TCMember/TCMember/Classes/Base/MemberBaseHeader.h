//
//  MemberBaseHeader.h
//  UHomeMember
//
//  Created by Huang ZhiBing on 2019/10/16.
//  Copyright © 2019 TC. All rights reserved.
//

#ifndef MemberBaseHeader_h
#define MemberBaseHeader_h

#define TCMemberBundelName @"TCMember"
#define TCMemberInfoKey @"TCMemberInfo"
#define TCHousesInfoKey @"TCHousesInfo"
#define TCLoginStyleKey @"TCLoginStyle"
#define TCIs5000PlatformKey @"TCIs5000PlatformKey"
#define TCIntercomSchemeKey @"TCIntercomSchemeKey"
#define TCCloudServerNameKey @"TCCloudServerName"
#define TCCloudServerHostKey @"TCCloudServerHost"
#define TCCloudServerO2OHostKey @"TCCloudServerO2OHost"
#define TCCloudServerIconKey @"TCCloudServerIcon"
#define TCJuphoonServerKey @"TCJuphoonServer"
#define TCJuphoonAppKey @"TCJuphoonAppKey"

#pragma mark - 链接
// 登录链接
#define LoginURL [NSString stringWithFormat:@"%@/connect/token", KProjectAPIBaseURL]
// 获取用户信息相关链接
#define UserInfoURL [NSString stringWithFormat:@"%@/api/ucenter-mobile/user", KProjectAPIBaseURL]
#define GetHousesInfoURL [NSString stringWithFormat:@"%@/api/talkbackmobile/house/houses", KProjectAPIBaseURL]
#define GetCommunitiesInfoURL [NSString stringWithFormat:@"%@/api/talkbackmobile/house/communities", KProjectAPIBaseURL]
// 更改用户密码
#define ChangeUserPasswordURL [NSString stringWithFormat:@"%@/api/ucenter-mobile/account/changepassword", KProjectAPIBaseURL]
// 意见反馈
#define FeedbackURL [NSString stringWithFormat:@"%@/auth/api/app/feedback", KProjectAPIBaseURL]
// 注册链接
#define RegisterURL [NSString stringWithFormat:@"%@/api/ucenter-mobile/account", KProjectAPIBaseURL]
// 注册验证码链接
#define SendCodeURL [NSString stringWithFormat:@"%@/api/ucenter-mobile/account/sendcode", KProjectAPIBaseURL]
// 重置密码链接
#define ResetPasswordURL [NSString stringWithFormat:@"%@/api/ucenter-mobile/account/resetpassword", KProjectAPIBaseURL]
// 获取七牛token链接
#define GetUploadTokensURL [NSString stringWithFormat:@"%@/api/ucenter-mobile/qinius/uploadtokens", KProjectAPIBaseURL]
// 搜索社区列表链接
#define SearchCommunityURL [NSString stringWithFormat:@"%@/api/ucenter-mobile/community", KProjectAPIBaseURL]
// 设置我的默认小区链接
#define SetDefaultCommunityURL [NSString stringWithFormat:@"%@/api/ucenter-mobile/community/default", KProjectAPIBaseURL]
// 获取云服务商链接
#define GetCloudServerURL @"https://ucloud.taichuan.net/system.json"
#endif /* BaseHeader_h */
