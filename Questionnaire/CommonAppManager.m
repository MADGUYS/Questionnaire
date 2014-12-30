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
    self.selectedFilter = nil;
    self.selectedLevel = nil;
    self.levelsArray = nil;
    self.filtersArray = nil;
    self.questionsArray = nil;
    
    //self.levelsArray = [[NSArray alloc] initWithArray:[self getAllLevelsList]];
    //self.filtersArray = [[NSArray alloc] initWithArray:[self getAllFiltersList]];
   
    [self getAllQuestionsFromPrase];
    
}


-(void)afterFetchingData:(NSArray*)array
{
    
    self.questionsArray = [[NSArray alloc] initWithArray:array];
    [self saveDataToLocalDB];
}

-(void)saveDataToLocalDB
{
    self.favArray = [[NSArray alloc] initWithArray:[[DBManager sharedAppManager] fetchColounFromAllRowsFromTable:@"Favorites" ColoumnName:ObjectId]];
    
    self.favArray = [self.favArray valueForKey:ObjectId];
    
    [[DBManager sharedAppManager] deleteAllTablesFromDB];
    
    int status =  [[DBManager sharedAppManager] createTableWithName:@"Questions" withColoumns:[NSArray arrayWithObjects:ObjectId,CreatedAt,QuestionKey,AnswerKey,LevelKey,FilterKey,IsFavorite, nil]];

    status =  [[DBManager sharedAppManager] createTableWithName:@"Favorites" withColoumns:[NSArray arrayWithObjects:ObjectId,CreatedAt,QuestionKey,AnswerKey,LevelKey,FilterKey,IsFavorite, nil]];

    for (int i=0; i<[self.questionsArray count]; i++) {
        PFObject *questionObject = [self.questionsArray objectAtIndex:i];
        int result = [[DBManager sharedAppManager] insertRowIntoTable:@"Questions" values:[self getDictionaryFromPFObject:questionObject]];
        NSLog(@"question Row Insert result = %d",result);

    }
    
    [self getDataFromLocalDB];
}

-(void)saveToFavList:(NSDictionary*)questionDict
{
    
    int result = [[DBManager sharedAppManager] insertRowIntoTable:@"Favorites" values:questionDict];
    NSLog(@"FAV Row Insert result = %d",result);
    
}

-(void)deleteFromFav:(NSDictionary*)questionDict
{
    
    NSLog(@"%@ >>>>>",[NSString stringWithFormat:@"DELETE FROM Favorites WHERE %@ = '%@'",ObjectId,[questionDict objectForKey:ObjectId]]);
    int result = [[DBManager sharedAppManager] DeleteRow:[NSString stringWithFormat:@"DELETE FROM Favorites WHERE %@ = '%@'",ObjectId,[questionDict objectForKey:ObjectId]]];

    NSLog(@"FAV Row DELETE result = %d",result);
    
}

-(void)updateFavValueInMainTable:(NSDictionary*)questionDict
{
    int result = [[DBManager sharedAppManager] updateRowInTable:@"Questions" updateColumns:[NSArray arrayWithObjects:IsFavorite, nil] updateWithValues:[NSArray arrayWithObjects:[questionDict objectForKey:IsFavorite], nil] matchingColoumns:[NSArray arrayWithObjects:ObjectId, nil] matchingColoumnWithValues:[NSArray arrayWithObjects:[questionDict objectForKey:ObjectId], nil]];
    
    NSLog(@"FAV Row Update result = %d",result);

    
}

-(NSDictionary*)getDictionaryFromPFObject:(PFObject*)object
{
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:object.createdAt
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterFullStyle];
    NSLog(@"%@",dateString);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:object.objectId ? object.objectId :@" " forKey:ObjectId];
    [dict setObject:dateString ? dateString :@" " forKey:CreatedAt];
    [dict setObject:[object valueForKey:QuestionKey] ? [object valueForKey:QuestionKey] : @" " forKey:QuestionKey];
    if ([self.favArray containsObject:object.objectId]) {
        [dict setObject:[NSString stringWithFormat:@"YES"] forKey:IsFavorite];

    }
    else{
        
        [dict setObject:[NSString stringWithFormat:@"NO"] forKey:IsFavorite];

    }
    
    [dict setObject:[object valueForKey:AnswerKey] ? [object valueForKey:AnswerKey] : @" " forKey:AnswerKey];
    [dict setObject:[object valueForKey:LevelKey] ? [object valueForKey:LevelKey] : @" " forKey:LevelKey];
    [dict setObject:[object valueForKey:FilterKey] ? [object valueForKey:FilterKey] : @" " forKey:FilterKey];
    
    return dict;
}

-(void)getDataFromLocalDB
{
    self.levelsArray = nil;
    self.filtersArray = nil;
    self.questionsArray = nil;
    self.favArray = nil;
    
    self.levelsArray = [[NSArray alloc] initWithArray:[[DBManager sharedAppManager] fetchColounFromAllRowsFromTable:@"Questions" ColoumnName:LevelKey]];
    
    self.filtersArray =  [[NSArray alloc] initWithArray:[[DBManager sharedAppManager] fetchColounFromAllRowsFromTable:@"Questions" ColoumnName:FilterKey]];
    
    NSSet *levelsSet = [NSSet setWithArray:self.levelsArray];
    self.levelsArray = [levelsSet allObjects];
    
    
    NSSet *filtersSet = [NSSet setWithArray:self.filtersArray];
    self.filtersArray = [filtersSet allObjects];
    
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

-(void)getFavQuestionsList
{
    
    NSMutableDictionary *filterDict = [[NSMutableDictionary alloc] init];
    
    self.questionsArray = [[NSArray alloc] initWithArray:[[DBManager sharedAppManager] filterQuerryAndFetchTheList:filterDict sortDict:nil withTable:@"Favorites"]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SyncCompleted" object:nil];
    
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


-(void)getAllQuestionsFromPrase
{
    PFQuery *query = [PFQuery queryWithClassName:@"Questions"]; //1
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        [self afterFetchingData:objects];

        
    }];
    
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
