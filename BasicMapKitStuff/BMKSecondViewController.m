//
//  BMKSecondViewController.m
//  BasicMapKitStuff
//
//  Created by James Border on 6/14/13.
//  Copyright (c) 2013 James Border. All rights reserved.
//

#import "BMKSecondViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@interface BMKSecondViewController ()

@end

@implementation BMKSecondViewController

- (IBAction)actionSendCoordinateToMaps:(id)sender {

	Class mapItemClass = [MKMapItem class];
    
	if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {

        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_coordLat, _coordLong);

		MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];

		MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
		[mapItem setName:@"Selected Pin"];
		[mapItem openInMapsWithLaunchOptions:nil];
        
	}
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {

    static NSString *identifier = @"MyAnnotation";
	
    if ([annotation isKindOfClass:[MyAnnotation class]]) {
        
		// using MKAnnotationView instead of an MKPinAnnotationView takes care of the pin showing issue
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];

        MyAnnotation *anno = annotation;
		_coordLat = anno.coordinate.latitude;
		_coordLong = anno.coordinate.longitude;

        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
		UIButton* calloutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[calloutButton setFrame:CGRectMake(0, 0, 30, 30)];
        [calloutButton setTitle:@"X" forState:UIControlStateNormal];
        [calloutButton setShowsTouchWhenHighlighted:YES];

		[calloutButton addTarget:self
						 action:@selector(actionSendCoordinateToMaps:)
			   forControlEvents:UIControlEventTouchUpInside];

        
		UIView *calloutView = [[UIView alloc] initWithFrame:CGRectMake(0,0,30,30)];
		annotationView.image = [UIImage imageNamed:@"CustomPin.png"];
		annotationView.annotation = annotation;
        
		[calloutView addSubview:calloutButton];

		annotationView.rightCalloutAccessoryView = calloutView;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
        return annotationView;
		
    }
    
    return nil;
	
}

#pragma mark -
#pragma mark

- (void)dropPinAtPoint:(CGPoint)pointToConvert {
    
    CLLocationCoordinate2D convertedPoint = [_mapView convertPoint: pointToConvert toCoordinateFromView: self.view];
    
    //    NSString *pinTitle = [NSString stringWithFormat: @"Pin number %i", (self.pointsArray.count + 1)];
    NSString *subCoordinates = [NSString stringWithFormat: @"%f, %f", convertedPoint.latitude, convertedPoint.longitude];
    
    MyAnnotation *droppedPin = [[MyAnnotation alloc] initWithCoordinate: convertedPoint
                                                                  title: @"Title"
                                                               subtitle: subCoordinates];
    
    [_mapView addAnnotation:droppedPin];
	
//    if([_mapView.annotations count]>0){
//        [_mapView removeAnnotations:_mapView.annotations];
//    }
    
//    if([_mapView.overlays count]>0){
//        [_mapView removeOverlays:_mapView.overlays];
//    }

}

- (IBAction)actionDropRandomPin:(id)sender {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(_mapView.centerCoordinate.latitude, _mapView.centerCoordinate.longitude);
    
    if (CLLocationCoordinate2DIsValid(coordinate)) {
        
        MyAnnotation *droppedPin = [[MyAnnotation alloc] initWithCoordinate: coordinate
                                                                      title: @"PIN"
                                                                   subtitle: @"Coord"];
        
        [_mapView addAnnotation:droppedPin];
        
    }
    
}

#pragma mark -
#pragma mark

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
	
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint longPressPoint = [recognizer locationInView:self.view];
        [self dropPinAtPoint:longPressPoint];
    }
	
}

- (void)viewDidLoad {

    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    if (_mapView) {

        [_mapView setDelegate:self];
        
        [_mapView setShowsUserLocation:YES];

        self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget: self
                                                                       action: @selector(handleLongPress:)];
        self.longPress.delegate = self;

        [self.view addGestureRecognizer:self.longPress];
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
