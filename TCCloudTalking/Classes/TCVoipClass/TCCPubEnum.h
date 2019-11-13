//
//  UCSPubEnum.h
//  UCSVoipDemo
//
//  Created by tongkucky on 14-5-28.
//  Copyright (c) 2014年 UCS. All rights reserved.
//

typedef enum
{
    UCSCallStatus_NO=0,               //没有呼叫
    UCSCallStatus_Calling,            //呼叫中
    UCSCallStatus_Proceeding,         //服务器有回应
    UCSCallStatus_Alerting,           //对方振铃
    UCSCallStatus_Answered,           //对方应答
    UCSCallStatus_Pasused,            //保持成功
    UCSCallStatus_Released,           //通话释放
    UCSCallStatus_Failed,             //呼叫失败
    UCSCallStatus_Incoming,           //来电
    UCSCallStatus_Transfered,         //
    UCSCallStatus_CallBack,           //
    UCSCallStatus_CallBackFailed,      //
    UCSCallStatus_RecDTMFvalue,      //接收到DTMF
    
    UCSCallStatus_Conference_StateNotify,  //电话会议
    UCSCallStatus_Conference_PassiveModeConvert,
    UCSCallStatus_Conference_ActiveModeConvert
}UCSCallStatus;



typedef enum
{
    UCSMsgStatus_Received,        //接受消息
    UCSMsgStatus_Send,            //发送消息成功
    UCSMsgStatus_Sending,         //发送消息中
    UCSMsgStatus_SendFailed       //发送消息失败
}UCSMsgStatusResult;


typedef enum{
    UMsgeState_Sending = 0,
    UMsgeState_SendSuccess,
    UMsgeState_SendFailed,
    UMsgeState_Send_OtherReceived,
    UMsgeState_Received
}UCSMsgState;

typedef enum{
    UCSMsg_Unread = 0,
    UCSMsg_IsRead
} UCSMsgReadState;