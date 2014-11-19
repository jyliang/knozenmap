//
//  ListTableViewController.m
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import "ListTableViewController.h"

@interface ListTableViewController ()

@end

@implementation ListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor lightGrayColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLocations)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLocationListVM:(LocationListViewModel *)locationListVM {
    _locationListVM = locationListVM;
    _locationListVM.listDelegate = self;
}

- (void)getLatestLocations {
    [self.locationListVM getLocationData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locationListVM.locationViewModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    LocationItemViewModel *itemVM = [self.locationListVM.locationViewModelList objectAtIndex:indexPath.item];
    cell.textLabel.text = itemVM.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationItemViewModel *itemVM = [self.locationListVM.locationViewModelList objectAtIndex:indexPath.item];
    [self.navigateDelegate navigateToLocation:itemVM];
}



#pragma mark - LocationListViewModelDelegate

- (void)reloadLocationData {
    [self.refreshControl endRefreshing];
}

- (void)stopLoadingState {
    [self.tableView reloadData];
}

@end
