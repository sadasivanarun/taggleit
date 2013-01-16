//
//  CSRepository.h
//  Cabsher
//
//  Created by Sadasivan Arun on 4/29/12.
//  Copyright (c) 2012 Experion Global. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TITripDto;
@class TITagDto;
@class TIImageDto;
@interface CSRepository : NSObject

+(NSArray *)getTableDataForTable:(NSString *)tableName;
+(NSArray *)getTableDataForTable:(NSString *)tableName forTripId:(NSString *)tripId;
+(NSArray *)getTableDataForTable:(NSString *)tableName forTripId:(NSString *)tripId andTagId:(NSString *)tagId;
-(BOOL)executeNonQuery:(NSString *)sqlQuery forArguments:(NSArray *) args;
-(NSInteger)executeNonQuery:(NSString *)sqlQuery;
+(BOOL)insertOrUpdateTripInfo:(TITripDto *)tripDto;
+(BOOL)insertOrUpdateTagInfo:(TITagDto *)tagDto;
+(BOOL)insertImageInfo:(TIImageDto *)imageDto;
@end
