//
//  FirstViewController.m
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import "FirstViewController.h"

#import "ListTableViewController.h"
#import "MapViewController.h"


typedef enum {
    kSegmentList,
    kSegmentMap
} Segment;

#define kUDSegmentKey @"segmentKey"

@interface FirstViewController ()
@property (nonatomic) Segment currentSegment;
@property (nonatomic, strong) ListTableViewController *listVC;
@property (nonatomic, strong) MapViewController *mapVC;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadSystemPreferenceSegment];
    [self loadListVC];
    [self loadMapVC];
    [self updateSystemPreferenceSegment];

}

- (void)loadListVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"ListView" bundle:[NSBundle mainBundle]];
    self.listVC = [sb instantiateInitialViewController];
    [self.listVC loadView];
}

- (void)loadMapVC {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MapView" bundle:[NSBundle mainBundle]];
    self.mapVC = [sb instantiateInitialViewController];
    [self.mapVC loadView];
}

- (void)loadSystemPreferenceSegment {
    NSNumber *segmentIndex = [[NSUserDefaults standardUserDefaults] objectForKey:kUDSegmentKey];
    self.currentSegment = [segmentIndex intValue];
    [self.segmentControl setSelectedSegmentIndex:self.currentSegment];
}

- (void)updateSystemPreferenceSegment {
    if (self.container.subviews.count == 0) {
        NSLog(@"great");
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
}

- (void)loadCurrentSegmentControl {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end