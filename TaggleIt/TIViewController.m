//
//  TIViewController.m
//  TaggleIt
//
//  Created by Sadasivan Arun on 11/21/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import "TIViewController.h"
#import "TIAbstractViewController.h"
#import "TITripService.h"
#import "TITripDto.h"

#import "TIAddEditTagsViewController.h"

@interface TIViewController ()
{
    IBOutlet UIView *addTagView;
    IBOutlet UITextField *textFieldName;
    IBOutlet UITextField *textFieldDescription;
    IBOutlet UITableView *tableView;
}
@property (nonatomic, strong)NSMutableArray *mTripArray;

-(IBAction)addTagButtonClicked:(id)sender;
-(IBAction)cancelTagButtonClicked:(id)sender;

-(void)resetValues;
-(BOOL)checkForValidations;

@end

@implementation TIViewController
@synthesize mTableView;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //addTagView.center = self.view.center;
    
    [self setTitleForNavigationBar:@"Home"];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewTagButtonClicked:)];
    
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    if(self.mTripArray!=nil)
    {
        self.mTripArray = nil;
    }
    
    self.mTripArray = [[NSMutableArray alloc]initWithCapacity:10];
    TITripService *tripService = [[TITripService alloc]init];
    [tripService retrieveTrekInfo:self.mTripArray];
    
    

}

-(void)addNewTagButtonClicked:(id)sender
{
    [self resetValues];
    [self.view addSubview:addTagView];
}

-(IBAction)addTagButtonClicked:(id)sender
{
    BOOL validationBool = [self checkForValidations];
    
    if(validationBool==TRUE)
    {
        TITripDto *tripDto = [[TITripDto alloc]init];
        tripDto.tripName = textFieldName.text;
        tripDto.tripDescription = textFieldDescription.text;
        tripDto.tripTagNo = 0;
        NSString *dateId = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
        
        //tripDto.tripId = [dateId stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        tripDto.tripId = [[dateId componentsSeparatedByString:@"."]objectAtIndex:0];
        
        
        TITripService *tripService = [[TITripService alloc]init];
        
        BOOL retVal = [tripService addTrekBaseInformation:tripDto];
        
        if (retVal) {
            TIAddEditTagsViewController *addTagViewController = [[TIAddEditTagsViewController alloc]initWithTrip:tripDto];
            
            [self.navigationController pushViewController:addTagViewController animated:YES];
        }
    }
}
-(IBAction)cancelTagButtonClicked:(id)sender
{
    [addTagView removeFromSuperview];
}

-(void)resetValues
{
    textFieldDescription.text = @"";
    textFieldName.text = @"";
}

-(BOOL)checkForValidations
{
    BOOL retVal = TRUE;
    NSString *warningString;
    
    if([textFieldName.text isEqualToString:@""])
    {
        warningString = @"Please add a trip name.";
        
        retVal = FALSE;
        
    }
    
    
    if(!retVal)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:warningString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }
    
    return retVal;
}

#pragma mark - UITableView Delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mTripArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    tableView.scrollEnabled = NO;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
    TITripDto *tripDto = [self.mTripArray objectAtIndex:indexPath.row];
    cell.textLabel.text = tripDto.tripName;
    cell.detailTextLabel.text = tripDto.tripDescription;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TITripDto *tripDto = [self.mTripArray objectAtIndex:indexPath.row];
    TIAddEditTagsViewController *addTagViewController = [[TIAddEditTagsViewController alloc]initWithTrip:tripDto];
    
    [self.navigationController pushViewController:addTagViewController animated:YES];
}

@end
