//
//  DMMultiDelegatesProxy.h
//  MultiDelegatesProxyExample
//
//  Created by Daniele Margutti on 05/02/14.
//  Copyright (c) 2014 danielemargutti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMMultiDelegatesProxy : NSProxy

/**
 *  Set delegates which receive messages from an object.
 *  @warning Delegate objects are not retained!
 */
@property (nonatomic,strong)	NSArray		*delegates;

/**
 *  Main delegate is like any other delegate but it's used to get the value for method which need something to return
 */
@property (nonatomic,strong)	id			 mainDelegate;

/**
 *  Allocate a new proxy object which can handle multiple delegates. Set it as delegate for your target class.
 *
 *  @param aMainDelegate main delegate will be used for all method which need to get a return value
 *  @param aDelegates    other delegates will receive all events but when a method needs to return something returned value is ignored
 *
 *  @return a new proxy object. You are responsible of it's ownership.
 */
+ (id) newProxyWithMainDelegate:(id) aMainDelegate other:(NSArray *) aDelegates;

@end
