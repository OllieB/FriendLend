//
//  ViewController.h
//  FriendLend
//
//  Created by Pez Cuckow on 25/10/2014.
//  Copyright (c) 2014 Pez Cuckow. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ESTBeaconManager.h"

@interface ViewController : UITableViewController
    @property (strong, nonatomic)  NSArray *menuItems;
    @property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@end
