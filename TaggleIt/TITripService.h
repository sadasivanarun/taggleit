//
//  TITripService.h
//  TaggleIt
//
//  Created by Sadasivan Arun on 11/21/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TITripDto;
@class TITagDto;
@class TIImageDto;
@interface TITripService : NSObject


-(BOOL)addTrekBaseInformation:(TITripDto *)tripDto;
-(BOOL)updateTagInfo:(TITagDto *)tagDto;
-(NSMutableArray *)stripDBArrayFrom:(NSArray *)tripMasterArray;
-(void)retrieveTrekInfo:(NSMutableArray *)masterTripArray;
-(void)stripDBArrayFrom:(NSArray *)tagDbArray andStoreTo:(NSMutableArray *)tagMasterArray;
-(void)stripTagDBArrayFrom:(NSArray *)tagDbArray andStoreTo:(NSMutableArray *)tagMasterArray;
-(void)retrieveTagInfo:(NSMutableArray *)masterTagArray forTripId:(NSString *)tripId;
-(void)retrieveImageInfo:(NSMutableArray *)masterImageArray forTripId:(NSString *)tripId andTagid:(NSString *)tagId;
-(void)retrieveImageInfo:(NSMutableArray *)masterImageArray forTripId:(NSString *)tripId;
-(BOOL)updateImageInfo:(TIImageDto *)imageDto;

@end
