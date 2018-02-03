#line 1 "/Users/ocean/Documents/Projects/GitHub/RemoteiPhoneController/Client/Snapshot/Snapshot/Snapshot.xm"




#import <UIKit/UIKit.h>
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
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SpringBoard(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SpringBoard"); } return _klass; }
#line 14 "/Users/ocean/Documents/Projects/GitHub/RemoteiPhoneController/Client/Snapshot/Snapshot/Snapshot.xm"



static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id application)   {
　　_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, application); 

    SBScreenshotManager *manager = [[_logos_static_class_lookup$SpringBoard() sharedApplication] screenshotManager];
    [manager saveScreenshotsWithCompletion:^(id sth) {
        UIImage *img = nil;
        for (NSString *key in sth) {
            img = sth[key];
        }
        
        　　UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:[NSString stringWithFormat:@"%@", img] delegate:self cancelButtonTitle:@"Thanks" otherButtonTitles:nil];
        　　[alert show];
        　　[alert release];
        
        NSData *imageData = UIImagePNGRepresentation(img);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.74.90:8070"]];
        request.HTTPMethod = @"POST";
        [[[NSURLSession sharedSession] uploadTaskWithRequest:request fromData:imageData] resume];
    }];

}


static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);} }
#line 40 "/Users/ocean/Documents/Projects/GitHub/RemoteiPhoneController/Client/Snapshot/Snapshot/Snapshot.xm"
