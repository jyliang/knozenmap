//
//  MapViewController.h
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationItemViewModel.h"
#import "LocationListViewModel.h"

@interface MapViewController : UIViewController

@property (nonatomic, weak) LocationListViewModel *locationListVM;

- (void)navigateTo:(LocationItemViewModel *)itemVM;

@end
