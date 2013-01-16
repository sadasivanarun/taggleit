//
//  TITagDto.h
//  TaggleIt
//
//  Created by Sadasivan Arun on 11/28/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TITagDto : NSObject

@property (nonatomic, strong)NSString *tagId;
@property (nonatomic, strong)NSString *tripId;
@property (nonatomic, assign)CGFloat tagLat;
@property (nonatomic, assign)CGFloat tagLong;
@property (nonatomic, strong)NSString *tagName;
@property (nonatomic, assign)NSInteger tagImageCount;
@property (nonatomic, assign)NSMutableArray *tagImageArray;


@end
