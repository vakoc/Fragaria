//
//  NSColor+RGBCompare.m
//  Fragaria
//
//  Created by Jim Derry on 3/23/15.
//
//

#import "NSColor+RGBCompare.h"
#import "MGSColourToPlainTextTransformer.h"


@implementation NSColor (MGSRGBCompare)


/*
 * - isEqualToRGBOfColor:
 */
- (BOOL)isEqualToRGBOfColour:(NSColor *)colour;
{
	NSValueTransformer *xformer = [NSValueTransformer valueTransformerForName:@"MGSColourToPlainTextTransformer"];

	NSDictionary *result1 = [xformer transformedValue:self];
	NSDictionary *result2 = [xformer transformedValue:colour];
	
    return [result1 isEqual:result2];
}

@end
