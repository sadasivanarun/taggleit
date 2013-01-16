//
//  TITripService.m
//  TaggleIt
//
//  Created by Sadasivan Arun on 11/21/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import "TITripService.h"
#import "TITripDto.h"
#import "TITagDto.h"
#import "TIImageDto.h"
#import "CSRepository.h"
@implementation TITripService

-(BOOL)addTrekBaseInformation:(TITripDto *)tripDto
{
    return [CSRepository insertOrUpdateTripInfo:tripDto];
}

-(BOOL)updateTagInfo:(TITagDto *)tagDto
{
    return [CSRepository insertOrUpdateTagInfo:tagDto];
}

-(void)retrieveTrekInfo:(NSMutableArray *)masterTripArray
{
    [self stripDBArrayFrom:[CSRepository getTableDataForTable:@"tripmaster"]andStoreTo:masterTripArray];
}

-(void)stripDBArrayFrom:(NSArray *)tripDbArray andStoreTo:(NSMutableArray *)tripMasterArray
{
    for (NSDictionary *dict in tripDbArray)
    {
        TITripDto *tripdto = [[TITripDto alloc]init];
        tripdto.tripId = [dict objectForKey:@"tripid"];
        tripdto.tripName = [dict objectForKey:@"tripname"];
        tripdto.tripDescription = [dict objectForKey:@"tripdescription"];
        tripdto.tripTagNo = [[dict objectForKey:@"nooftags"]intValue];
        [tripMasterArray addObject:tripdto];
    }
}

-(void)retrieveTagInfo:(NSMutableArray *)masterTagArray forTripId:(NSString *)tripId
{
    [self stripTagDBArrayFrom:[CSRepository getTableDataForTable:@"TripTag"forTripId:tripId]andStoreTo:masterTagArray];
}


-(void)stripTagDBArrayFrom:(NSArray *)tagDbArray andStoreTo:(NSMutableArray *)tagMasterArray
{
    for (NSDictionary *dict in tagDbArray)
    {
        TITagDto *tagDto = [[TITagDto alloc]init];
        tagDto.tripId = [dict objectForKey:@"tripid"];
        tagDto.tagId = [dict objectForKey:@"tagid"];
        tagDto.tagLat = [[dict objectForKey:@"triplat"] floatValue];
        tagDto.tagLong = [[dict objectForKey:@"triplong"]floatValue];
        tagDto.tagName =[dict objectForKey:@"triptagname"];
        tagDto.tagImageCount = [[dict objectForKey:@"tagimagecount"] intValue];
        [tagMasterArray addObject:tagDto];
    }
}

-(void)retrieveImageInfo:(NSMutableArray *)masterImageArray forTripId:(NSString *)tripId andTagid:(NSString *)tagId
{
    [self stripImageDBArrayFrom:[CSRepository getTableDataForTable:@"TripImage"forTripId:tripId andTagId:tagId]andStoreTo:masterImageArray];
}

-(void)retrieveImageInfo:(NSMutableArray *)masterImageArray forTripId:(NSString *)tripId
{
    [self stripImageDBArrayFrom:[CSRepository getTableDataForTable:@"TripImage"forTripId:tripId]andStoreTo:masterImageArray];
}

-(void)stripImageDBArrayFrom:(NSArray *)imageDbArray andStoreTo:(NSMutableArray *)masterImageArray
{
    for (NSDictionary *dict in imageDbArray)
    {
        TIImageDto *imageDto = [[TIImageDto alloc]init];
        imageDto.tripId = [dict objectForKey:@"tripid"];
        imageDto.tagId = [dict objectForKey:@"tagid"];
        imageDto.tagImage = [dict objectForKey:@"image"] ;
        [masterImageArray addObject:imageDto];
    }
}

-(BOOL)updateImageInfo:(TIImageDto *)imageDto
{
    return [CSRepository insertImageInfo:imageDto];
}


@end
