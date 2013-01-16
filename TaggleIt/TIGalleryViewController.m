//
//  TIGalleryViewController.m
//  TaggleIt
//
//  Created by Sadasivan Arun on 12/16/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import "TIGalleryViewController.h"
#import "TIImageDto.h"
@interface TIGalleryViewController ()
{
    IBOutlet UIScrollView *imageScrollView;
}

@property (nonatomic, strong)NSMutableArray *mImageTagArray;
@property (nonatomic, assign)NSInteger mImageIndex;


-(void)getImagesFromDB;
-(void)addImagesToScrollView;
-(NSString *)getImageFilePathForName:(NSString *)imageFileName;

@end

@implementation TIGalleryViewController
@synthesize mImageTagArray,mImageIndex;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithArray:(NSMutableArray *)imageTagArray andIndex:(NSInteger)imageIndex
{
    self = [super init];
    if(self)
    {
        self.mImageTagArray = imageTagArray;
        self.mImageIndex = imageIndex;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitleForNavigationBar:@"Gallery"];
    
    imageScrollView.pagingEnabled = YES;
    imageScrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 548);
    
    [imageScrollView setContentSize:CGSizeMake(320 * [self.mImageTagArray count],480)];
    
    [imageScrollView setContentMode:UIViewContentModeTop];
    
    [self addImagesToScrollView];
    
    [imageScrollView scrollRectToVisible:CGRectMake(320*self.mImageIndex, imageScrollView.frame.origin.y, imageScrollView.frame.size.width, imageScrollView.frame.size.height) animated:NO];
    
    //[imageScrollView ]
    
    
    NSLog(@"imageScrollview height = %f",self.view.bounds.size.height);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addImagesToScrollView
{
    int buttonStartPos = 0;
    
    CGRect boundsRect = [[UIScreen mainScreen] bounds];
    
    for (int i=0;i<[self.mImageTagArray count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(buttonStartPos, 0, self.view.bounds.size.width,436)];
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
                
        TIImageDto *imageDto = [self.mImageTagArray objectAtIndex:i];
        
        imageView.image = [UIImage imageWithContentsOfFile:[self getImageFilePathForName:imageDto.tagImage]];
        
        [imageScrollView addSubview:imageView];
        
        buttonStartPos= (320*(i+1));
    }
}

-(NSString *)getImageFilePathForName:(NSString *)imageFileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    return [documentsDir stringByAppendingPathComponent:imageFileName];
}
@end
