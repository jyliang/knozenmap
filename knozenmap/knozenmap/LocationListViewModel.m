//
//  UserDataManager.m
//  knozenmap
//
//  Created by Jason Liang on 11/16/14.
//  Copyright (c) 2014 Jason Liang. All rights reserved.
//

#import "LocationListViewModel.h"
#import <AFNetworking/AFNetworking.h>
#import "LocationItemViewModel.h"

@interface LocationListViewModel () <NSXMLParserDelegate>

@property (nonatomic, strong) NSOperationQueue *queue;

@property(nonatomic, strong) NSString *elementName;
@property(nonatomic, strong) NSMutableString *outstring;

@property (nonatomic, strong) LocationItemViewModel *currentItemViewModel;

@end

@implementation LocationListViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)getLocationData {
    static NSString *feedURLString = @"https://s3-us-west-2.amazonaws.com/jyliang/locations.xml";
//    static NSString *feedURLString = @"http://dev1.knowadozen.com/site_media/locations.xml";

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:feedURLString]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
        [XMLParser setShouldProcessNamespaces:YES];
        XMLParser.delegate = self;
        [XMLParser parse];
        [self.delegate stopLoadingState];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleError:error];
        [self.delegate stopLoadingState];
    }];

    [self.queue addOperation:operation];
    [operation start];
}

- (void)handleError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Location"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.locationViewModelList = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.elementName = qName;
    if ([qName isEqualToString:@"last_seen_at"]) {
        self.currentItemViewModel = [[LocationItemViewModel alloc] init];
}
    self.outstring = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.elementName)
        return;

    [self.outstring appendFormat:@"%@", string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

    if ([qName isEqualToString:@"last_seen_at"]) {
        [self.locationViewModelList addObject:self.currentItemViewModel];
        self.currentItemViewModel = nil;
    } else if ([qName isEqualToString:@"locations"]) {

    } else if (qName) {
        if ([qName isEqualToString:@"address"]) {
            self.currentItemViewModel.address = self.outstring;
        } else if ([qName isEqualToString:@"lat"]) {
            self.currentItemViewModel.lat = self.outstring;
        } else if ([qName isEqualToString:@"lon"]) {
            self.currentItemViewModel.lon = self.outstring;
        } else if ([qName isEqualToString:@"timestamp"]) {
            self.currentItemViewModel.timestamp = [self.outstring doubleValue];
        }
    }

    self.elementName = nil;
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    [self.delegate reloadLocationData];
}

@end
