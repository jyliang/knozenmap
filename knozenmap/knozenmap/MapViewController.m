//
//  MapViewController.m
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigateTo:(LocationItemViewModel *)itemVM {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self addAnotation:itemVM];
}

- (void)addAnotation:(LocationItemViewModel *)itemVM {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude = [itemVM.lat doubleValue];
    pinCoordinate.longitude = [itemVM.lon doubleValue];
    annotation.coordinate = pinCoordinate;
    annotation.title = itemVM.address;
    [self.mapView addAnnotation:annotation];
    [self centerZoomToLocation:pinCoordinate];
}

- (void)centerZoomToLocation:(CLLocationCoordinate2D) pinCoordinate {
    float spanX = 0.00725;
    float spanY = 0.00725;
    MKCoordinateRegion region;
    region.center.latitude = pinCoordinate.latitude;
    region.center.longitude = pinCoordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setCenterCoordinate:pinCoordinate animated:YES];
    [self.mapView setRegion:region animated:YES];
}

@end
