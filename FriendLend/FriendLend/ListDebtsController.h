//
//  ListViewController.h
//  FriendLend
//
//  Created by Pez Cuckow on 26/10/2014.
//  Copyright (c) 2014 Pez Cuckow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListDebtsController : UITableViewController
    @property (strong, nonatomic)  NSArray *listItems;
    @property (strong, nonatomic)  NSString *selectedPersonName;
    @property (strong, nonatomic)  float *selectedPrice;

    -(void) setSelectedPersonName:(NSString*)_personName;
@end
