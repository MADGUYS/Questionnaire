//
//  ERGameManager.h
//  GoodieLetters
//
//  Created by Coding Cursors on 05/05/11.
//  Copyright 2011 What IS? Properties LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define    PKSQLITE_NULL   @"NULL" // NULL TYPE
#define    PKSQLITE_TEXT   @"TEXT" // TEXT
#define    PKSQLITE_INTEGER   @"INTEGER" // NUMERIC
#define    PKSQLITE_FLOAT   @"REAL" // FLOAT/REAL
#define    PKSQLITE_BLOB   @"BLOB" // BLOB

#define DBAleradyExist 101
#define DBCopiedSuccessFully 102
#define DBFailedToCopy 103
#define DBOpened 104
#define DBFailedToOpen 105
#define DBFileNotfound 106
#define DBFailedToCreateTable 107
#define DBSuccessfullyCreatedTable 108
#define DBRowValuesAreNotCorrect 109
#define DBFailedToInsertRow 110
#define DBInsertedRowSuccessfully 111
#define DBSuccessfullyDeletedRow 112
#define DBFailedToDeleteRow 113
#define DBUpdatingFailed 114
#define DBUpadingRowSuccessfull 115


@interface DBManager : NSObject{
    
     NSString *dbPath;
    
}

+(id)sharedAppManager;
-(int)createEditableCopyOfDB:(NSString*)fileName;
-(int)createTable:(NSString*)query;
-(int)insertIntoTable:(NSString *)tableName columns:(NSArray *)coloumnNamesArray withValues:(NSArray *)values;
-(int)DeleteRow:(NSString*)query;
-(int)DeleteAllRows:(NSString*)tableName;

-(NSArray*)fetchAllRowsFromTable:(NSString*)tableName;
-(NSArray*)fetchAllRowsWithQuery:(NSString*)queryString;

-(NSString*)prepareDynamicInsertQuery:(NSString *)tableName columns:(NSArray *)coloumnNamesArray withValues:(NSArray *)values;
-(NSString*)PrepareDynamicUpdateString:(NSString *)tableName updateColumns:(NSArray *)updateColoumnNamesArray updateWithValues:(NSArray *)updateColoumnValuesArray matchingColoumns:(NSArray*)machingColoumnNamesArray matchingColoumnWithValues:(NSArray*)matchingColoumnValuesArray;

-(NSMutableDictionary*)executableDictionaryFromUpdateColumns:(NSArray *)updateColoumnNamesArray updateWithValues:(NSArray *)updateColoumnValuesArray matchingColoumns:(NSArray*)machingColoumnNamesArray matchingColoumnWithValues:(NSArray*)matchingColoumnValuesArray;

-(int)updateRowInTable:(NSString *)tableName updateColumns:(NSArray *)updateColoumnNamesArray updateWithValues:(NSArray *)updateColoumnValuesArray matchingColoumns:(NSArray*)machingColoumnNamesArray matchingColoumnWithValues:(NSArray*)matchingColoumnValuesArray;

-(int)createTableWithName:(NSString*)tableName withColoumns:(NSArray*)coloumns;
-(NSString*)createDynamicCreateTableStringWithTableName:(NSString*)tableName values:(NSArray*)coloumns;

-(int)insertRowIntoTable:(NSString*)tableName values:(NSDictionary*)valuesDict;

-(int)updateSingleRowInTable:(NSString*)tableName FromDict:(NSDictionary*)updateDictionary;

- (NSArray *) filterQuerryAndFetchTheList :(NSMutableDictionary *)dictFilter sortDict:(NSMutableDictionary *) dictSortOder  withTable:(NSString *)tableName;
- (NSArray *)getTheRecordsFromTable:(int)pStartIndex PageSize:(int)pPageSize tableName:(NSString *)pTableName;
- (int)getTheCountOfTotalRecords:(NSString *) tableName;

- (int) dropTheTable: (NSString *) tableName;

-(void)deleteAllTablesFromDB;

-(BOOL)checkForTableExistsWithName:(NSString*)tableName;

-(NSArray*)fetchRowsByExecutingStatement:(NSString*)statement;

-(NSArray*)fetchColounFromAllRowsFromTable:(NSString*)tableName ColoumnName:(NSString*)coloumn;
@end
