//
//  MGSTemporaryPreferencesObserver.h
//  Fragaria
//
//  Created by Jim Derry on 2/27/15.
//
//

#import <Cocoa/Cocoa.h>

@class MGSFragaria;

/**
 *  This class is a *temporary* class for Fragaria that replaces the observers
 *  spread throughout Fragaria into a central location while separating them
 *  into proper properties.
 *
 *  This class is highly inefficient and is only a bandage for separating properties!
 *  Don't develop except for removing observers and such in Fragaria.
 **/
@interface MGSTemporaryPreferencesObserver : NSObject

/**
 *  Designated initializer.
 **/
- (instancetype)initWithFragaria:(MGSFragaria *)fragaria;


@end
