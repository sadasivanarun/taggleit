//
//  TITripDto.h
//  TaggleIt
//
//  Created by Sadasivan Arun on 11/28/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TITripDto : NSObject
@property (nonatomic, strong)NSString *tripId;
@property (nonatomic, strong)NSString *tripName;
@property (nonatomic, strong)NSString *tripDescription;
@property (nonatomic, assign)NSInteger tripTagNo;
@property (nonatomic, strong)NSMutableArray *tripTagArray;
@end
