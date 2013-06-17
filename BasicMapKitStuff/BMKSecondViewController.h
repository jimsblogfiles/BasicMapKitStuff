//
//  BMKSecondViewController.h
//  BasicMapKitStuff
//
//  Created by James Border on 6/14/13.
//  Copyright (c) 2013 James Border. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BMKSecondViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>{}

@property (nonatomic, assign) double coordLat;
@property (nonatomic, assign) double coordLong;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;

@end
