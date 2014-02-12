//
//  DMMultiDelegatesProxy.m
//  MultiDelegatesProxyExample
//
//  Created by Daniele Margutti on 05/02/14.
//  Copyright (c) 2014 danielemargutti. All rights reserved.
//

#import "DMMultiDelegatesProxy.h"

@interface DMMultiDelegatesProxy () { }

@property (nonatomic,strong)	NSPointerArray *delegatesPointerArray;

@end

@implementation DMMultiDelegatesProxy

#pragma mark - Initialization -

+ (id) newProxyWithMainDelegate:(id) aMainDelegate other:(NSArray *) aDelegates {
	return [[DMMultiDelegatesProxy alloc] initWithMainDelegate:aMainDelegate other:aDelegates];
}

- (id)initWithMainDelegate:(id) aMainDelegate other:(NSArray *) aDelegates {
    [self setDelegates:aDelegates];
	[self setMainDelegate:aMainDelegate];
    return self;
}

- (id) newProxyWithDelegates:(NSArray *) aDelegates {
	[self setDelegates:aDelegates];
	return self;
}

#pragma mark - Message Forwarding -

- (NSMethodSignature *) methodSignatureForSelector:(SEL)selector {
	return [[self.mainDelegate class] instanceMethodSignatureForSelector:selector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	if ([self.mainDelegate respondsToSelector:aSelector])
		return YES;
    for (id delegateObj in self.delegatesPointerArray.allObjects)
        if ([delegateObj respondsToSelector:aSelector])
            return YES;
    return NO;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	// check if method can return something
    BOOL methodReturnSomething = (![[NSString stringWithCString:invocation.methodSignature.methodReturnType encoding:NSUTF8StringEncoding] isEqualToString:@"v"]);
    
	// send invocation to the main delegate and use it's return value
	if ([self.mainDelegate respondsToSelector:invocation.selector])
		[invocation invokeWithTarget:self.mainDelegate];
	
	// make another fake invocation with the same method signature and send the same messages to the other delegates (ignoring return values)
	NSInvocation *targetInvocation = invocation;
	if (methodReturnSomething) {
		targetInvocation = [NSInvocation invocationWithMethodSignature:invocation.methodSignature];
		[targetInvocation setSelector:invocation.selector];
	}
	
	for (id delegateObj in self.delegatesPointerArray.allObjects) {
		if ([delegateObj respondsToSelector:invocation.selector])
			[targetInvocation invokeWithTarget:delegateObj];
    }
}

#pragma mark - Properties -

- (void)setDelegates:(NSArray *)aNewDelegates {
	self.delegatesPointerArray = [NSPointerArray weakObjectsPointerArray];
    [aNewDelegates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.delegatesPointerArray addPointer:(void *)obj];
    }];
}

- (NSArray *) delegates {
	return self.delegatesPointerArray.allObjects;
}

@end
