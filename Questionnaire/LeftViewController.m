//
//  LeftViewController.m
//  PaperFold-ContainmentView
//
//  Created by honcheng on 10/8/12.
//  Copyright (c) 2012 honcheng. All rights reserved.
//

#import "LeftViewController.h"
#import "CommonAppManager.h"
#import <Parse/Parse.h>

@interface LeftViewController ()

@end

@implementation LeftViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncComplete) name:@"SyncCompleted" object:nil];

    }
    return self;
}


-(void)syncComplete
{
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[CommonAppManager sharedAppManager] levelsArray].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PFObject *object = [[[CommonAppManager sharedAppManager] levelsArray] objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (object && ![[object valueForKey:LevelKey] isKindOfClass:[NSNull class]]) {
        
        cell.textLabel.textColor =[UIColor whiteColor];
        cell.textLabel.text = [object valueForKey:LevelKey];

    }
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor grayColor];
        
    }
    else{
        
        cell.backgroundColor = [UIColor lightGrayColor];
        
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,40)];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton *addButton = [[UIButton alloc] init];
        [addButton setTitle:@"Sync" forState:UIControlStateNormal];
    addButton.backgroundColor = [UIColor clearColor];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [addButton setFrame:CGRectMake(tableView.frame.size.width-90, 0, 90, 40)];
    [addButton addTarget:self action:@selector(syncTapped) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addButton];
    
    return headerView;
    
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  40.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [[[CommonAppManager sharedAppManager] levelsArray] objectAtIndex:indexPath.row];
   
    if (object && ![[object valueForKey:LevelKey] isKindOfClass:[NSNull class]]) {

        [[CommonAppManager sharedAppManager] setSelectedLevel:[object valueForKey:LevelKey]];
        [[CommonAppManager sharedAppManager] getNewListOfQuestions];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDefaultView" object:nil];

}

-(void)syncTapped
{
    
    [[CommonAppManager sharedAppManager] sync];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDefaultView" object:nil];

}

@end
