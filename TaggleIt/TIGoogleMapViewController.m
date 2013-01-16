//
//  TIGoogleMapViewController.m
//  TaggleIt
//
//  Created by Sadasivan Arun on 12/16/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import "TIGoogleMapViewController.h"
#import "TIMyLocation.h"
#define URLMAINSCHEME @"https://maps.google.com/maps?"

@interface TIGoogleMapViewController ()
{
    IBOutlet UIWebView *googleMapView;
}
@property(nonatomic, strong)NSMutableArray *mAnnotationArray;


-(NSString *)generateUrlLinkForGoogle;

@end

@implementation TIGoogleMapViewController
@synthesize mAnnotationArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithAnnotationArray:(NSMutableArray *)annotationArray
{
    self = [super init];
    if(self)
    {
        self.mAnnotationArray = annotationArray;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitleForNavigationBar:@"Directions"];
    
    NSString *urlString = [self generateUrlLinkForGoogle];
    
    NSLog(@"%@",urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [googleMapView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)generateUrlLinkForGoogle
{
    NSString *saddr, *daddr;
    
    NSString *urlString=URLMAINSCHEME;
    NSMutableArray *remainingLocs;
    if ([self.mAnnotationArray count]>1) {
        TIMyLocation *myLocation = [self.mAnnotationArray objectAtIndex:1];
        saddr = [NSString stringWithFormat:@"saddr=(%lf,%lf)",myLocation.coordinate.latitude,myLocation.coordinate.longitude];
        
        urlString = [urlString stringByAppendingFormat:@"%@",saddr];
    }
    

    
    if ([self.mAnnotationArray count]>2) {
        TIMyLocation *myLocation = [self.mAnnotationArray objectAtIndex:2];
        daddr = [NSString stringWithFormat:@"&daddr=(%lf,%lf)",myLocation.coordinate.latitude,myLocation.coordinate.longitude];
        
        urlString = [urlString stringByAppendingFormat:@"%@",daddr];
    }
    
    
    
    if([self.mAnnotationArray count]>3)
    {
        remainingLocs = [[NSMutableArray alloc]initWithCapacity:3];
        for(int i = 3 ; i <[self.mAnnotationArray count]; i++ )
        {
            TIMyLocation *myLocation = [self.mAnnotationArray objectAtIndex:i];
            NSString *to = [NSString stringWithFormat:@"+to:(%lf,%lf)",myLocation.coordinate.latitude, myLocation.coordinate.longitude];
            urlString = [urlString stringByAppendingFormat:@"%@",to];
        }
    }
    
    return urlString;
}

@end
