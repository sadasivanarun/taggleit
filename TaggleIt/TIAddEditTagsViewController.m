//
//  TIAddEditTagsViewController.m
//  TaggleIt
//
//  Created by Sadasivan Arun on 11/28/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import "TIAddEditTagsViewController.h"
#import "MapViewAnnotation.h"
#import "TITripService.h"
#import "TIMyLocation.h"
#import "TIImageDto.h"
#import "TIGalleryViewController.h"
#import "TIGoogleMapViewController.h"

#define DEFAULT_ANNOTATION 1001
#define INITIAL_BUTTON_X 64
#define OFFSET 20

@interface TIAddEditTagsViewController ()
{
    IBOutlet UIView *tagAddView;
    IBOutlet UITextField *tagNameField;
    IBOutlet UIButton *addImageButton;
    IBOutlet UIScrollView *buttonScrollView;
    
}
@property (nonatomic, strong)IBOutlet MKMapView *mMapView;
@property (nonatomic) NSMutableArray *mAnnotationList;
@property (nonatomic, strong)CLLocation *mUserCurrentLocation;
@property (nonatomic, strong) CLLocationManager *mLocationManager;
@property (nonatomic, strong) TITagDto *mTagDto;
@property (nonatomic, strong) NSMutableArray *mAnnotationArray;
@property (nonatomic, strong) NSMutableArray *mImageArray;
@property (nonatomic, strong) NSMutableArray *mMasterImageArray;
@property (nonatomic, strong) NSMutableArray *mTagImageArray;
@property (nonatomic, strong) NSMutableArray *mButtonArray;
@property (nonatomic, strong)UIImagePickerController *mImagePicker;
@property (nonatomic, strong)UIImagePickerController *mPickerLibrary;
@property (nonatomic, strong) TITagDto *mCurrentTagClicked;


-(void)markCurrentLocation;
-(void)getCurrentLocation;
-(void)tagPointsToTheMapView:(NSMutableArray *)annotationPointList;
-(void)loadAllPointsToTheMapView;
-(void)removeAllPoints;
-(IBAction)addNewTagButtonClicked:(id)sender;
-(IBAction)cancelTagSubView:(id)sender;
-(void)getImagesForTripAndUpdateMasterArray;
-(void)loadImagesToScrollView;
-(void)displayTheScrollView:(BOOL)shouldDisplay;
-(void)getImagesForTagId:(NSString *)tagId andTripId:(NSString *)tripId;
-(IBAction)clickPictureButtonClicked:(id)sender;
-(NSString *)saveImageToDocumentsFolder:(UIImage *)image;
-(NSString *)getImageFilePathForName:(NSString *)imageFileName;
@end

