//
//  MCDatabase.m
//  CoPlus
//
//  Created by admin on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CSDatabase.h"
#import "DAUtility.h"
#import "DAConstants.h"

#import "DAConstants.h"

static sqlite3 *sharedDatabase = nil;

static CSDataBaseManager *databaseManager = nil;

@implementation CSDatabase

// Name of the database file

+ (CSDataBaseManager *) sharedDatabase
{
	if(nil == databaseManager)
	{
		NSString *filePath = [DAUtility getDocumentPathForUser];
        
        filePath = [filePath stringByAppendingPathComponent:DatabaseNameWithExt];
		
		databaseManager = [[CSDataBaseManager alloc] initDBWithFileName:filePath];
	}
	return databaseManager;
}


// Close the shared instance of the databse. 
+ (bool) closeDatabase {
	bool success = false;
	@synchronized(self)
	{
		if (sharedDatabase != nil){
			success = sqlite3_close(sharedDatabase);
		}
	}
	return success;
}


@end
