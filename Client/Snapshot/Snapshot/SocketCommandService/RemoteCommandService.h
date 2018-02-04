//
//  RemoteCommandService.h
//  SockServerComm
//
//  Created by ocean on 2018/2/3.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteCommandService : NSObject
+ (RemoteCommandService *)shared;
- (void)startWithHost:(NSString *)host port:(NSInteger)port;
- (void)registerCommand:(NSInteger)command handler:(void(^)(NSData *))handler;
@end
