//
//  NSColor+RGBCompare.h
//  Fragaria
//
//  Created by Jim Derry on 3/23/15.
//
//

#import <Foundation/Foundation.h>

/**
 *  The MGSRBGCompare category allows checking of colours via RGB values.
 **/
@interface NSColor (MGSRGBCompare)


/**
 *  Compares NSColors via their RGB values in order to compensate
 *  for imprecision due to translation between hex and floats.
 *  @param colour The color that the receiver should check against.
 **/
- (BOOL)isEqualToRGBOfColour:(NSColor *)colour;

@end
