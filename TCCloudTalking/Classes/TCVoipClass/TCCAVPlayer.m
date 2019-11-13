//
//  TCCAVPlayer.m
//  UCS_IM_Demo
//
//  Created by Barry on 2017/4/27.
//  Copyright © 2017年 Barry. All rights reserved.
//

#import "TCCAVPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface TCCAVPlayer ()
{
    AVAudioPlayer * audioPlayer;
}
@end

@implementation TCCAVPlayer

- (instancetype)initWithContentsOfURL:(NSURL *)url{
    if (self = [super init]) {
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        audioPlayer.numberOfLoops = -1;
    }
    return self;
}
//用此函数播放时,若后台又音乐应用在播放音乐不会停止播放,若手机开启静音设置,则来电铃声不会跟随手机静音模式.
- (void)play{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}
//用此函数播放时,若后台又音乐应用在播放音乐则会停止播放,若手机开启静音设置,则来电铃声会跟随手机静音模式.
- (void)play_ByinComingCallRing{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [session setActive:YES error:nil];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}


- (void)pause{
    [audioPlayer pause];
}

- (void)stop{
        //由于呼叫失败时UI退出速度很快导致铃声还未处于播放状态时就已经调用铃声停止播放函数,故这里延迟0.8秒执行铃声停止播放函数
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8  * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [audioPlayer stop];
    });

    
}

- (void)releasePlayResource{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:NO error:nil];
}


@end
