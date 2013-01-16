//
//  TIAppDelegate.h
//  TaggleIt
//
//  Created by Sadasivan Arun on 11/21/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TIViewController;

@interface TIAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TIViewController *viewController;

-(BOOL) addDatabaseToDocumentsFolder;

@end
