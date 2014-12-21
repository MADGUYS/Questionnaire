//
//  RightViewController.m
//  PaperFold-ContainmentView
//
//  Created by honcheng on 10/8/12.
//  Copyright (c) 2012 honcheng. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncComplete) name:@"SyncCompleted" object:nil];

        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.tableView.bounds
                                         byRoundingCorners:(UIRectCornerBottomRight | UIRectCornerTopRight)
                                               cornerRadii:CGSizeMake(3.0, 3.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.view.bounds;
        maskLayer.path = maskPath.CGPath;
        self.tableView.layer.mask = maskLayer;
        self.tableView.backgroundColor = [UIColor clearColor];
        
        self.tableView.separatorColor = [UIColor colorWithRed:0.498 green:0.368 blue:0.368 alpha:1.000];
}
    return self;
}

-(void)syncComplete
{
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"right view will appear");
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"right view did appear");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([[CommonAppManager sharedAppManager] filtersArray].count+1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
   
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"DIN Alternate" size:16.0f];
    cell.textLabel.highlightedTextColor = [UIColor redColor];


    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"All";
    }
    
    else{
        
        PFObject *object = [[[CommonAppManager sharedAppManager] filtersArray] objectAtIndex:indexPath.row-1];

        if (object && ![[object valueForKey:FilterKey] isKindOfClass:[NSNull class]]) {
            cell.textLabel.text = [object valueForKey:FilterKey];
        }
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,40)];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    
    return headerView;
    
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  0.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.row == 0) {
        
        [[CommonAppManager sharedAppManager] setSelectedFilter:nil];

    }
    else{
     
        PFObject *object = [[[CommonAppManager sharedAppManager] filtersArray] objectAtIndex:indexPath.row-1];
        
        if (object && ![[object valueForKey:FilterKey] isKindOfClass:[NSNull class]]) {

        [[CommonAppManager sharedAppManager] setSelectedFilter:[object valueForKey:FilterKey]];

        }
    }
    
    [[CommonAppManager sharedAppManager] getNewListOfQuestions];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDefaultView" object:nil];
    
}

@end
