//
//  NSURLConnectionProvider.h
//  AddressBookSample
//
//  Created by Fahad Muntaz on 2015-05-16.
//  Copyright (c) 2015 Fahad Muntaz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NSURLConnectionProviderCompletionHandler)
            (NSURLResponse *response, NSData *data, NSError *connectionError);

@interface NSURLConnectionProvider : NSObject

- (void) sendAsynchronousRequest:(NSURLRequest *) request queue:(NSOperationQueue *)operationQueue  completionHandler:(NSURLConnectionProviderCompletionHandler)completionHandler;
@end
