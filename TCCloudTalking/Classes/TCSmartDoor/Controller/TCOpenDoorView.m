//
//  TCOpenDoorView.m
//  AFNetworking
//
//  Created by Huang ZhiBin on 2019/11/16.
//

#import "TCOpenDoorView.h"
#import "Header.h"
#import "POP.h"
#import "TCDoorMachineModel.h"
#import "TYLVerticalButton.h"
#import "TCCloudTalkingTool.h"
#import "TCOpenDoorTool.h"
#import "MemberBaseHeader.h"

static CGFloat const TCAnimationDelay = 0.1;
static CGFloat const TCSpringFactor = 10;

@interface TCOpenDoorView()
//传递过来的类型
@property (nonatomic,assign) NSUInteger typeNum;
@property (nonatomic,strong) UIScrollView *doorScrolView;

//所有的门口机
@property (nonatomic,strong) NSMutableArray *AllMachines;
@end

@implementation TCOpenDoorView

- (NSMutableArray *)AllMachines
{
    if (!_AllMachines) {
        _AllMachines = [NSMutableArray array];
    }
    return _AllMachines;
}


static UIWindow *window_;
+ (void)show :(openDoor_Type )type
{
    // 创建窗口
    window_ = [[UIWindow alloc] init];
    window_.frame = [UIScreen mainScreen].bounds;
    window_.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    window_.hidden = NO;
    
    
    // 添加发布界面
    TCOpenDoorView *publishView = [[TCOpenDoorView alloc] init];
    publishView.typeNum = type;
    publishView.frame = window_.bounds;
    [window_ addSubview:publishView];
    [publishView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.left.equalTo(window_.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(window_.mas_safeAreaLayoutGuideRight);
            make.top.equalTo(window_.mas_safeAreaLayoutGuideTop);
            make.bottom.equalTo(window_.mas_safeAreaLayoutGuideBottom);
        } else {
            make.leading.trailing.top.bottom.equalTo(window_);
        }
    }];
    
    UIButton *canceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [canceBtn addTarget:publishView action:@selector(canceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [canceBtn setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_取消"] forState:UIControlStateNormal];
    [publishView addSubview:canceBtn];
    [canceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(publishView);
        make.width.height.equalTo(@94);
        make.bottom.equalTo(publishView).offset(15) ;
        
    }];
    
    UIScrollView *doorScrolView = [[UIScrollView alloc] init];
    publishView.doorScrolView = doorScrolView;
    doorScrolView.backgroundColor = [UIColor clearColor];
    [publishView addSubview:doorScrolView];
    [doorScrolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publishView);
        make.left.right.equalTo(publishView);
        make.bottom.equalTo(canceBtn.mas_top);
        
    }];
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"initWithFrame");
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canceBtnClick) name:UCSNotiClsoeView object:nil];
        //获取门口机列表
        [self getMyDoorMachineDate];
    }
    return self;
}



- (void)getMyDoorMachineDate
{
    [MBManager showLoading];
    TCUserModel *userModel = [[TCPersonalInfoModel shareInstance] getUserModel];
    [TCCloudTalkRequestTool GetMyDoorMachinelistWithCoid:userModel.defaultCommunity.communityId Success:^(id  _Nonnull result) {
        [MBManager hideAlert];
        debugLog(@"%@-----门口机列表",result);
        if ([result[@"code"] intValue] == 0) {
            [self.AllMachines removeAllObjects];
            
            self.AllMachines = [TCDoorMachineModel mj_objectArrayWithKeyValuesArray:result[@"data"]];
            
            if (self.AllMachines.count>0) {
                [self setUpButton];
                //更新门口机列表
                [TCCloudTalkingTool saveUserMachineList:result];
            }else
            {
                [MBManager showBriefAlert:@"没有可用门口机"];
                 [self canceBtnClick];
            }
            
            
        }else
        {
            if (result[@"message"]) {
                [MBManager showBriefAlert:result[@"message"]];

            }
            
        }
    } faile:^(NSError * _Nonnull error) {
        debugLog(@"门口机列表加载失败----%@",error);
        [MBManager showBriefAlert:@"请求失败"];
    }];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
}


