//
//  AppDelegate.m
//  DownloadModule
//
//  Created by offcn on 15/6/18.
//  Copyright (c) 2015年 Terry. All rights reserved.
//

#import "AppDelegate.h"
#import "DownloadViewController.h"
#import "HTTPServer.h"
#import "DatabaseManager.h"
@interface AppDelegate ()
{
    HTTPServer *httpServer;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.window.backgroundColor=[UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
//[smaTabVc.btStateMonitorTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:25]];
    [[DatabaseManager shareDataManager]createDatabase];
    NSLog(@"date%@",[NSDate dateWithTimeIntervalSinceNow:25]);
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadClick:) name:@"Download" object:nil];
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"Download" object:nil];
     httpServer = [[HTTPServer alloc]init];
    [httpServer setType:@"_http._tcp."];
    NSString *webPath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] ;
    NSLog(@"%@",webPath);
    [httpServer setPort:12347];
    [httpServer setDocumentRoot:webPath];
    NSError *error;
    if (![httpServer start:&error]) {
        NSLog(@"error");
    }
    return YES;
}

-(void)downloadClick:(id)sender
{
    DownloadViewController *vc=[[DownloadViewController alloc]init];
    UINavigationController *nvc=[[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController=nvc;

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
