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
        
        UIView *backView =[[UIView alloc] initWithFrame:CGRectMake(100, 0, 5, self.view.frame.size.height)];
        [backView setBackgroundColor:[UIColor whiteColor]];
        [self.view addSubview:backView];
        
        CALayer *layer = backView.layer;
        layer.shadowOffset = CGSizeMake(-1, -1);
        layer.shadowColor = [[UIColor colorWithRed:0.165 green:0.122 blue:0.122 alpha:1.000] CGColor];
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
        
        self.tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        

    
    NSString *imageName = nil;
    NSString *labelName = nil;
    
    switch (indexPath.row) {
        case 0:
            imageName = @"Sync.png";
            labelName = @"Sync";
            break;
        case 1:
            imageName = @"All2.png";
            labelName = @"All";
            break;
        case 2:
            imageName = @"Beginner3.png";
            labelName = @"Beginner";
            break;
        case 3:
            imageName = @"Intermediate4.png";
            labelName = @"Intermediate";
            break;
        case 4:
            imageName = @"Expert5.png";
            labelName = @"Expert";
            break;
        case 5:
            imageName = @"Favourite6.png";
            labelName = @"Favourite";
            break;
            
        default:
            break;
    }
    
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 50, 50)];
    [iconImage setImage:[UIImage imageNamed:imageName]];
    [iconImage setBackgroundColor:[UIColor clearColor]];
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.contentView addSubview:iconImage];
    iconImage.center = CGPointMake(self.view.frame.size.width/2, iconImage.center.y);
        
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, iconImage.frame.size.height + 20, self.tableView.frame.size.width - 20, 20)];
    nameLabel.font = [UIFont fontWithName:@"DIN Alternate" size:14.0f];
    nameLabel.text = labelName;
        nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor darkGrayColor];
    [cell.contentView addSubview:nameLabel];

    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 3)];/// change size as you need.
    separatorLineView.backgroundColor = [UIColor colorWithRed:0.165 green:0.122 blue:0.122 alpha:1.000];// you can also put image here
    [cell.contentView addSubview:separatorLineView];

        nameLabel.highlightedTextColor = [UIColor redColor];
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
            
            [[CommonAppManager sharedAppManager] setSelectedLevel:nil];
            [[CommonAppManager sharedAppManager] getNewListOfQuestions];
        }
            break;
        case 2:{
            
            [[CommonAppManager sharedAppManager] setSelectedLevel:@"Level 1"];
            [[CommonAppManager sharedAppManager] getNewListOfQuestions];
        }
            break;
        case 3:{
            
            [[CommonAppManager sharedAppManager] setSelectedLevel:@"Level 2"];
            [[CommonAppManager sharedAppManager] getNewListOfQuestions];
        }
            break;
        case 4:{
            
            [[CommonAppManager sharedAppManager] setSelectedLevel:@"Level 3"];
            [[CommonAppManager sharedAppManager] getNewListOfQuestions];
        }
            break;
        case 5:{
            
            [[CommonAppManager sharedAppManager] setSelectedFilter:nil];
            [[CommonAppManager sharedAppManager] getFavQuestionsList];
        }
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDefaultView" object:nil];

}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)syncTapped
{
    
    [[CommonAppManager sharedAppManager] sync];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDefaultView" object:nil];

}

@end
