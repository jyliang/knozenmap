//
//  UserDataManager.h
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LocationListViewModelDelegate <NSObject>

- (void)reloadLocationData;
- (void)stopLoadingState;

@end

@interface LocationListViewModel : NSObject

@property (nonatomic, weak) id<LocationListViewModelDelegate> listDelegate;
@property (nonatomic, weak) id<LocationListViewModelDelegate> mapDelegate;

@property (nonatomic, strong) NSMutableArray *locationViewModelList;

- (void)getLocationData;

@end
