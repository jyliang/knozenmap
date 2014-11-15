//
//  LocationItemViewModel.h
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationItemViewModel : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic) NSTimeInterval timestamp;

@end
