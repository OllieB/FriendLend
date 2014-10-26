//
//  ViewController.m
//  FriendLend
//
//  Created by Pez Cuckow on 25/10/2014.
//  Copyright (c) 2014 Pez Cuckow. All rights reserved.
//

#import "ViewController.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#include <stdlib.h>

@implementation ViewController

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.title = @"FriendLend";
    
    self.tableView.sectionHeaderHeight = 20;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:31.0/255.0 green:45.0/255.0 blue:83.0/255.0 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

    self.menuItems = @[@[@"Add a New Lend", @"List people I owe", @"List people who owe me"]];
    
    
    NSLog(@"I opened ViewDidLoad in ViewController");
    
    /*
     * Persmission to show Local Notification.
     */
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    /*
     * Ask to be a beacon
     */
    if ([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            /*
             * No need to explicitly request permission in iOS < 8, will happen automatically when starting ranging.
             */
            /*[self.beaconManager startRangingBeaconsInRegion:region];*/
            // DO SOME RANGING!!!!!!
        } else {
            /*
             * Request permission to use Location Services. (new in iOS 8)
             * We ask for "always" authorization so that the Notification Demo can benefit as well.
             * Also requires NSLocationAlwaysUsageDescription in Info.plist file.
             *
             * For more details about the new Location Services authorization model refer to:
             * https://community.estimote.com/hc/en-us/articles/203393036-Estimote-SDK-and-iOS-8-Location-Services
             */
            [self.beaconManager requestAlwaysAuthorization];
        }
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusAuthorized)
    {
        /*[self.beaconManager startRangingBeaconsInRegion:region];*/
        // DO SOME RANGING!!!!!!
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Access Denied"
                                                        message:@"You have denied access to location services. Change this in app settings."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
    }
    else if([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusRestricted)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Not Available"
                                                        message:@"You have no access to location services."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        
        [alert show];
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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.menuItems count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.menuItems objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Main Menu";
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PezCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [[self.menuItems objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *demoViewController;
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                NSLog(@"Clicked Add a New Lend");
                
               //
               
                [self performSegueWithIdentifier:@"AddNewDebtSegue" sender:self];
            /*performSegueWithIdentifier:(NSString *)identifier
            sender:(id)sender*/
                
                break;
            }
            case 1:
            {
                NSLog(@"Clicked List people I owe");
                
                [self performSegueWithIdentifier:@"ListDebtsSegue" sender:self];
                
                break;
            }
            case 2:
            {
                NSLog(@"Clicked List people who owe me");
                
                [self performSegueWithIdentifier:@"ListDebtsSegue" sender:self];
                
                
                break;
            }
            default:
                NSLog(@"Unknown option");
                break;
        }
    }
    else {
        NSLog(@"Unknown section");
    }
    
    if (demoViewController)
    {
        [self.navigationController pushViewController:demoViewController animated:YES];
    }
}

@end