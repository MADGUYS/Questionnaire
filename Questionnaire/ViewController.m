//
//  ViewController.m
//  Questionnaire
//
//  Created by Srinivas Varada on 15/12/14.
//  Copyright (c) 2014 Srinivas Varada. All rights reserved.
//

#import "ViewController.h"
#import "CommonAppManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncComplete) name:@"SyncCompleted" object:nil];

    
    [self performSelector:@selector(filterOrLevelChanged) withObject:nil afterDelay:7.0];

}

-(void)syncComplete
{
    
    NSLog(@"%s",__func__);
    
    
    NSLog(@"Levels Array : %@",[[CommonAppManager sharedAppManager] levelsArray]);
    NSLog(@"Filters Array : %@",[[CommonAppManager sharedAppManager] filtersArray]);
    NSLog(@"Questions Array : %@",[[CommonAppManager sharedAppManager] questionsArray]);

}

-(void)filterOrLevelChanged
{
    [[CommonAppManager sharedAppManager] setSelectedFilter:@"CGContext"];
    [[CommonAppManager sharedAppManager] setSelectedLevel:@"Level 1"];
    [[CommonAppManager sharedAppManager] getNewListOfQuestions];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
   

}

- (IBAction)syncButtontTapped:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ISSyncSuccess"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[CommonAppManager sharedAppManager] sync];
    
    
}
@end
