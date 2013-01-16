//
//  TIGalleryViewController.h
//  TaggleIt
//
//  Created by Sadasivan Arun on 12/16/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIAbstractViewController.h"
@interface TIGalleryViewController : TIAbstractViewController


-(id)initWithArray:(NSMutableArray *)imageTagArray andIndex:(NSInteger)imageIndex;
@end
