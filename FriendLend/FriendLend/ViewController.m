//
//  ViewController.m
//  FriendLend
//
//  Created by Pez Cuckow on 25/10/2014.
//  Copyright (c) 2014 Pez Cuckow. All rights reserved.
//

#import "ViewController.h"

@interface ESTDemoTableViewCell : UITableViewCell

@end

@implementation ESTDemoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    
    return self;
}

@end

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
    [self.tableView registerClass:[ESTDemoTableViewCell class] forCellReuseIdentifier:@"DemoCellIdentifier"];
    
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    self.navigationController.navigationBar.translucent = YES;
    
    self.menuItems = @[@[@"Add a New Lend", @"List people I owe", @"List people who owe me"]];
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
    ESTDemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoCellIdentifier" forIndexPath:indexPath];
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
                
                break;
            }
            case 1:
            {
                NSLog(@"Clicked List people I owe");
                
                break;
            }
            case 2:
            {
                NSLog(@"Clicked List people who owe me");
                
                
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