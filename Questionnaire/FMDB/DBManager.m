//
//  ERGameManager.m
//  GoodieLetters
//
//  Created by Coding Cursors on 05/05/11.
//  Copyright 2011 What IS? Properties LLC. All rights reserved.
//

#import "DBManager.h"
#import "FMDatabase.h"


@implementation DBManager



static DBManager *_sharedDBManager;

#pragma mark -
#pragma mark init and dealloc Methods
#pragma mark -

+(id)sharedAppManager
{
	if(_sharedDBManager == nil)
	{
		_sharedDBManager = [[DBManager alloc] init];
	}
	return _sharedDBManager;
}

- (id)init
{
    Class myClass = [self class];
    @synchronized(myClass) {
        if (_sharedDBManager == nil) {
            if (self = [super init]) {

            }
        }
    }
    return self;
}


-(int)createEditableCopyOfDB:(NSString*)fileName
{
    NSLog(@"Checking for database file");
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    BOOL success = [fileManager fileExistsAtPath:defaultDBPath];
    NSLog(@"If needed, bundled default DB is at: %@",defaultDBPath);
    if(!success) {
        
        return DBFileNotfound;
        
    } else {
        
       
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDirectory = [paths objectAtIndex:0];
        dbPath = [docDirectory stringByAppendingPathComponent:fileName];
        NSLog(@"Database must have existed at the following path: %@", defaultDBPath);
        BOOL fileExist=[fileManager fileExistsAtPath:dbPath];
        if (fileExist) {
            
            return DBAleradyExist;
        }
        else{
            
            success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
            
            NSLog(@"%d",success);
            
            if (success) {
                
                return DBCopiedSuccessFully;
                
            }
            else{
                
                return DBFailedToCopy;
            }
        }
    }
    NSLog(@"Done checking for db file");
    return DBFailedToCopy;
    
    
}


-(int)createTable:(NSString*)query
{
    FMDatabase *obj =[FMDatabase databaseWithPath:dbPath];
    BOOL openResult = [obj open];
    if (!openResult) {
        return DBFailedToOpen;
    }
    else{
     
        BOOL result = [obj executeUpdate:query];
        if (result) {
            return DBSuccessfullyCreatedTable;
        }
        else{
            return DBFailedToCreateTable;
        }
        [obj close];
    }
    return DBFailedToCreateTable;
}

-(NSString*)prepareDynamicInsertQuery:(NSString *)tableName columns:(NSArray *)coloumnNamesArray withValues:(NSArray *)values
{
    
    
    NSMutableString *querryString = [[NSMutableString alloc] init];
    
    [querryString appendString:[NSString stringWithFormat:@"INSERT INTO %@ (",tableName]];
    
    for (int i= 0; i<[coloumnNamesArray count]; i++) {
        [querryString appendString:[coloumnNamesArray objectAtIndex:i]];
        
        if(i < [coloumnNamesArray count] - 1)
        {
            [querryString appendString:@","];
        }
    }
    [querryString appendString:@") VALUES ("];
    for (int i= 0; i<[coloumnNamesArray count]; i++) {
        [querryString appendString:@"?"];
        
        if(i < [coloumnNamesArray count] - 1)
        {
            [querryString appendString:@","];
        }
    }
    [querryString appendString:@")"];
    return querryString;
}

-(int)insertIntoTable:(NSString *)tableName columns:(NSArray *)coloumnNamesArray withValues:(NSArray *)values
{
    
    if ((values == nil || [values count] == 0) || (coloumnNamesArray && ([coloumnNamesArray count] != [values count])))
    {
        return DBRowValuesAreNotCorrect;
    }
    FMDatabase *obj =[FMDatabase databaseWithPath:dbPath];
    BOOL openResult = [obj open];
    if (!openResult) {
        return DBFailedToOpen;
    }
    else{
        
        NSString *querryString = [self prepareDynamicInsertQuery:tableName columns:coloumnNamesArray withValues:values];
       // const char *sqlStatement = [querryString UTF8String];
        
        BOOL  result = [obj executeUpdate:querryString withArgumentsInArray:values];
        if (result) {
            
            return DBInsertedRowSuccessfully;
        }
        else{
            
            return DBFailedToInsertRow;
        }
    }

    return DBFailedToInsertRow;
    
}

