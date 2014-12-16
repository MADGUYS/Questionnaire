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
    if (object) {
        
        cell.textLabel.text = [object valueForKey:LevelKey];

    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [[[CommonAppManager sharedAppManager] filtersArray] objectAtIndex:indexPath.row];
    
    [[CommonAppManager sharedAppManager] setSelectedLevel:[object valueForKey:LevelKey]];
    
    [[CommonAppManager sharedAppManager] getNewListOfQuestions];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDefaultView" object:nil];
}

@end
