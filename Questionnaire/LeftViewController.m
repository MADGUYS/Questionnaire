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
        
        UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(150, 0, 5, self.view.frame.size.height)];
        [backView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:backView];
        
        CALayer *layer = backView.layer;
        layer.shadowOffset = CGSizeMake(-1, -1);
        layer.shadowColor = [[UIColor blackColor] CGColor];
        layer.shadowRadius = 7.0f;
        layer.shadowOpacity = 1.0f;
        layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncComplete) name:@"SyncCompleted" object:nil];
        
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.tableView.bounds
                                         byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerTopLeft)
                                               cornerRadii:CGSizeMake(3.0, 3.0)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.view.bounds;
        maskLayer.path = maskPath.CGPath;
        self.tableView.layer.mask = maskLayer;
        
        self.tableView.separatorColor = [UIColor colorWithRed:0.165 green:0.122 blue:0.122 alpha:1.000];

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