-(int)DeleteRow:(NSString*)query
{
    FMDatabase *obj =[FMDatabase databaseWithPath:dbPath];
    BOOL openResult = [obj open];
    if (!openResult) {
        return DBFailedToOpen;
    }
    else{
        
        BOOL result = [obj executeUpdate:query];
        if (result) {
            return DBSuccessfullyDeletedRow;
        }
        else{
            return DBFailedToDeleteRow;
        }
        [obj close];
    }
    return DBFailedToDeleteRow;
}

-(NSString*)PrepareDynamicUpdateString:(NSString *)tableName updateColumns:(NSArray *)updateColoumnNamesArray updateWithValues:(NSArray *)updateColoumnValuesArray matchingColoumns:(NSArray*)machingColoumnNamesArray matchingColoumnWithValues:(NSArray*)matchingColoumnValuesArray
{
    
    NSMutableString *querryString = [[NSMutableString alloc] init];
    [querryString appendString:[NSString stringWithFormat:@"UPDATE %@ SET ",tableName]];
    
    for (int i= 0; i<[updateColoumnNamesArray count]; i++) {
        [querryString appendString:[NSString stringWithFormat:@"%@",[updateColoumnNamesArray objectAtIndex:i]]];
        [querryString appendString:@" = ?"];

    }
    
    [querryString appendString:@" WHERE "];
    for (int i= 0; i<[machingColoumnNamesArray count]; i++) {
       
        [querryString appendString:[NSString stringWithFormat:@"%@",[machingColoumnNamesArray objectAtIndex:i]]];
        [querryString appendString:@" = ?"];
        
    }
    
    NSLog(@"%@ updateString",querryString);
    return querryString;
}

-(int)updateRowInTable:(NSString *)tableName updateColumns:(NSArray *)updateColoumnNamesArray updateWithValues:(NSArray *)updateColoumnValuesArray matchingColoumns:(NSArray*)machingColoumnNamesArray matchingColoumnWithValues:(NSArray*)matchingColoumnValuesArray
{
    
//    if ((updateColoumnNamesArray == nil || [updateColoumnNamesArray count] == 0 || matching) || (updateColoumnValuesArray && ([updateColoumnValuesArray count] != [updateColoumnNamesArray count] ||  )))
//    {
//        return DBRowValuesAreNotCorrect;
//    }
    
    
    FMDatabase *obj =[FMDatabase databaseWithPath:dbPath];
    BOOL openResult = [obj open];
    if (!openResult) {
        return DBFailedToOpen;
    }
    else{
        
        NSString *queryString = [self PrepareDynamicUpdateString:tableName updateColumns:updateColoumnNamesArray updateWithValues:updateColoumnValuesArray matchingColoumns:machingColoumnNamesArray matchingColoumnWithValues:matchingColoumnValuesArray];
        
      //  NSDictionary *querryDict = [self executableDictionaryFromUpdateColumns:updateColoumnNamesArray updateWithValues:updateColoumnValuesArray matchingColoumns:machingColoumnNamesArray matchingColoumnWithValues:matchingColoumnValuesArray];
        
        NSArray *queryArray = [self executableArrayFromUpdateColumns:updateColoumnNamesArray updateWithValues:updateColoumnValuesArray matchingColoumns:machingColoumnNamesArray matchingColoumnWithValues:matchingColoumnValuesArray];

        
        // const char *sqlStatement = [querryString UTF8String];
        BOOL  result = [obj executeUpdate:queryString withArgumentsInArray:queryArray];
        if (result) {
            return DBUpadingRowSuccessfull;
        }
        else{
            
            return DBUpdatingFailed;
        }
    }
    
    return DBUpdatingFailed;
    
}


