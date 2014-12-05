#import "PPAppDelegate.h"

@implementation PPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    PPRootViewController * vc = [[PPRootViewController alloc] init];
    
    UINavigationController * navMain = [[UINavigationController alloc] initWithRootViewController:vc];
    navMain.navigationBarHidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navMain;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
	return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application{}
- (void)applicationDidEnterBackground:(UIApplication *)application{}
- (void)applicationWillEnterForeground:(UIApplication *)application{}
- (void)applicationDidBecomeActive:(UIApplication *)application{}
- (void)applicationWillTerminate:(UIApplication *)application{}

@end
