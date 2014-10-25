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

@property (nonatomic, strong) ESTBeacon         *beacon;
@property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@property (nonatomic, strong) ESTBeaconRegion   *beaconRegion;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /////////////////////////////////////////////////////////////
    // setup Estimote beacon manager
    
    // create manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.avoidUnknownStateBeacons = YES;
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:uuid];
    
    
    //self.beaconRegion.notifyOnEntry = self.enterRegionSwitch.isOn;
    //self.beaconRegion.notifyOnExit = self.exitRegionSwitch.isOn;
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didEnterRegion:
    // and beaconManager:didExitRegion: invoked
    [self.beaconManager startMonitoringForRegion:region];
    
    [self.beaconManager requestStateForRegion:region];
    
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

@end