//
//  BMKFirstViewController.m
//  BasicMapKitStuff
//
//  Created by James Border on 6/14/13.
//  Copyright (c) 2013 James Border. All rights reserved.
//

#import "BMKFirstViewController.h"
#import <MapKit/MapKit.h>

@interface BMKFirstViewController ()

@end

@implementation BMKFirstViewController

#define MAXIMUM_ZOOM 20

- (IBAction)actionDirectionsToCurrentLocation:(id)sender {
    
	Class mapItemClass = [MKMapItem class];
    
	if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        
		CLLocationCoordinate2D coordinate = _mapView.userLocation.coordinate;
		MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
		MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
		[mapItem setName:@"Current Location"];
        
		// Pass the map item to the Maps app
		[mapItem openInMapsWithLaunchOptions:nil];
        
	}
    
}

- (IBAction)actionZoomToCurrentLocation:(id)sender {
    
    if (_mapView.showsUserLocation == NO) {

        [_mapView setShowsUserLocation:YES];

    }
    
    if ((_mapView.userLocation)&&(CLLocationCoordinate2DIsValid(_mapView.userLocation.coordinate))) {

        MKCoordinateRegion mapRegion;
        mapRegion.center = _mapView.userLocation.coordinate;
        mapRegion.span = MKCoordinateSpanMake(0.1, 0.1);
        [_mapView setRegion:mapRegion animated: YES];
        
    } else {

        NSLog(@"Invalid region!");

    }
    
}

- (IBAction)actionMapType:(id)sender {
    
    switch (_mapType) {

        case 0:
            [_mapView setMapType:MKMapTypeHybrid];
            _mapType++;
            break;

        case 1:
            [_mapView setMapType:MKMapTypeSatellite];
            _mapType++;
            break;

        case 2:
            [_mapView setMapType:MKMapTypeStandard];
            _mapType = 0;
            break;
            
        default:
            _mapType = 0;
            break;

    }

}

- (IBAction)actionGetCurrentZoomLevel:(id)sender {
    
    NSUInteger zoomLevel = MAXIMUM_ZOOM; // MAXIMUM_ZOOM is 20 with MapKit
    MKZoomScale zoomScale = _mapView.visibleMapRect.size.width / _mapView.frame.size.width; //MKZoomScale is just a CGFloat typedef
    double zoomExponent = log2(zoomScale);
    zoomLevel = (NSUInteger)(MAXIMUM_ZOOM - ceil(zoomExponent));

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Alert"
                                                    message: [NSString stringWithFormat:@"Zoom Level:%i",zoomLevel]
                                                   delegate: self
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];

    [alert show];

}


#pragma mark -
#pragma mark

- (void)viewDidLoad
{
    
    [super viewDidLoad];

	// Do any additional setup after loading the view, typically from a nib.
    
    if (_mapView) {
        
        [_mapView setShowsUserLocation:YES];
        
    }    
 
    _mapType = 0;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
