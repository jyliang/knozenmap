//
//  UserDataManager.m
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import "LocationListViewModel.h"

@interface LocationListViewModel ()

@property (nonatomic, strong) NSOperationQueue *parseQueue;
@property (nonatomic, strong) NSMutableArray *locationViewModelList;

@end

@implementation LocationListViewModel

- (void)getLocationData {
    static NSString *feedURLString = @"https://s3-us-west-2.amazonaws.com/jyliang/locations.xml";
//    static NSString *feedURLString = @"http://dev1.knowadozen.com/site_media/locations.xml";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:feedURLString]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (connectionError != nil) {
            [self handleError:connectionError];
        } else {
//            response.
        }
    }];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)handleError:(NSError *)error {
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