-(NSMutableDictionary*)executableDictionaryFromUpdateColumns:(NSArray *)updateColoumnNamesArray updateWithValues:(NSArray *)updateColoumnValuesArray matchingColoumns:(NSArray*)machingColoumnNamesArray matchingColoumnWithValues:(NSArray*)matchingColoumnValuesArray
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (int i=0; i<[updateColoumnNamesArray count]; i++) {
        
        [dict setObject:[updateColoumnValuesArray objectAtIndex:i] forKey:[updateColoumnNamesArray objectAtIndex:i]];
        
    }
    
    for (int i=0; i<[machingColoumnNamesArray count]; i++) {
        
        [dict setObject:[matchingColoumnValuesArray objectAtIndex:i] forKey:[machingColoumnNamesArray objectAtIndex:i]];
    }

    NSLog(@"%@ finalDict",dict);
    return dict;
    
}



-(NSMutableArray*)executableArrayFromUpdateColumns:(NSArray *)updateColoumnNamesArray updateWithValues:(NSArray *)updateColoumnValuesArray matchingColoumns:(NSArray*)machingColoumnNamesArray matchingColoumnWithValues:(NSArray*)matchingColoumnValuesArray
{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[updateColoumnValuesArray count]; i++) {
        
        [array addObject:[updateColoumnValuesArray objectAtIndex:i]];
        
    }
    
    for (int i=0; i<[matchingColoumnValuesArray count]; i++) {
        
        [array addObject:[matchingColoumnValuesArray objectAtIndex:i]];
    }
    
    NSLog(@"%@ finalArray",array);
    return array;
    
}


-(NSArray*)fetchAllRowsFromTable:(NSString*)tableName
{
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    FMDatabase *obj =[FMDatabase databaseWithPath:dbPath];
    BOOL openResult = [obj open];
    if (!openResult) {
        return nil;
    }
    else{
    NSString *sql = [NSString stringWithFormat:@"select * from %@",tableName];
       // NSString *strQuerry = [NSString stringWithFormat:@"SELECT * FROM contacts WHERE Access = 'Open' AND Accredtiation = 'MD'"];
    FMResultSet *result = [obj executeQuery:sql];
    while ([result next]) {
     //   NSLog(@"%@ >>>>",[result resultDictionary]);
        [finalArray addObject:[result resultDictionary]];
        
    }
    [obj close];
    }
    return finalArray;

}

-(NSArray*)fetchAllRowsWithQuery:(NSString*)queryString
{
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    FMDatabase *obj =[FMDatabase databaseWithPath:dbPath];
    BOOL openResult = [obj open];
    if (!openResult) {
        return nil;
    }
    else{
        NSString *sql = queryString;
        FMResultSet *result = [obj executeQuery:sql];
        while ([result next]) {
           // NSLog(@"%@ >>>>",[result resultDictionary]);
            [finalArray addObject:[result resultDictionary]];
            
        }
        [obj close];
    }
    return finalArray;
    
}


-(int)createTableWithName:(NSString*)tableName withColoumns:(NSArray*)coloumns
{
    
    NSString *queryString = [self createDynamicCreateTableStringWithTableName:tableName values:coloumns];
      int result =   [self createTable:queryString];
    
    return result;
}

-(NSString*)createDynamicCreateTableStringWithTableName:(NSString*)tableName values:(NSArray*)coloumns
{
    
    NSMutableString *queryString = [[NSMutableString alloc] initWithFormat:@"CREATE  TABLE 'main'.'%@'",tableName];
    [queryString appendString:@"("];
    
    for (int i=0; i<[coloumns count]; i++) {
        
        [queryString appendString:[NSString stringWithFormat:@"'%@' TEXT",[coloumns objectAtIndex:i]]];
        
        if(i < [coloumns count] - 1)
        {
            [queryString appendString:@", "];
        }
        else{
            
            [queryString appendString:@")"];

        }

        
        
    }
    
    //NSLog(@"%@ >>>> createTable",queryString);
    return queryString;
}

-(int)insertRowIntoTable:(NSString*)tableName values:(NSDictionary*)valuesDict
{
    
    NSArray *allkeysArray = [valuesDict allKeys];
    NSMutableArray *valuesArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[allkeysArray count]; i++) {
        
        [valuesArray addObject:[valuesDict objectForKey:[allkeysArray objectAtIndex:i]]];
        
        
    }
    
    int result = [self insertIntoTable:tableName columns:allkeysArray withValues:valuesArray];
    return result;
    
}

