//
//  FirstViewController.m
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import "LocationsViewController.h"

#import "ListTableViewController.h"
#import "MapViewController.h"
#import "LocationListViewModel.h"

typedef enum {
    kSegmentList,
    kSegmentMap
} Segment;

#define kUDSegmentKey @"segmentKey"

@interface LocationsViewController () <LocationListViewControllerDelegate>
@property (nonatomic) Segment currentSegment;
@property (nonatomic, strong) ListTableViewController *listVC;
@property (nonatomic, strong) MapViewController *mapVC;
@property (nonatomic, strong) LocationListViewModel *locationListVM;
@end

@implementation LocationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationListVM = [[LocationListViewModel alloc] init];
    [self loadSystemPreferenceSegment];
    [self loadListVC];
    [self loadMapVC];
    [self updateSystemPreferenceSegment];
    [self.locationListVM getLocationData];
}

- (void)loadListVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ListView" bundle:[NSBundle mainBundle]];
    self.listVC = [sb instantiateInitialViewController];
    self.listVC.navigateDelegate = self;
    self.listVC.locationListVM = self.locationListVM;
    [self.listVC view];
}

- (void)loadMapVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MapView" bundle:[NSBundle mainBundle]];
    self.mapVC = [sb instantiateInitialViewController];
    self.mapVC.locationListVM = self.locationListVM;
    [self.mapVC view];
}

- (void)loadSystemPreferenceSegment {
    NSNumber *segmentIndex = [[NSUserDefaults standardUserDefaults] objectForKey:kUDSegmentKey];
    self.currentSegment = [segmentIndex intValue];
    [self.segmentControl setSelectedSegmentIndex:self.currentSegment];
}

- (void)updateSystemPreferenceSegment {
    if (self.container.subviews.count == 0) {

    } else {
        NSArray *subviews = self.container.subviews;
        for (UIView *view in subviews) {
            [view removeFromSuperview];
        }
        [self.listVC removeFromParentViewController];
        [self.mapVC removeFromParentViewController];
    }

    if (self.currentSegment == kSegmentList) {
        self.listVC.view.frame = self.container.bounds;
        self.listVC.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.container addSubview:self.listVC.view];
        [self addChildViewController:self.listVC];
    } else {
        self.mapVC.view.frame = self.container.bounds;
        self.mapVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.container addSubview:self.mapVC.view];
        [self addChildViewController:self.mapVC];
    }
}

- (IBAction)didToggleSegment:(id)sender {
    self.currentSegment = (Segment)self.segmentControl.selectedSegmentIndex;
    [self updateSystemPreferenceSegment];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.segmentControl.selectedSegmentIndex] forKey:kUDSegmentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LocationListViewControllerDelegate
- (void)navigateToLocation:(LocationItemViewModel *)itemVM {
    [self.segmentControl setSelectedSegmentIndex:kSegmentMap];
    self.currentSegment = kSegmentMap;
    [self updateSystemPreferenceSegment];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:kSegmentMap] forKey:kUDSegmentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.mapVC navigateTo:itemVM];
}

@end
