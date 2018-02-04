//
//  ViewController.m
//  SockServerComm
//
//  Created by ocean on 2018/2/3.
//  Copyright © 2018年 ocean. All rights reserved.
//

#import "ViewController.h"
#import "RemoteCommandService.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *recvCommands;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[RemoteCommandService shared] startWithHost:@"127.0.0.1" port:9009];
    [[RemoteCommandService shared] registerCommand:100 handler:^(NSData *data) {
        NSString *payloadStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.recvCommands.text = [self.recvCommands.text stringByAppendingFormat:@"%@\n", payloadStr];
    }];
}

@end
