//
//  TIAbstractViewController.m
//  TaggleIt
//
//  Created by Sadasivan Arun on 11/27/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import "TIAbstractViewController.h"

@interface TIAbstractViewController ()

@end

@implementation TIAbstractViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTitleForNavigationBar:(NSString *)navName
{
    self.navigationItem.title = navName;
}



@end
