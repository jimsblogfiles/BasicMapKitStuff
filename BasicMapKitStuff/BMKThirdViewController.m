//
//  BMKThirdViewController.m
//  BasicMapKitStuff
//
//  Created by James Border on 6/14/13.
//  Copyright (c) 2013 James Border. All rights reserved.
//

#import "BMKThirdViewController.h"
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"

@interface BMKThirdViewController ()

@end

@implementation BMKThirdViewController

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint longPressPoint = [recognizer locationInView:self.view];
        [self dropPinAtPoint:longPressPoint];
    }

}

- (void)updatePolygon {

    CLLocationCoordinate2D *points = malloc(sizeof(CLLocationCoordinate2D) * _itemsArray.count);
    NSUInteger i = 0;

    for (MyAnnotation *pin in _itemsArray) {
        points[i] = pin.coordinate;
        i++;
    }
    
    [_mapView removeOverlay:_polygon];
    _polygon = [MKPolygon polygonWithCoordinates:points count:_itemsArray.count];
    [_mapView addOverlay:_polygon];
    
}

- (void) dropPinAtPoint: (CGPoint) pointToConvert {

    CLLocationCoordinate2D convertedPoint = [_mapView convertPoint: pointToConvert
                                                      toCoordinateFromView: self.view];
    
    NSString *pinTitle = [NSString stringWithFormat: @"Pin number %i", _itemsArray.count];
    NSString *subCoordinates = [NSString stringWithFormat: @"%f, %f", convertedPoint.latitude, convertedPoint.longitude];
    
    MyAnnotation *droppedPin = [[MyAnnotation alloc] initWithCoordinate: convertedPoint
                                                                  title: pinTitle
                                                               subtitle: subCoordinates];
    
    [_mapView addAnnotation:droppedPin];
    [_itemsArray addObject:droppedPin];
    
    [self updatePolygon];

}

- (void)removePins {

    [_mapView removeAnnotations:_mapView.annotations];
    [_itemsArray removeAllObjects];
    [_mapView removeOverlay:_polygon];
    [self updatePolygon];

}

#pragma mark -
#pragma mark

- (NSString *)coordinates {

    if (_itemsArray.count < 3) {
        return @"Minimum of 3 vertices requried to make polygon.";
    }
    
    NSString *masterString = @"\n{ \"type\": \"MultiPolygon\",\n \"coordinates\": [\n[[";
    for (MyAnnotation *pin in _itemsArray) {
        masterString = [masterString stringByAppendingFormat: @"[%f, %f],\n", pin.coordinate.longitude, pin.coordinate.latitude];
    }
    
    // GeoJSON requires that the first and last vertices be identical
    MyAnnotation *firstPin = [_itemsArray objectAtIndex:0];
    masterString = [masterString stringByAppendingFormat: @"[%f, %f],\n", firstPin.coordinate.longitude, firstPin.coordinate.latitude];
    masterString = [masterString stringByAppendingString: @"]]\n]\n}\n"];
    masterString = [masterString stringByReplacingOccurrencesOfString: @"],\n]]" withString: @"]]]"];
    
    return masterString;
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {

    if (_polygonView && _polygonView.polygon == _polygon) {
        return _polygonView;
    }
    
    _polygonView = [[MKPolygonView alloc] initWithPolygon:_polygon];
    [_polygonView setFillColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.3f]];
    [_polygonView setStrokeColor:[UIColor colorWithRed:0 green:1 blue:0 alpha:0.3f]];
    [_polygonView setLineWidth:1.0f];

    return _polygonView;

}

#pragma mark -
#pragma mark

- (void)setUpGesture {
    
    _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(handleLongPress:)];
    [_longPress setDelegate:self];

    [self.view addGestureRecognizer:_longPress];
    
}

#pragma mark -
#pragma mark

- (void)viewDidLoad {

    [super viewDidLoad];

	// Do any additional setup after loading the view.
    
    [_mapView setDelegate:self];
    [_mapView setUserInteractionEnabled: YES];
    [_mapView setScrollEnabled: YES];
  
    [self setUpGesture];
    
    _itemsArray = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
