//
//  InAppHandler.m
//  MyFirstCocos2D
//
//  Created by Balagurubaran on 13/10/2014.
//  Copyright (c) 2014 First. All rights reserved.
//

#import "InAppHandler.h"
#import <StoreKit/StoreKit.h>

@implementation InAppHandler{
    SKProductsRequest * _productsRequest;
    // 4
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}


- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
    }
    return self;
}


- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
    
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}
@end
