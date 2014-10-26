//
//  AppDelegate.m
//  FriendLend
//
//  Created by Pez Cuckow on 25/10/2014.
//  Copyright (c) 2014 Pez Cuckow. All rights reserved.
//

#import "AppDelegate.h"

#import "ESTBeaconManager.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#include <stdlib.h>

@interface AppDelegate ()
    @property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"I will launch");
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"I Launched");
    
    /*
     * Persmission to show Local Notification.
     */
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    // Do any additional setup after loading the view from its nib.
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    NSLog(@"iPhone Device %@",platform);
    
    int minorID;
    if ([platform isEqualToString:@"x86_64"]) {
        minorID = 50;
    }
    else if ([platform isEqualToString:@"iPhone7,2"]) {
        minorID = 40;
    }
    else if ([platform isEqualToString:@"iPhone6,2"]) {
        minorID = 30;
    } else {
        minorID = arc4random_uniform(74);
    }
    
    int majorID = 1337;
    [self.beaconManager startAdvertisingWithProximityUUID:ESTIMOTE_IOSBEACON_PROXIMITY_UUID
                                                    major:majorID
                                                    minor:minorID
                                               identifier:@"RegionIdentifier"];
    
    NSLog(@"major %i minor %i", majorID,minorID);
    
    // Override point for customization after application launch.
    return YES;
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
