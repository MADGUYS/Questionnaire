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



@interface CommonAppManager : NSObject{
    

    
    
}

+(id)sharedAppManager;
-(void)sync;
-(void)getNewListOfQuestions;
-(void)getDataFromLocalDB;


@property(nonatomic,strong)NSArray *levelsArray;
@property(nonatomic,strong)NSArray *filtersArray;
@property(nonatomic,strong)NSArray *questionsArray;
@property(nonatomic,strong)NSString *selectedLevel;
@property(nonatomic,strong)NSString *selectedFilter;

@end
