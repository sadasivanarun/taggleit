//
//  TIAddEditTagsViewController.h
//  TaggleIt
//
//  Created by Sadasivan Arun on 11/28/12.
//  Copyright (c) 2012 Sadasivan Arun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TIAbstractViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TITripDto.h"
#import "TITagDto.h"
@interface TIAddEditTagsViewController : TIAbstractViewController<MKAnnotation, MKMapViewDelegate, CLLocationManagerDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong) NSString *mTripId;
@property (nonatomic, strong) TITripDto *mTripDto;



- (id)initWithTrip:(TITripDto*)tripDto;
@end
