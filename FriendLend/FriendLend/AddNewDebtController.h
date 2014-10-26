//
//  AddNewDebtController.h
//  FriendLend
//
//  Created by Pez Cuckow on 26/10/2014.
//  Copyright (c) 2014 Pez Cuckow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESTBeaconManager.h"

@interface AddNewDebtController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
    @property (nonatomic, strong) ESTBeaconManager  *beaconManager;
@end
