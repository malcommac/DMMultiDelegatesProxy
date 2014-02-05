//
//  DMMultiDelegatesProxy.m
//  MultiDelegatesProxyExample
//
//  Created by Daniele Margutti on 05/02/14.
//  Copyright (c) 2014 danielemargutti. All rights reserved.
//

#import "DMMultiDelegatesProxy.h"

@interface DMMultiDelegatesProxy () {
	NSMutableArray		*nonRetainedDelegates;
	NSValue				*nonRetainedMainDelegate;
}

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
    for (NSValue *nonRetainedValue in nonRetainedDelegates) {
        id delegateObj = nonRetainedValue.nonretainedObjectValue;
		return [[delegateObj class] instanceMethodSignatureForSelector:selector];
    }
	return nil;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    for (NSValue *nonRetainedValue in nonRetainedDelegates) {
        id delegateObj = nonRetainedValue.nonretainedObjectValue;
        if ([delegateObj respondsToSelector:aSelector])
            return YES;
    }
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
	
	for (NSValue *nonRetainedValue in nonRetainedDelegates) {
		id delegateObj = nonRetainedValue.nonretainedObjectValue;
		if ([delegateObj respondsToSelector:invocation.selector])
			[targetInvocation invokeWithTarget:delegateObj];
    }
}

#pragma mark - Properties -

- (void) setMainDelegate:(id)aMainDelegate {
	nonRetainedMainDelegate = [NSValue valueWithNonretainedObject:aMainDelegate];
}

- (id) mainDelegate {
	return nonRetainedMainDelegate.nonretainedObjectValue;
}

- (void)setDelegates:(NSArray *)delegates {
	nonRetainedDelegates = [[NSMutableArray alloc] initWithCapacity:delegates.count];
	for (id currentDelegate in delegates)
		[nonRetainedDelegates addObject:[NSValue valueWithNonretainedObject:currentDelegate]];
}

- (NSArray *) delegates {
	NSMutableArray *aDelegates = [[NSMutableArray alloc] init];
	for (NSValue *nonRetainedDelegate in nonRetainedDelegates)
		[aDelegates addObject:[nonRetainedDelegate nonretainedObjectValue]];
	return aDelegates;
}

@end
