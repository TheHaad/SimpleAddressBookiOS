//
//  NSURLConnectionProvider.m
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-16.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import "NSURLConnectionProvider.h"

@implementation NSURLConnectionProvider

- (void) sendAsynchronousRequest:(NSURLRequest *) request queue:(NSOperationQueue *)operationQueue  completionHandler:(NSURLConnectionProviderCompletionHandler)completionHandler {
    [NSURLConnection sendAsynchronousRequest:request queue:operationQueue completionHandler:completionHandler];
}
@end
