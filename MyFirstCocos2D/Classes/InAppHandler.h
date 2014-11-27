//
//  InAppHandler.h
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 13/10/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface InAppHandler : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

@end
