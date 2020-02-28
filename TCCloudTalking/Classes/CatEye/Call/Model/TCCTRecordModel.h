//
//  TCCTRecordModel.h
//  TCCloudTalking
//
//  Created by Huang ZhiBing on 2020/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TCCTCatEyeFileListModel;
@interface TCCTRecordModel : NSObject

@property (nonatomic,copy)NSString *account;        //通话人、人员信息
@property (nonatomic,copy)NSString *age;            //年龄
@property (nonatomic,copy)NSString *alertType;      //报警类型
@property (nonatomic,copy)NSString *callType;       //呼叫类型：0-呼入、1-呼出
@property (nonatomic,strong)NSArray<TCCTCatEyeFileListModel> *catEyeFileList;     //文件列表
@property (nonatomic,copy)NSString *deviceNum;      //机身号
@property (nonatomic,copy)NSString *end;
@property (nonatomic,copy)NSString *faceId;         //人脸ID
@property (nonatomic,copy)NSString *handle;         //是否处理：0-否、1-是（是否接听/是否感应有人）
@property (nonatomic,copy)NSString *id;             //记录ID
@property (nonatomic,copy)NSString *recordDate;     //记录日期 例如：1557413484000
@property (nonatomic,copy)NSString *recordLen;      //记录时长
@property (nonatomic,copy)NSString *roomId;         //房间 ID
@property (nonatomic,copy)NSString *sex;            //性别：0-女、1-男
@property (nonatomic,copy)NSString *start;
@property (nonatomic,copy)NSString *type;           //信息记录：0-文件记录、1-通话记录、2-报警记录、3-人脸识别记录

@end


@interface TCCTCatEyeFileListModel : NSObject

@property (nonatomic,copy)NSString *type;           //文件类型:0-图片、1-视频
@property (nonatomic,copy)NSString *url;            //视频或图片地址

@end

NS_ASSUME_NONNULL_END
