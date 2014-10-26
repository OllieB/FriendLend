//
//  ListViewController.m
//  FriendLend
//
//  Created by Pez Cuckow on 26/10/2014.
//  Copyright (c) 2014 Pez Cuckow. All rights reserved.
//

#import "ListDebtsController.h"

@interface ListDebtsController()
    -(void) setSelectedPersonName:(NSString*)_personName;
    -(void) setSelectedPrice:(float)_selectedPrice;
@end

@implementation ListDebtsController

@synthesize listItems;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSLog([[NSString alloc] initWithFormat:@"%s owes you %1.2f", self.selectedPersonName, self.selectedPrice]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? (self.selectedPersonName ? 2 : 0) : 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"People Who Owe You:";
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"PezCell";
    
    NSString* name;
    float moneyOwed;
    NSString *imageName;
    
    if(indexPath.row == 0 && self.selectedPersonName) {
        name = self.selectedPersonName;
        moneyOwed = self.selectedPrice;
        imageName = ([imageName isEqualToString:@"Pez Cuckow"]) ? @"Pez" : @"Ollie";
        
    } else {
        name = @"Patrick the Panda";
        moneyOwed = 18.99;
        imageName = @"Panda";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Owes you: %.2f", moneyOwed];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - Table view delegate


@end
