//
//  AddNewDebtController.m
//  FriendLend
//
//  Created by Pez Cuckow on 26/10/2014.
//  Copyright (c) 2014 Pez Cuckow. All rights reserved.
//

#import "AddNewDebtController.h"
#import "ESTBeaconManager.h"
#import "ListDebtsController.h"

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@interface AddNewDebtController () <ESTBeaconManagerDelegate>

@property (nonatomic, strong) ESTBeaconRegion *region;
@property (nonatomic, strong) NSArray *beaconsArray;

@property (strong) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *priceField;

@property (nonatomic, strong) NSString* personName;

@end

@interface ESTTableViewCell : UITableViewCell

@end
@implementation ESTTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}
@end

@implementation AddNewDebtController
/*{
    NSArray *tableData;
}*/

- (IBAction)saveButton:(id)sender {
    
    //ReturnDebtsFromAddSegue
    [self performSegueWithIdentifier:@"ReturnDebtsFromAddSegue" sender:self];
}

// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ReturnDebtsFromAddSegue"]) {
        
        // Get destination view

        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        
        ListDebtsController *destination = segue.destinationViewController;
        
        NSLog([[NSString alloc] initWithFormat:@"Price: %@ IndexPath: %li", self.priceField.text, selectedIndexPath.row]);
        
        // Pass the information to your destination view
        [destination setSelectedPersonName:self.personName];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        
        float value = [numberFormatter numberFromString:self.priceField.text].floatValue;
        
        NSLog([[NSString alloc] initWithFormat:@"Price as a float is %1.2f", value]);
        
        [destination setSelectedPrice:value];
        
        
        
        //ESTBeacon *selectedBeacon = [self.beaconsArray objectAtIndex:selectedRow];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setAllowsSelection:YES];
    
    /////////////////////////////////////////////////////////////
    // setup Estimote beacon manager
    
    // create manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    self.beaconManager.preventUnknownUpdateCount = YES;
    
    //NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:ESTIMOTE_IOSBEACON_PROXIMITY_UUID
                                                                       major:1337
                                                                  identifier:@"RegionIdentifier"];
    region.notifyEntryStateOnDisplay = YES;
    
    /*
     * Ask to be a beacon
     */
    if ([ESTBeaconManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            /*
             * No need to explicitly request permission in iOS < 8, will happen automatically when starting ranging.
             */
            [self.beaconManager startRangingBeaconsInRegion:region];
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
        [self.beaconManager startRangingBeaconsInRegion:region];
        NSLog(@"Allready authed iOS8");
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
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didEnterRegion:
    // and beaconManager:didExitRegion: invoked
    [self.beaconManager startMonitoringForRegion:region];
    [self.beaconManager requestStateForRegion:region];
}

/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}*/

#pragma mark - ESTBeaconManager delegate

- (void)beaconManager:(ESTBeaconManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = beacons;

    for (ESTBeacon *beacon in beacons) {
         NSLog(@"In the search thing beacon: %@", beacon.proximityUUID);
         NSLog(@"%@ - %@", beacon.major, beacon.minor);
    }
    
    [self.tableView reloadData];
}

- (void)beaconManager:(ESTBeaconManager *)manager didDiscoverBeacons:(NSArray *)beacons inRegion:(ESTBeaconRegion *)region
{
    self.beaconsArray = beacons;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.beaconsArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PezCell";
    
    ESTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    //ESTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    /*
     * Fill the table with beacon data.
     */
    ESTBeacon *beacon = [self.beaconsArray objectAtIndex:indexPath.row];
    
    NSInteger minor = [beacon.minor intValue];
    NSString *name;
    NSString *imageName;
    if(minor == 30) {
        name = @"Pez Cuckow";
        imageName = @"Pez";
    } else if(minor == 40) {
        name = @"Ollie Brown";
        imageName = @"Ollie";
    } else {
        name = @"Unknown Friend";
        imageName = @"beacon";
    }
    
    //cell.textLabel.text = [NSString stringWithFormat:@"Major: %@, Minor: %@", beacon.major, beacon.minor];
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Distance: %.2f", [beacon.distance floatValue]];
    cell.imageView.image = [UIImage imageNamed:imageName];

    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ESTBeacon *selectedBeacon = [self.beaconsArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.personName = cell.textLabel.text;
    
    NSLog([[NSString alloc] initWithFormat:@"Person name is now: %@", self.personName]);
}


- (IBAction)SaveButton:(id)sender {
}
@end
