//
//  BMKThirdViewController.h
//  BasicMapKitStuff
//
//  Created by James Border on 6/14/13.
//  Copyright (c) 2013 James Border. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface BMKThirdViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>{}

@property (strong, nonatomic) MKPolygon *polygon;
@property (strong, nonatomic) MKPolygonView *polygonView;
@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