#pragma mark --门口机按钮
- (void)setUpButton{
    
    NSInteger rows = (self.AllMachines.count - 1) / 3 + 1;
    self.doorScrolView.contentSize = CGSizeMake(kMainScreenWidth, rows*150);
    if (self.AllMachines.count <= 3) {
        CGFloat buttonStartY = kMainScreenHeight * 0.45 + 102;
        [self setUpButoonWithH:buttonStartY];
    }else if (self.AllMachines.count >=3 && self.AllMachines.count <= 6)
    {
        CGFloat buttonStartY = kMainScreenHeight * 0.28 + 102;
        [self setUpButoonWithH:buttonStartY];
    }else
    {
        CGFloat buttonStartY = kMainScreenHeight * 0.05 + 102;
        [self setUpButoonWithH:buttonStartY];
        
    }
    
}

- (void)setUpButoonWithH:(CGFloat )buttonStart{
    
    
    // 中间的3个按钮
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 40;
    CGFloat buttonStartY = buttonStart;
    CGFloat buttonStartX = 20;
    CGFloat xMargin = (kMainScreenWidth - 2 * buttonStartX - maxCols * buttonW) / (maxCols - 1);
    
    
    
    for (int i = 0; i<self.AllMachines.count; i++) {
        
        TYLVerticalButton *button = [[TYLVerticalButton alloc] init];
        button.tag = i;
        TCDoorMachineModel *DoorItem = self.AllMachines[i];
        
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.doorScrolView addSubview:button];
        // 设置内容
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        //自动折行设置
        button.titleLabel.numberOfLines = 0;
        [button.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        
        [button setTitle:DoorItem.name forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (DoorItem.isOnline) {
            [button setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_门口机_pre"] forState:UIControlStateNormal];
        } else {
            [button setImage:[TCCloudTalkingImageTool getToolsBundleImage:@"TCCT_门口机_nor"] forState:UIControlStateNormal];
        }
        // 计算X\Y
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY + row * buttonH;
        CGFloat buttonBeginY = buttonEndY - kMainScreenHeight;
        
        // 按钮动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = TCSpringFactor;
        anim.springSpeed = TCSpringFactor;
        anim.beginTime = CACurrentMediaTime() + TCAnimationDelay * i;
        [button pop_addAnimation:anim forKey:nil];
        
        if (self.AllMachines == nil) {
            self.userInteractionEnabled = YES;
        }
        
        
        [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            // 标语动画执行完毕, 恢复点击事件
            self.userInteractionEnabled = YES;
        }];
    }
    
}

- (void)buttonClick:(UIButton *)button
{
    [self cancelWithCompletionBlock:^{

        TCDoorMachineModel *DoorItem = self.AllMachines[button.tag];

        ///0：云之讯方案；     1：菊风方案
        BOOL intercomScheme = [[NSUserDefaults standardUserDefaults] boolForKey:TCIntercomSchemeKey];
        if (self.typeNum == 0) {//对讲

            if (!intercomScheme) {
                if ([[UCSTcpClient sharedTcpClientManager] login_isConnected]) {
                    //主动呼叫
                    [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:DoorItem.intercomUserId callType:UCSCallType_VideoPhone callName:DoorItem.name];

                }else
                {
                    [MBManager showWaitingWithTitle:@"对讲服务正在连接中,请稍后!"];
                    TCHousesInfoModel *houesModel = [[TCPersonalInfoModel shareInstance] getHousesInfoModel];
                    [[UCSTcpClient sharedTcpClientManager] login_connect:houesModel.intercomToken  success:^(NSString *userId) {
                        [MBManager hideAlert];
                        //主动呼叫
                        [[UCSVOIPViewEngine getInstance] makingCallViewCallNumber:DoorItem.intercomUserId callType:UCSCallType_VideoPhone callName:DoorItem.name];
                    } failure:^(UCSError *error) {
                        [MBManager hideAlert];
                        [MBManager showBriefAlert:@"对讲服务器连接失败!"];
                    }];
                }

            }else{
                NSLog(@"%@", DoorItem.intercomUserId);
               bool value = [JCManager.shared.call call:DoorItem.intercomUserId video:true callParam:nil];
                if (value) {
                    NSLog(@"okokokok");
                }
            }
        }else{//开锁
            [self OpenTheDoorWithID:DoorItem.num DoorName:DoorItem.name TalkID:DoorItem.intercomUserId] ;
        }

    }];
}

#pragma mark --点击取消按钮
- (void)canceBtnClick
{
    [self cancelWithCompletionBlock:nil];
}

/**
 * 先执行退出动画, 动画完毕后执行completionBlock
 */
- (void)cancelWithCompletionBlock:(void (^)(void))completionBlock
{
    
    if (self.subviews.count > 1) {
        // 不能被点击
        self.userInteractionEnabled = NO;
        
        int beginIndex = 1;
        NSUInteger count = self.subviews.count;
        for (int i = beginIndex; i<self.subviews.count; i++) {
            UIView *subview = self.subviews[i];
            
            // 基本动画
            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            CGFloat centerY = subview.centerY + kMainScreenHeight;
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
            anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * TCAnimationDelay;
            [subview pop_addAnimation:anim forKey:nil];
            
            // 监听最后一个动画  add tyl 2017.4.20
            if (beginIndex == (count - 1 + beginIndex - i)) {
                [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                    //                JYJKeyWindow.rootViewController.view.userInteractionEnabled = YES;
                    // iOS9中一定要hidden
                    window_.hidden = YES;
                    // 销毁窗口
                    window_ = nil;
                    
                    // 执行传进来的completionBlock参数
                    !completionBlock ? : completionBlock();
                }];
            }
            // 监听最后一个动画
            //            if (i == self.subviews.count - 1) {
            //
            //                [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            //                    // 销毁窗口
            //                    window_ = nil;
            //
            //                    // 执行传进来的completionBlock参数
            //                    !completionBlock ? : completionBlock();
            //                }];
            //            }
        }
    }
    else
    {
        // 不能被点击
        self.userInteractionEnabled = NO;
        
        int beginIndex = 0;
        NSUInteger count = self.subviews.count;
        for (int i = beginIndex; i<self.subviews.count; i++) {
            UIView *subview = self.subviews[i];
            
            // 基本动画
            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
            CGFloat centerY = subview.centerY + kMainScreenHeight;
            anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
            anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * TCAnimationDelay;
            [subview pop_addAnimation:anim forKey:nil];
            
            // 监听最后一个动画  add tyl 2017.4.20
            if (beginIndex == (count - 1 + beginIndex - i)) {
                [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                    //                JYJKeyWindow.rootViewController.view.userInteractionEnabled = YES;
                    // iOS9中一定要hidden
                    window_.hidden = YES;
                    // 销毁窗口
                    window_ = nil;
                    
                    // 执行传进来的completionBlock参数
                    !completionBlock ? : completionBlock();
                }];
            }
            // 监听最后一个动画
            //            if (i == self.subviews.count - 1) {
            //                [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
            //                    // 销毁窗口
            //                    window_ = nil;
            //
            //                    // 执行传进来的completionBlock参数
            //                    !completionBlock ? : completionBlock();
            //                }];
            //            }
        }
        
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    
    [self cancelWithCompletionBlock:nil];
    
}

- (void)OpenTheDoorWithID:(NSString *)ID DoorName:(NSString *)DoorName TalkID:(NSString *)TalkID
{
    [TCOpenDoorTool openTheDoorWithID:ID DoorName:DoorName TalkID:TalkID];
}
@end
