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

#pragma mark - 链接
// 登录链接
#define LoginURL [NSString stringWithFormat:@"%@/connect/token", KProjectAPIBaseURL]
// 获取用户信息相关链接
#define UserInfoURL [NSString stringWithFormat:@"%@/api/ucenter-app/user", KProjectAPIBaseURL]
// 更改用户密码
#define ChangeUserPasswordURL [NSString stringWithFormat:@"%@/api/ucenter-app/account/changepassword", KProjectAPIBaseURL]
// 注册链接
#define RegisterURL [NSString stringWithFormat:@"%@/api/ucenter/account", KProjectAPIBaseURL]
// 注册验证码链接
#define SendCodeURL [NSString stringWithFormat:@"%@/api/ucenter-app/account/sendcode", KProjectAPIBaseURL]
// 重置密码链接
#define ResetPasswordURL [NSString stringWithFormat:@"%@/api/ucenter-app/account/resetpassword", KProjectAPIBaseURL]
// 获取七牛token链接
#define GetUploadTokensURL [NSString stringWithFormat:@"%@/api/ucenter/qinius/uploadtokens", KProjectAPIBaseURL]

#endif /* BaseHeader_h */
