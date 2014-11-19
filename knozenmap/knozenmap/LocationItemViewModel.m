//
//  LocationItemViewModel.m
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import "LocationItemViewModel.h"

@implementation LocationItemViewModel

- (CLLocationCoordinate2D)getCoordinate {
    CLLocationCoordinate2D pinCoordinate;
    pinCoordinate.latitude = [self.lat doubleValue];
    pinCoordinate.longitude = [self.lon doubleValue];
    return pinCoordinate;
}

@end
