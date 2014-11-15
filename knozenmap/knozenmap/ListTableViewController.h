//
//  ListTableViewController.h
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationListViewModel.h"
#import "LocationItemViewModel.h"


@protocol LocationListViewControllerDelegate <NSObject>

- (void)navigateToLocation:(LocationItemViewModel *)itemVM;

@end

@interface ListTableViewController : UITableViewController <LocationListViewModelDelegate>

@property (nonatomic, weak) id<LocationListViewControllerDelegate> navigateDelegate;
@property (nonatomic, weak) LocationListViewModel *locationListVM;

@end