//////////// Rajesh g

- (NSString *)deleteQuerry : (NSString *) tableName
{
    NSMutableString *querryString = [[NSMutableString alloc]init];
    [querryString appendString:[NSString stringWithFormat:@"DELETE FROM %@",tableName]];
    return querryString;
}

-(int)DeleteAllRows:(NSString*)tableName
{
    FMDatabase *obj =[FMDatabase databaseWithPath:dbPath];
    BOOL openResult = [obj open];
    if (!openResult) {
        return DBFailedToOpen;
    }
    else{
        NSString *querryString =  [self deleteQuerry:tableName];
        BOOL result = [obj executeUpdate:querryString];
        if (result) {
            return DBSuccessfullyDeletedRow;
        }
        else{
            return DBFailedToDeleteRow;
        }
        [obj close];
    }
    return DBFailedToDeleteRow;
}

- (NSArray *) filterQuerryAndFetchTheList :(NSMutableDictionary *)dictFilter sortDict:(NSMutableDictionary *) dictSortOder  withTable:(NSString *)tableName
{
    NSArray *filteredArray = [[NSArray alloc] init];
    NSString *strQry = @"";
    
    NSArray * arrKeys = [dictFilter allKeys];
    
    for (int i = 0 ; i < [arrKeys count]; i++) {
        NSString *str = [arrKeys objectAtIndex:i];
            strQry = [strQry stringByAppendingFormat:@"%@ = '%@' AND ",str,[dictFilter valueForKey:str]];
    }
    
    NSString *strTemp = @"";
    
    if ([strQry length] > 0){
        strQry = [strQry substringToIndex:[strQry length]-4];
        strTemp = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@", tableName, strQry];
    }
    else
        strTemp = [NSString stringWithFormat:@"SELECT * FROM %@", tableName];
    
    if (dictSortOder != nil) {
        
        if (![[dictSortOder valueForKey:@"PrimarySort"] isEqualToString:@""])
        {
            strTemp = [strTemp stringByAppendingFormat:@" ORDER BY %@ %@",[dictSortOder valueForKey:@"PrimarySort"],[dictSortOder valueForKey:@"PrimaryOrder"]];
            if (![[dictSortOder valueForKey:@"SecondarySort"] isEqualToString:@""]) {
                strTemp = [strTemp stringByAppendingFormat:@", %@ %@",[dictSortOder valueForKey:@"SecondarySort"],[dictSortOder valueForKey:@"SecondaryOrder"]];
            }
        }
    }
    
    

    filteredArray  = [self fetchFilteredRowsFromTable: strTemp];
    
    
    return filteredArray;
}
-(NSArray*) fetchFilteredRowsFromTable :(NSString*)strQry
{
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    FMDatabase *obj =[FMDatabase databaseWithPath:dbPath];
    BOOL openResult = [obj open];
    if (!openResult) {
        return nil;
    }
    else{
        // tableName = @"contacts";
        // NSString *sql = [NSString stringWithFormat:@"select * from %@",tableName];
        FMResultSet *result = [obj executeQuery: strQry];
        while ([result next]) {
          //  NSLog(@"%@ >>>>",[result resultDictionary]);
            [filteredArray addObject:[result resultDictionary]];
            
        }
        [obj close];
    }
    return filteredArray;
    
}


-(int)updateSingleRowInTable:(NSString*)tableName FromDict:(NSDictionary*)updateDictionary
{
    
    //NSString *tableName = [updateDictionary objectForKey:@"TableName"];
    NSString *updateColoumnName = [updateDictionary objectForKey:@"SFieldName"];
    NSString *updateColoumnValue = [updateDictionary objectForKey:@"SFieldValue"];
    NSString *matchingColoumnName = [updateDictionary objectForKey:@"PKFieldName"];
    NSString *matchingColoumnValue = [updateDictionary objectForKey:@"PKFieldValue"];
    
    int result = [self updateSingleColoumnOfRowInTable:tableName updateColumn:updateColoumnName updateWithValue:updateColoumnValue matchingColoumn:matchingColoumnName matchingColoumnWithValue:matchingColoumnValue];
    
    
    return result;
    
}

