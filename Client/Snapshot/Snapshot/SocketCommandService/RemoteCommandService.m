//
//  RemoteCommandService.m
//  SockServerComm
//
//  Created by ocean on 2018/2/3.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import "RemoteCommandService.h"
#import "CocoaAsyncSocket.h"

typedef enum : NSUInteger {
    PacketTAG_PacketSize = 0,
    PacketTAG_PacketContent,
} PacketTAG;

@interface RemoteCommandService () <GCDAsyncSocketDelegate> {
@private
    GCDAsyncSocket *_socket;
    NSString *_host;
    NSInteger _port;
    NSMutableDictionary<NSNumber *, void(^)(NSData *)> * _handlers;
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

- (void)startWithHost:(NSString *)host port:(NSInteger)port {
    _host = host;
    _port = port;
    [_socket connectToHost:_host onPort:_port error:nil];
}

- (void)registerCommand:(NSInteger)command handler:(void(^)(NSData *))handler {
    if (_handlers == nil) {
        _handlers = [NSMutableDictionary new];
    }
    _handlers[@(command)] = handler;
}

#pragma mark - Socket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [sock readDataToLength:sizeof(int) withTimeout:-1 tag:PacketTAG_PacketSize];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_socket connectToHost:_host onPort:_port error:nil];
    });
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    if (tag == PacketTAG_PacketSize) {
        int32_t packetSize = 0;
        [data getBytes:&packetSize length:sizeof(int32_t)];
        [sock readDataToLength:packetSize withTimeout:-1 tag:PacketTAG_PacketContent];
    } else if (tag == PacketTAG_PacketContent) {
        int32_t command = 0;
        NSData *payload = nil;
        [data getBytes:&command length:sizeof(int32_t)];
        payload = [data subdataWithRange:NSMakeRange(sizeof(int32_t), data.length - sizeof(int32_t))];
        NSString *payloadString = [[NSString alloc] initWithData:payload encoding:NSUTF8StringEncoding];
        NSLog(@"recv command:%d, payload: %@", command, payloadString);
        [sock readDataToLength:sizeof(int) withTimeout:-1 tag:PacketTAG_PacketSize];
        if (_handlers[@(command)] != nil) {
            _handlers[@(command)](payload);
        }
    }
}
@end

