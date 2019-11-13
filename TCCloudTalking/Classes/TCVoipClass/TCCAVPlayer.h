//
//  UCSAVPlayer.h
//  UCS_IM_Demo
//
//  Created by Barry on 2017/4/27.
//  Copyright © 2017年 Barry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCCAVPlayer : NSObject

- (instancetype)initWithContentsOfURL:(NSURL *)url;

- (void)play;
- (void)play_ByinComingCallRing;
- (void)pause;

- (void)stop;

- (void)releasePlayResource;

@end
