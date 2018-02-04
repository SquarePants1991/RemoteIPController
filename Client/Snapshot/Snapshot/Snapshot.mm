#line 1 "/Users/yangwang/Documents/Projects/OnGit/RemoteIPController/Client/Snapshot/Snapshot/Snapshot.xm"




#import <UIKit/UIKit.h>
#import "RemoteCommandService.h"

@interface SBScreenshotManager: NSObject
- (void)saveScreenshotsWithCompletion:(id)sender;
    @end
@interface SpringBoard: NSObject
+ (id)sharedApplication;
- (id)screenshotManager;
@end


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SpringBoard; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); 

#line 16 "/Users/yangwang/Documents/Projects/OnGit/RemoteIPController/Client/Snapshot/Snapshot/Snapshot.xm"



static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application)   {
　　 _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application); 
    [[RemoteCommandService shared] startWithHost:@"192.168.0.104" port:9009];

    
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


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);} }
#line 67 "/Users/yangwang/Documents/Projects/OnGit/RemoteIPController/Client/Snapshot/Snapshot/Snapshot.xm"
