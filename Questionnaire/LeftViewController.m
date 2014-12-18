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
        [self.tableView.layer  setCornerRadius:10.0f];

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
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 110;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        

    
    NSString *imageName = nil;
    
    switch (indexPath.row) {
        case 0:
            imageName = @"Sync.png";
            break;
        case 1:
            imageName = @"Biginner.png";
            break;
        case 2:
            imageName = @"Intermediate.png";
            break;
        case 3:
            imageName = @"Expert.png";
            break;
        case 4:
            imageName = @"star-on.png";
            break;
            
        default:
            break;
    }
    
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [iconImage setImage:[UIImage imageNamed:imageName]];
    [iconImage setBackgroundColor:[UIColor clearColor]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [cell.contentView addSubview:iconImage];
    iconImage.center = CGPointMake(self.view.frame.size.width/2, iconImage.center.y);
    }
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,40)];
//    [headerView setBackgroundColor:[UIColor lightGrayColor]];
//    
//    UIButton *addButton = [[UIButton alloc] init];
//        [addButton setTitle:@"Sync" forState:UIControlStateNormal];
//    addButton.backgroundColor = [UIColor clearColor];
//    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [addButton setFrame:CGRectMake(tableView.frame.size.width-90, 0, 90, 40)];
//    [addButton addTarget:self action:@selector(syncTapped) forControlEvents:UIControlEventTouchUpInside];
//    [headerView addSubview:addButton];
//    
//    return headerView;
//    
//}
//
//-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return  40.0;
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            [self syncTapped];
            break;
        case 1:{
            
            [[CommonAppManager sharedAppManager] setSelectedLevel:@"Level 1"];
            [[CommonAppManager sharedAppManager] getNewListOfQuestions];
        }
            break;
        case 2:{
            
            [[CommonAppManager sharedAppManager] setSelectedLevel:@"Level 2"];
            [[CommonAppManager sharedAppManager] getNewListOfQuestions];
        }
            break;
        case 3:{
            
            [[CommonAppManager sharedAppManager] setSelectedLevel:@"Level 3"];
            [[CommonAppManager sharedAppManager] getNewListOfQuestions];
        }
            break;
        case 4:{
            
            [[CommonAppManager sharedAppManager] setSelectedFilter:nil];
            [[CommonAppManager sharedAppManager] getFavQuestionsList];
        }
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDefaultView" object:nil];

}

-(void)syncTapped
{
    
    [[CommonAppManager sharedAppManager] sync];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDefaultView" object:nil];

}

@end
