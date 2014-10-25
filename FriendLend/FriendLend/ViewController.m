//
//  ViewController.m
//  FriendLend
//
//  Created by Pez Cuckow on 25/10/2014.
//  Copyright (c) 2014 Pez Cuckow. All rights reserved.
//

#import "ViewController.h"

#import "ESTBeaconManager.h"

@interface ViewController ()

//@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
//@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    /*
     * Persmission to show Local Notification.
     */
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    /////////////////////////////////////////////////////////////
    // setup Estimote beacon manager
    
    // create manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid
                               identifier:@"com.nsscreencast.beaconfun.region"];
    
    region.notifyOnEntry = true;
    region.notifyOnExit = true;
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didEnterRegion:
    // and beaconManager:didExitRegion: invoked
    [self.beaconManager startMonitoringForRegion:region];
    [self.beaconManager requestStateForRegion:region];
    
    NSLog(@"Looking for beacon!");
    
    /////////////////////////////////////////////////////////////
    // setup view
    
    // background
    
    /*self.productImage = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setProductImage];
    [self.view addSubview:self.productImage];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager didEnterRegion:(ESTBeaconRegion *)region
{
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Enter region notification";
    
    NSLog(@"Enter region");
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(ESTBeaconManager *)manager didExitRegion:(ESTBeaconRegion *)region
{
    UILocalNotification *notification = [UILocalNotification new];
    notification.alertBody = @"Exit region notification";
    
    NSLog(@"Leave region");
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)beaconManager:(ESTBeaconManager *)manager didDetermineState:(CLRegionState)state forRegion:(ESTBeaconRegion *)region {
    if (state == CLRegionStateInside) {
        ESTBeaconRegion *beaconRegion = (ESTBeaconRegion *)region;
        [self.beaconManager startRangingBeaconsInRegion:beaconRegion];
    }
    
    NSLog(@"didDetermineState");
}

#pragma mark -

@end