@implementation TIAddEditTagsViewController
@synthesize mTripId, mMapView, mAnnotationList, mUserCurrentLocation,mLocationManager,mTripDto,mTagDto,mAnnotationArray,mImageArray,mMasterImageArray,mTagImageArray,mButtonArray, mImagePicker, mPickerLibrary,mCurrentTagClicked;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithTrip:(TITripDto*)tripDto
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.mTripDto = tripDto;
        self.mTagDto = [[TITagDto alloc]init];
        self.mAnnotationArray = [[NSMutableArray alloc]initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if(self.mUserCurrentLocation==nil)
    {
        self.mUserCurrentLocation = [[CLLocation alloc] init];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.mAnnotationArray removeAllObjects];
    
    buttonScrollView.frame = CGRectMake(0, self.view.bounds.size.height+buttonScrollView.frame.size.height, buttonScrollView.frame.size.width, buttonScrollView.frame.size.height);
    
    [self.view addSubview:buttonScrollView];
    
    
    [self setTitleForNavigationBar:@"Taggle"];
    
    [self getCurrentLocation];
    
    [self.mMapView setDelegate:self];
    
    UIBarButtonItem *barButtonItemForTag = [[UIBarButtonItem alloc] initWithTitle:@"Tag" style:UIBarButtonSystemItemAction target:self action:@selector(tagButtonClicked:)];
    
    
    UIBarButtonItem *barButtonItemForDirections = [[UIBarButtonItem alloc] initWithTitle:@"Get Directions" style:UIBarButtonSystemItemAction target:self action:@selector(getDirectionsButtonClicked:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:barButtonItemForDirections ,barButtonItemForTag, nil];
    

    
    if(self.mTripDto.tripTagNo>0)
    {
        TITripService *service = [[TITripService alloc]init];
        if(self.mTripDto.tripTagArray!=nil)
        {
            self.mTripDto.tripTagArray = nil;
        }
        self.mTripDto.tripTagArray = [[NSMutableArray alloc]initWithCapacity:10];
        
        [service retrieveTagInfo:self.mTripDto.tripTagArray forTripId:self.mTripDto.tripId];
        [self loadAllPointsToTheMapView];
        
        [self getImagesForTripAndUpdateMasterArray];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Loading/Removing points
#pragma mark -

-(void)loadAllPointsToTheMapView
{
    for(int i = 0 ; i < [self.mTripDto.tripTagArray count] ; i++)
    {
        CLLocationCoordinate2D location;
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.01;
        span.longitudeDelta = 0.01;
        region.span = span;
        TITagDto *tagDto = [self.mTripDto.tripTagArray objectAtIndex:i];
        location.latitude = tagDto.tagLat;
        location.longitude = tagDto.tagLong;
        region.center = location;
        TIMyLocation *annotation = [[TIMyLocation alloc] initWithName:tagDto.tagName address:@"" coordinate:location andIndex:i] ;
        [self.mMapView addAnnotation:annotation];
        [self.mAnnotationArray addObject:annotation];
        

    }
}

-(void)removeAllPoints
{
    [self.mMapView removeAnnotations:self.mAnnotationArray];
}

#pragma mark -
#pragma mark Mapview Delegates
#pragma mark -
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[TIMyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mMapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
        } else {
            annotationView.annotation = annotation;
        }
        
        TIMyLocation *myAnnotation = annotation;
        
        if(myAnnotation.index == 1001)
        {
            annotationView.image = [UIImage imageNamed:@"mappinpink.png"];
        }
        else{
            annotationView.image = [UIImage imageNamed:@"mappinazure.png"];
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView selectAnnotation:view.annotation animated:YES];
    
    TIMyLocation *location = view.annotation;
    
    if(location.index!=1001)
    {
        if(self.mCurrentTagClicked==nil)
        {
            self.mCurrentTagClicked = nil;
        }
        
        self.mCurrentTagClicked = [self.mTripDto.tripTagArray objectAtIndex:location.index];
        
        NSLog(@"Tag name = %@",self.mCurrentTagClicked.tagName);
        
        [self getImagesForTagId:self.mCurrentTagClicked.tagId andTripId:self.mCurrentTagClicked.tripId];
        
        [self loadImagesToScrollView];
        
        [self displayTheScrollView:YES];

    }
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    TIMyLocation *location = view.annotation;
    
    if(location.index!=1001)
    {
        [self displayTheScrollView:NO];
    }
}

#pragma mark -
#pragma mark Location Updates
#pragma mark -

-(void)getCurrentLocation
{
    if(self.mLocationManager==nil)
    {
        self.mLocationManager = [[CLLocationManager alloc] init];
        self.mLocationManager.delegate = self;
        self.mLocationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        self.mLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    }
    [self.mLocationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.mUserCurrentLocation = newLocation;
    [self markCurrentLocation];
    [self.mLocationManager stopUpdatingLocation];
    self.mLocationManager = nil;
}

-(void) markCurrentLocation
{
    
    CLLocationCoordinate2D location;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.3;
    span.longitudeDelta = 0.3;
    region.span = span;
    location.latitude = self.mUserCurrentLocation.coordinate.latitude;
    location.longitude = self.mUserCurrentLocation.coordinate.longitude;
    region.center = location;
    [self.mMapView setRegion:region animated:YES];
    TIMyLocation *annotation = [[TIMyLocation alloc] initWithName:@"I am here" address:@"Tag and Taggle." coordinate:location andIndex:1001] ;
    [self.mMapView addAnnotation:annotation];
//    [self.mAnnotationArray addObject:annotation];
    
    [self.mAnnotationArray insertObject:annotation atIndex:0];
    
    
}

-(void)tagPointsToTheMapView:(NSMutableArray *)annotationPointList
{
    [self.mMapView addAnnotations:annotationPointList];
}

#pragma mark -
#pragma mark Button Clicks
#pragma mark -
-(void)tagButtonClicked:(id)sender
{
    self.mTagDto.tagLat = self.mUserCurrentLocation.coordinate.latitude;
    self.mTagDto.tagLong = self.mUserCurrentLocation.coordinate.longitude;
    NSString *dateId = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
    
    //tripDto.tripId = [dateId stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    self.mTagDto.tagId = [[dateId componentsSeparatedByString:@"."]objectAtIndex:0];
    self.mTagDto.tripId = self.mTripDto.tripId;
    [self.view addSubview:tagAddView];
    
}

-(void)getDirectionsButtonClicked:(id)sender
{
    TIGoogleMapViewController *googleMapView = [[TIGoogleMapViewController alloc]initWithAnnotationArray:self.mAnnotationArray];
    
    [self.navigationController pushViewController:googleMapView animated:NO];
}

-(IBAction)cancelTagSubView:(id)sender
{
    [tagAddView removeFromSuperview];
}

-(IBAction)addNewTagButtonClicked:(id)sender
{
    if(![tagNameField.text isEqualToString:@""])
    {
        self.mTagDto.tagName = tagNameField.text;
        [tagAddView removeFromSuperview];
        TITripService *tripService = [[TITripService alloc]init];
        if([tripService updateTagInfo:self.mTagDto])
        {
            if([self.mTripDto.tripTagArray count]>0)
            {
                [self.mTripDto.tripTagArray addObject:self.mTagDto];
            }
            else if(self.mTripDto.tripTagArray ==nil)
            {
                self.mTripDto.tripTagArray = [[NSMutableArray alloc]initWithCapacity:10];
                [self.mTripDto.tripTagArray addObject:self.mTagDto];
            }
            self.mTripDto.tripTagNo = [self.mTripDto.tripTagArray count];
            [tripService addTrekBaseInformation:self.mTripDto];
            
            [self removeAllPoints];
            [self loadAllPointsToTheMapView];
        }
    }
    
}

-(void)imageButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    TIGalleryViewController *viewController = [[TIGalleryViewController alloc]initWithArray:self.mTagImageArray andIndex:button.tag];
    
    [self.navigationController pushViewController:viewController animated:NO];
    
}

-(IBAction)clickPictureButtonClicked:(id)sender
{
    UIActionSheet *ActionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"You may take an image for this tag."
                                  delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Take New Image" otherButtonTitles:@"From Library", nil];
    
    
    [ActionSheet showInView:self.view];
}



-(void)getImagesForTripAndUpdateMasterArray
{
    if(self.mMasterImageArray!=nil)
    {
        [self.mMasterImageArray removeAllObjects];
        self.mMasterImageArray = nil;
    }
    self.mMasterImageArray = [[NSMutableArray alloc]initWithCapacity:10];
    
    TITripService *service = [[TITripService alloc]init];
    [service retrieveImageInfo:self.mMasterImageArray forTripId:self.mTripDto.tripId];
    
    TIImageDto *imageDto = [self.mMasterImageArray objectAtIndex:0];
}

-(void)getImagesForTagId:(NSString *)tagId andTripId:(NSString *)tripId
{
    if(self.mTagImageArray!=nil)
    {
        [self.mTagImageArray removeAllObjects];
        self.mTagImageArray = nil;
    }
    self.mTagImageArray = [[NSMutableArray alloc]initWithCapacity:2];
    
    for (int i=0; i<[self.mMasterImageArray count]; i++)
    {
        TIImageDto *imageDto = [self.mMasterImageArray objectAtIndex:i];
        if([imageDto.tagId isEqualToString:tagId])
        {
            [self.mTagImageArray addObject:imageDto];
        }
    }
}

-(void)loadImagesToScrollView
{
    int buttonStartPos = addImageButton.frame.origin.x + INITIAL_BUTTON_X + OFFSET;
    
    if(self.mButtonArray !=nil)
    {
        for(UIButton *button in self.mButtonArray)
        {
            [button removeFromSuperview];
        }
        
        [self.mButtonArray removeAllObjects];
        self.mButtonArray = nil;
    }
    
    self.mButtonArray = [[NSMutableArray alloc]initWithCapacity:2];
    
    for (int i=0;i<[self.mTagImageArray count];i++)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonStartPos, 7, 64, 64)];
        
        [button addTarget:self action:@selector(imageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        TIImageDto *imageDto = [self.mTagImageArray objectAtIndex:i];
        
        [button setImage:[UIImage imageWithContentsOfFile:[self getImageFilePathForName:imageDto.tagImage]] forState:UIControlStateNormal];
        
        button.tag = i;
        
        [buttonScrollView addSubview:button];
        
        [self.mButtonArray addObject:button];
        
        buttonStartPos+= INITIAL_BUTTON_X + OFFSET;
        
        
    }
    
    [buttonScrollView setContentSize:CGSizeMake(buttonStartPos, buttonScrollView.frame.size.height)];
    
}
-(void)displayTheScrollView:(BOOL)shouldDisplay
{
    switch (shouldDisplay) {
        case TRUE:
            if(!(buttonScrollView.frame.size.height == self.view.bounds.size.height-buttonScrollView.frame.size.height))
            {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.7];
                [UIView setAnimationDelay:0];
                [UIView setAnimationDelegate:self];
                buttonScrollView.frame = CGRectMake(0, self.view.bounds.size.height-buttonScrollView.frame.size.height, buttonScrollView.frame.size.width, buttonScrollView.frame.size.height);
                [UIView commitAnimations];
            }
            break;
        case FALSE:
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.7];
            [UIView setAnimationDelay:0];
            [UIView setAnimationDelegate:self];
            buttonScrollView.frame = CGRectMake(0, self.view.bounds.size.height+buttonScrollView.frame.size.height, buttonScrollView.frame.size.width, buttonScrollView.frame.size.height);
            [UIView commitAnimations];

        }
            break;
        default:
            break;
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{

    self.mImagePicker = [[UIImagePickerController alloc] init] ;
    self.mPickerLibrary = [[UIImagePickerController alloc]init];
    switch (buttonIndex)
    {
        case 0:
            
            [self.mImagePicker setDelegate:self];
            [self.mImagePicker.view setAlpha:1.0];
            [self.mImagePicker.navigationBar setBarStyle: UIBarStyleBlackTranslucent];
            [self.mImagePicker.navigationBar setTintColor:[UIColor lightGrayColor]];
            [self.mImagePicker.view setOpaque:YES];
            [self.mImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];            
            [self presentViewController:self.mImagePicker animated:YES completion:^(){}];
            
            break;
        case 1:
            self.mPickerLibrary = [[UIImagePickerController alloc] init];
            self.mPickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            self.mPickerLibrary.delegate = self;
            [self presentViewController:self.mPickerLibrary animated:YES completion:^(){}];
            
            break;
        case 2:
            
            
            break;
        default:
            break;
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    TITripService *service = [[TITripService alloc]init];
    TIImageDto *imageDto =  [[TIImageDto alloc]init];
    imageDto.tagId = self.mCurrentTagClicked.tagId;
    imageDto.tripId = self.mCurrentTagClicked.tripId;
    imageDto.tagImage = [self saveImageToDocumentsFolder:image];
    
    
    [self.mImagePicker dismissViewControllerAnimated:YES completion:^(){}];
    [self.mPickerLibrary dismissViewControllerAnimated:YES completion:^(){}];
    
    [service updateImageInfo:imageDto];
    [self getImagesForTripAndUpdateMasterArray];
    [self getImagesForTagId:self.mCurrentTagClicked.tagId andTripId:self.mCurrentTagClicked.tripId];
    [self loadImagesToScrollView];
}

-(NSString *)saveImageToDocumentsFolder:(UIImage *)image
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *dateId = [NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSince1970]];
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [[dateId componentsSeparatedByString:@"."]objectAtIndex:0]];
    
    NSString *jpgPath = [documentsDir stringByAppendingPathComponent:fileName];
    
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
    
    return fileName;
}

-(NSString *)getImageFilePathForName:(NSString *)imageFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:imageFileName];
}
@end
