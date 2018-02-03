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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[RemoteCommandService shared] start];
}

@end