-(int)updateSingleColoumnOfRowInTable:(NSString *)tableName updateColumn:(NSString *)updateColoumnName updateWithValue:(NSString *)updateColoumnValue matchingColoumn:(NSString*)matchingColoumnName matchingColoumnWithValue:(NSString*)matchingColoumnValue
{
    
    NSArray *updateColoumnNamesArray = [[NSArray alloc] initWithObjects:updateColoumnName, nil];
    NSArray *updateColoumnValuesArray = [[NSArray alloc]  initWithObjects:updateColoumnValue, nil];
    NSArray *matchingColoumnNamesArray = [[NSArray alloc] initWithObjects:matchingColoumnName, nil];
    NSArray *matchingColoumnValuesArray = [[NSArray alloc] initWithObjects:matchingColoumnValue, nil];
    
    
    int result = [self updateRowInTable:tableName updateColumns:updateColoumnNamesArray updateWithValues:updateColoumnValuesArray matchingColoumns:matchingColoumnNamesArray matchingColoumnWithValues:matchingColoumnValuesArray];
    
    
    return result;
    
    
    
}


- (int)getTheCountOfTotalRecords:(NSString *) tableName
{
    int count = 0;
    count = [[[DBManager sharedAppManager] fetchAllRowsFromTable:tableName]count];
    return count;
}

- (NSArray *)getTheRecordsFromTable:(int)pStartIndex PageSize:(int)pPageSize tableName:(NSString *)pTableName
{
    NSArray *arrayRecords = [[NSArray alloc]init];
    pPageSize = pStartIndex+10;
    NSString *strTemp = [NSString stringWithFormat:@"SELECT * FROM %@ where rowid > %d and rowid <= %d",pTableName, pStartIndex, pPageSize];
    arrayRecords = [[DBManager sharedAppManager] fetchFilteredRowsFromTable: strTemp];
    return arrayRecords;
}

- (int) dropTheTable: (NSString *) tableName
{
    NSString *queryString = [NSString stringWithFormat:@"Drop table if exists %@",tableName];
    int result =   [self createTable:queryString];
    return result;
}

-(void)deleteAllTablesFromDB
{
    NSString *queryString = @"SELECT name FROM sqlite_master WHERE type = 'table'";
    
    NSArray *totalTablesArray = [self fetchAllRowsWithQuery:queryString];
    
    NSLog(@"%@ >>",totalTablesArray);
    
    
    for (int i=0; i<[totalTablesArray count]; i++) {
        
        NSString *tableName = [[totalTablesArray objectAtIndex:i] objectForKey:@"name"];
            [[DBManager sharedAppManager] dropTheTable:tableName];

    }
    
}

-(BOOL)checkForTableExistsWithName:(NSString*)tableName
{
    
   
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM sqlite_master WHERE name ='%@' and type='table'",tableName];

    NSArray *tablesArray = [self fetchAllRowsWithQuery:queryString];
    
    if ([tablesArray count]) {
        
        return YES;
    }
    else{
        
        return NO;
    }
    
    
    
    
    
}


-(NSArray*)fetchRowsByExecutingStatement:(NSString*)statement
{
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    FMDatabase *obj =[FMDatabase databaseWithPath:dbPath];
    BOOL openResult = [obj open];
    if (!openResult) {
        return nil;
    }
    else{
        NSString *sql = statement;
        // NSString *strQuerry = [NSString stringWithFormat:@"SELECT * FROM contacts WHERE Access = 'Open' AND Accredtiation = 'MD'"];
        FMResultSet *result = [obj executeQuery:sql];
        while ([result next]) {
            // NSLog(@"%@ >>>>",[result resultDictionary]);
            [finalArray addObject:[result resultDictionary]];
        }
        [obj close];
    }
    return finalArray;
    
}

@end