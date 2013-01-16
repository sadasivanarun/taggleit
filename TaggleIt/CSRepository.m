//
//  CSRepository.m
//  Cabsher
//
//  Created by Sadasivan Arun on 4/29/12.
//  Copyright (c) 2012 Experion Global. All rights reserved.
//

#import "CSRepository.h"
#import "CSDataBaseManager.h"
#import "CSDatabase.h"
#import "TITripDto.h"
#import "TITagDto.h"
#import "TIImageDto.h"

@implementation CSRepository
+(NSArray *)getTableDataForTable:(NSString *)tableName
{
    CSDataBaseManager *db = [CSDatabase sharedDatabase];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    NSArray *dataArray = [db executeQuery:sqlQuery];
    
    return dataArray;
}

+(NSArray *)getTableDataForTable:(NSString *)tableName forTripId:(NSString *)tripId
{
    CSDataBaseManager *db = [CSDatabase sharedDatabase];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE tripid = %@",tableName,tripId];
    NSArray *dataArray = [db executeQuery:sqlQuery];
    
    return dataArray;
}

+(NSArray *)getTableDataForTable:(NSString *)tableName forTripId:(NSString *)tripId andTagId:(NSString *)tagId
{
    CSDataBaseManager *db = [CSDatabase sharedDatabase];
    
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE tripid = %@ and tagid = %@",tableName,tripId,tagId];
    NSArray *dataArray = [db executeQuery:sqlQuery];
    
    return dataArray;
}

-(BOOL)executeNonQuery:(NSString *)sqlQuery forArguments:(NSArray *)args
{
    CSDataBaseManager *db = [CSDatabase sharedDatabase];
    
    BOOL retVal = [db executeNonQuery:sqlQuery arguments:args];
    return retVal; 
}

-(NSInteger)executeNonQuery:(NSString *)sqlQuery
{
    CSDataBaseManager *db = [CSDatabase sharedDatabase];
    
    NSInteger retVal = [db executeScalar:sqlQuery];
    return retVal; 
}

+(BOOL)insertOrUpdateTripInfo:(TITripDto *)tripDto
{
    
    CSDataBaseManager *db = [CSDatabase sharedDatabase];
    
    NSMutableArray *args;
    NSString *sqlQuery ;
    
    NSArray *tempArray = [CSRepository getTableDataForTable:@"TripMaster" forTripId:tripDto.tripId];
    
    if(tempArray.count > 0)
    {
        sqlQuery = @"UPDATE TripMaster SET tripdescription = ?, tripname = ?, nooftags = ? WHERE tripid = ?";
        args = [[NSMutableArray alloc] initWithObjects:
                tripDto.tripDescription,
                tripDto.tripName,
                [NSNumber numberWithInt:tripDto.tripTagNo],
                tripDto.tripId,
                nil
                ];

    }
    else{
        sqlQuery = @"INSERT INTO TripMaster (tripid, tripdescription, tripname, nooftags) VALUES(?,?,?,?)";
        args = [[NSMutableArray alloc] initWithObjects:
                tripDto.tripId,
                tripDto.tripDescription,
                tripDto.tripName,
                [NSNumber numberWithInt:tripDto.tripTagNo],
                nil
                ];
    }
    
    return [db executeNonQuery:sqlQuery arguments:args];
}

+(BOOL)insertOrUpdateTagInfo:(TITagDto *)tagDto
{
    
    CSDataBaseManager *db = [CSDatabase sharedDatabase];
    
    NSMutableArray *args;
    NSString *sqlQuery ;
    
    NSArray *tempArray = [CSRepository getTableDataForTable:@"TripTag" forTripId:tagDto.tagId];
    
    if(tempArray.count > 0)
    {
        sqlQuery = @"UPDATE TripTag SET tripid = ?, triplat = ?, triplong = ?, triptagname = ?, tripimagecount = ? WHERE tagid = ?";
        args = [[NSMutableArray alloc] initWithObjects:
                tagDto.tripId,
                [NSNumber numberWithFloat:tagDto.tagLat],
                [NSNumber numberWithFloat: tagDto.tagLong],
                tagDto.tagName,
                tagDto.tagImageCount,
                tagDto.tagId,
                nil
                ];
        
    }
    else{
        sqlQuery = @"INSERT INTO TripTag (tripid, tagid, triplat, triplong, triptagname, tripimagecount) VALUES(?,?,?,?,?,?)";
        args = [[NSMutableArray alloc] initWithObjects:
                tagDto.tripId,
                tagDto.tagId,
                [NSNumber numberWithFloat:tagDto.tagLat],
                [NSNumber numberWithFloat: tagDto.tagLong],
                tagDto.tagName,
                [NSNumber numberWithInt:tagDto.tagImageCount],
                nil
                ];
    }
    
    return [db executeNonQuery:sqlQuery arguments:args];
}

+(BOOL)insertImageInfo:(TIImageDto *)imageDto
{
    CSDataBaseManager *db = [CSDatabase sharedDatabase];
    NSString *sqlQuery = @"INSERT INTO TripImage (tripid, tagid, image) VALUES(?,?,?)";
    NSMutableArray *args = [[NSMutableArray alloc] initWithObjects:
                            imageDto.tripId,
                            imageDto.tagId,
                            imageDto.tagImage,
                            nil
                            ];
    
    return [db executeNonQuery:sqlQuery arguments:args];

}


@end
