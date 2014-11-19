//
//  MapViewController.m
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <LocationListViewModelDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) MKCoordinateRegion savedRegion;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setLocationListVM:(LocationListViewModel *)locationListVM {
    _locationListVM = locationListVM;
    _locationListVM.mapDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigateTo:(LocationItemViewModel *)itemVM {
    [self centerZoomToLocation:itemVM.getCoordinate];
}

- (void)addAnotation:(LocationItemViewModel *)itemVM {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = itemVM.getCoordinate;
    annotation.title = itemVM.address;
    [self.mapView addAnnotation:annotation];
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

- (void)masterZoom {

    NSArray *itemVMs = self.locationListVM.locationViewModelList;

    CLLocationCoordinate2D southWest = [[itemVMs firstObject] getCoordinate];
    CLLocationCoordinate2D northEast = southWest;

    for (int i = 1; i < itemVMs.count; i++) {
        CLLocationCoordinate2D coordinate = [itemVMs[i] getCoordinate];
        southWest.latitude = MIN(southWest.latitude, coordinate.latitude);
        southWest.longitude = MIN(southWest.longitude, coordinate.longitude);

        northEast.latitude = MAX(northEast.latitude, coordinate.latitude);
        northEast.longitude = MAX(northEast.longitude, coordinate.longitude);
    }


    CLLocation *locSouthWest = [[CLLocation alloc] initWithLatitude:southWest.latitude longitude:southWest.longitude];
    CLLocation *locNorthEast = [[CLLocation alloc] initWithLatitude:northEast.latitude longitude:northEast.longitude];

    // This is a diag distance (if you wanted tighter you could do NE-NW or NE-SE)
    CLLocationDistance meters = [locSouthWest getDistanceFrom:locNorthEast];

    MKCoordinateRegion region;
    region.center.latitude = (southWest.latitude + northEast.latitude) / 2.0;
    region.center.longitude = (southWest.longitude + northEast.longitude) / 2.0;
    region.span.latitudeDelta = meters / 111319.5;
    region.span.longitudeDelta = 0.0;

    self.savedRegion = [self.mapView regionThatFits:region];
    [self.mapView setRegion:self.savedRegion animated:YES];
}

#pragma mark - LocationListViewModelDelegate

- (void)reloadLocationData {
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (LocationItemViewModel *itemVM in self.locationListVM.locationViewModelList) {
        [self addAnotation:itemVM];
    }
//    [self navigateTo:[self.locationListVM.locationViewModelList firstObject]];
    [self masterZoom];
}

- (void)stopLoadingState {

}

@end
