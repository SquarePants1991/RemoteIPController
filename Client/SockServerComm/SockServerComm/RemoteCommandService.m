//
//  RemoteCommandService.m
//  SockServerComm
//
//  Created by ocean on 2018/2/3.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import "RemoteCommandService.h"
#import "CocoaAsyncSocket.h"

@interface RemoteCommandService () <GCDAsyncSocketDelegate> {
    @private
    GCDAsyncSocket *_socket;
}
@end

@implementation RemoteCommandService
+ (RemoteCommandService *)shared {
    static RemoteCommandService *_shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [RemoteCommandService new];
    });
    return _shared;
}
    
    - (instancetype)init
    {
        self = [super init];
        if (self) {
            _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        }
        return self;
    }
    
- (void)start {
    [_socket connectToHost:@"127.0.0.1" onPort:9003 error:nil];
}

#pragma mark - Socket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [sock writeData:[@"Gollow" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {

}
@end
