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

@end

@interface LocationListViewModel : NSObject

@property (nonatomic, weak) id<LocationListViewModelDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *locationViewModelList;

- (void)getLocationData;

@end
