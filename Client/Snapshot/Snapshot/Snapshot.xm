///  rsync ./Snapshot.dylib root@192.168.74.57:/Library/MobileSubstrate/DynamicLibraries

/// killall -HUP SpringBoard

#import <UIKit/UIKit.h>
#import "RemoteCommandService.h"

@interface SBScreenshotManager: NSObject
- (void)saveScreenshotsWithCompletion:(id)sender;
    @end
@interface SpringBoard: NSObject
+ (id)sharedApplication;
- (id)screenshotManager;
@end

%hook SpringBoard

-(void)applicationDidFinishLaunching: (id)application  //需要hook的消息名
{
　　 %orig; //执行原方法
    [[RemoteCommandService shared] startWithHost:@"192.168.0.104" port:9009];

    // snapshot
    [[RemoteCommandService shared] registerCommand:1000 handler:^(NSData *) {
        SBScreenshotManager *manager = [[objc_getClass("SpringBoard") sharedApplication] screenshotManager];
        [manager saveScreenshotsWithCompletion:^(id sth) {
            UIImage *img = nil;
            for (NSString *key in sth) {
                img = sth[key];
            }
            
            NSData *imageData = UIImagePNGRepresentation(img);
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.0.104:8070"]];
            request.HTTPMethod = @"POST";
            [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:imageData] resume];
        }];
    }];

    // touch
    [[RemoteCommandService shared] registerCommand:1001 handler:^(NSData *data) {
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (json) {
            CGPoint loc;
            loc.x = [json[@"x"] floatValue];
            loc.y = [json[@"y"] floatValue];
            char buffer[255];
            sprintf(buffer, "stouch touch %.0f %.0f", loc.x, loc.y);
            system(buffer);
        }
    }];

    [[RemoteCommandService shared] registerCommand:1002 handler:^(NSData *data) {
        [[objc_getClass("SBBacklightController") sharedInstance] turnOnScreenFullyWithBacklightSource:0];
        [[objc_getClass("SBLockScreenManager") sharedInstance] unlockUIFromSource:0 withOptions:nil];
    }];

   [[RemoteCommandService shared] registerCommand:1003 handler:^(NSData *data) {
        NSString *cmd = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (cmd) {
            system([cmd UTF8String]);
        }
    }];

}

%end
