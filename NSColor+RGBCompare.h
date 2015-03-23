//
//  NSColor+RGBCompare.h
//  Fragaria
//
//  Created by Jim Derry on 3/23/15.
//
//

#import <Foundation/Foundation.h>

@interface NSColor (RGBCompare)


/**
 *  Compares NSColors via their RGB values in order to compensate
 *  for imprecision due to translation between hex and floats.
 **/
- (BOOL)isEqualToRGBOfColour:(NSColor *)colour;

@end
