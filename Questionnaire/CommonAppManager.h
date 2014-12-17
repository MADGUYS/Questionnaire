//
//  ERGameManager.h
//  GoodieLetters
//
//  Created by Coding Cursors on 05/05/11.
//  Copyright 2011 What IS? Properties LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define QuestionKey @"Question"
#define AnswerKey @"Answer"
#define LevelKey @"Level"
#define FilterKey @"Filter"
#define ObjectId @"ObjectId"
#define CreatedAt @"CreatedAt"
#define IsFavorite @"IsFavorite"

@interface CommonAppManager : NSObject{
    

    
    
}

+(id)sharedAppManager;
-(void)sync;
-(void)getNewListOfQuestions;
-(void)getDataFromLocalDB;


@property(nonatomic,strong)NSArray *levelsArray;
@property(nonatomic,strong)NSArray *filtersArray;
@property(nonatomic,strong)NSArray *questionsArray;
@property(nonatomic,strong)NSArray *favArray;

@property(nonatomic,strong)NSString *selectedLevel;
@property(nonatomic,strong)NSString *selectedFilter;

-(void)saveToFavList:(NSDictionary*)questionDict;
-(void)deleteFromFav:(NSDictionary*)questionDict;
-(void)updateFavValueInMainTable:(NSDictionary*)questionDict;

-(void)getFavQuestionsList;
@end
