//
//  ERGameManager.m
//  GoodieLetters
//
//  Created by Coding Cursors on 05/05/11.
//  Copyright 2011 What IS? Properties LLC. All rights reserved.
//

#import "CommonAppManager.h"
#import "DBManager.h"

@implementation CommonAppManager
@synthesize questionsArray,filtersArray,levelsArray,selectedLevel,selectedFilter;
static CommonAppManager *_sharedAppManager;

#pragma mark -
#pragma mark init and dealloc Methods
#pragma mark -

+(id)sharedAppManager
{
	if(_sharedAppManager == nil)
	{
        
		_sharedAppManager = [[CommonAppManager alloc] init];

	}
	return _sharedAppManager;
}

- (id)init
{
    Class myClass = [self class];
    @synchronized(myClass) {
        if (_sharedAppManager == nil) {
            if (self = [super init]) {

            }
        }
    }
    return self;
}

-(void)sync
{
    
    [self resetTotalAppData];

}

-(void)resetTotalAppData
{
    self.levelsArray = nil;
    self.filtersArray = nil;
    self.questionsArray = nil;
    
    self.levelsArray = [[NSArray alloc] initWithArray:[self getAllLevelsList]];
    self.filtersArray = [[NSArray alloc] initWithArray:[self getAllFiltersList]];
    self.questionsArray = [[NSArray alloc] initWithArray:[self getAllQuestionsFromPrase]];
    
    [self saveDataToLocalDB];
    
}


-(void)saveDataToLocalDB
{
    
    [[DBManager sharedAppManager] deleteAllTablesFromDB];
    
    int status =  [[DBManager sharedAppManager] createTableWithName:@"Questions" withColoumns:[NSArray arrayWithObjects:QuestionKey,AnswerKey,LevelKey,FilterKey, nil]];
    
    NSLog(@"%d status",status);
    
    status = [[DBManager sharedAppManager] createTableWithName:@"Levels" withColoumns:[NSArray arrayWithObjects:LevelKey, nil]];
    
    NSLog(@"%d status",status);
    
    status = [[DBManager sharedAppManager] createTableWithName:@"Filters" withColoumns:[NSArray arrayWithObjects:FilterKey, nil]];
    
    NSLog(@"%d status",status);
    
    for (int i=0; i<[self.levelsArray count]; i++) {
        PFObject *levelObject = [self.levelsArray objectAtIndex:i];
         int result = [[DBManager sharedAppManager] insertRowIntoTable:@"Levels" values:levelObject];
        NSLog(@"Level Row Insert result = %d",result);
    }
    
    for (int i=0; i<[self.filtersArray count]; i++) {
        PFObject *filterObject = [self.filtersArray objectAtIndex:i];
        int result = [[DBManager sharedAppManager] insertRowIntoTable:@"Filters" values:filterObject];
        NSLog(@"filter Row Insert result = %d",result);

    }
    
    for (int i=0; i<[self.questionsArray count]; i++) {
        PFObject *questionObject = [self.questionsArray objectAtIndex:i];
        int result = [[DBManager sharedAppManager] insertRowIntoTable:@"Questions" values:questionObject];
        NSLog(@"question Row Insert result = %d",result);

    }
    
    [self getDataFromLocalDB];
}

-(void)getDataFromLocalDB
{
    self.levelsArray = nil;
    self.filtersArray = nil;
    self.questionsArray = nil;
    
    self.levelsArray = [[NSArray alloc] initWithArray:[[DBManager sharedAppManager] fetchAllRowsFromTable:@"Levels"]];
    
    self.filtersArray = [[NSArray alloc] initWithArray:[[DBManager sharedAppManager] fetchAllRowsFromTable:@"Filters"]];
    
    [self getNewListOfQuestions];

}


-(void)getNewListOfQuestions
{
    
    NSMutableDictionary *filterDict = [[NSMutableDictionary alloc] init];
    
    if (self.selectedFilter) {
        [filterDict setObject:self.selectedFilter forKey:FilterKey];
    }
    if (self.selectedLevel) {
        [filterDict setObject:self.selectedLevel forKey:LevelKey];
        
    }
    
    self.questionsArray = [[NSArray alloc] initWithArray:[[DBManager sharedAppManager] filterQuerryAndFetchTheList:filterDict sortDict:nil withTable:@"Questions"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncCompleted" object:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISSyncSuccess"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)addQuestion:(NSDictionary*)dictionary
{
    PFObject *object = [PFObject objectWithClassName:@"Questions"];
    [object setObject:[dictionary objectForKey:QuestionKey] forKey:QuestionKey];
    [object setObject:[dictionary objectForKey:AnswerKey] forKey:AnswerKey];
    [object setObject:[dictionary objectForKey:LevelKey] forKey:LevelKey];
    [object setObject:[dictionary objectForKey:FilterKey] forKey:FilterKey];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //[self showAlerView:@"Saved Successfully"];
        }
        else{
            //[self showAlerView:[error description]];
        }
    }];
}


-(NSArray*)getAllQuestionsFromPrase
{
    PFQuery *query = [PFQuery queryWithClassName:@"Questions"]; //1
    NSArray *dataArray =  [query findObjects];
    return dataArray;
    
}

-(NSArray*)getQuestionsForLevel:(NSString*)level forFilter:(NSString*)filter
{
    PFQuery *query = [PFQuery queryWithClassName:@"Questions"]; //1
    [query whereKey:LevelKey equalTo:level];
    if (![filter isEqualToString:@"All"]) {
        [query whereKey:FilterKey equalTo:filter];
    }
    NSArray *dataArray =  [query findObjects];
    return dataArray;
}


-(void)addLevel:(NSString*)level
{
    PFObject *object = [PFObject objectWithClassName:@"Levels"];
    [object setObject:level forKey:LevelKey];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded) {
            
        }
        else{
            
            
        }
        
    }];
    
}

-(NSArray*)getAllLevelsList
{
    PFQuery *query = [PFQuery queryWithClassName:@"Levels"]; //1
    NSArray *tempLevelsArray =  [query findObjects];
    return tempLevelsArray;
    
}

-(void)addNewFilter:(NSString*)filterConcept
{
    PFObject *object = [PFObject objectWithClassName:@"Filters"];
    [object setObject:filterConcept forKey:FilterKey];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {

            
        }
        else{
            
            
        }
    }];
}

-(NSArray*)getAllFiltersList
{
    PFQuery *query = [PFQuery queryWithClassName:@"Filters"]; //1
    NSArray *tempfiltersArray =  [query findObjects];
    return tempfiltersArray;
}



@end
