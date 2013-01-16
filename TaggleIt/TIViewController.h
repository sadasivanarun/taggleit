//
//  TIViewController.h
//  TaggleIt
//
//  Created by Sadasivan Arun on 11/21/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TIAbstractViewController.h"

@interface TIViewController : TIAbstractViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)UITableView *mTableView;
@end
