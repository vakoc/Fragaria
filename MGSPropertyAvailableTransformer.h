//
//  MGSPropertyAvailableTransformer.h
//  Fragaria
//
//  Created by Jim Derry on 3/15/15.
//
//

#import <Foundation/Foundation.h>

/**
 *  This values transformer converts NSRaisesForNotApplicableKeysBindingOption
 *  into YES or NO, allowing for simple disabling of controls in IB for
 *  paths that are not found.
 **/
@interface MGSPropertyAvailableTransformer : NSValueTransformer

@end
