//
//  MGSFontToTextTransformer.m
//  Fragaria
//
//  Created by Jim Derry on 3/23/15.
//
//

#import "MGSColourToPlainTextTransformer.h"

/*
 *	There is precision loss for colors, of course, but we can control it
 *  a little bit. Using 8 bits is probably fine and gives nice 2 character
 *  hex codes that users are familiar with, but 16 and 32 could be used, too.
 *
 *  The system named colors require 32 bits for two-way transformations to be
 *  reliable, though, so see also NSColor+RGBCompare for a safe alternative
 *  for comparing colors via RGB value.
 */
#define COLOR_PRECISION (pow(2, 8)-1)


@implementation MGSColourToPlainTextTransformer


/*
 * + initialize
 */
+ (void)initialize
{
	[NSValueTransformer setValueTransformer:[[[self class] alloc] init] forName:NSStringFromClass([self class])];
}

/*
 * + transformedValueClass
 */
+ (Class)transformedValueClass
{
	return [NSColor class];
}


/*
 * + allowsReverseTransformation
 */
+ (BOOL)allowsReverseTransformation
{
	return YES;
}


/*
 * - transformedValue:
 */
- (id)transformedValue:(id)value
{
	NSColor *color = [value colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	NSAssert(color && [color isKindOfClass:[NSColor class]], @"Nil or non-color can't be used!");

	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	CGFloat red;
	CGFloat green;
	CGFloat blue;
	CGFloat alpha;
	[color getRed:&red green:&green blue:&blue alpha:&alpha];
	
	[dictionary setObject:[self hexValueForComponentValue:red] forKey:@"red"];
	[dictionary setObject:[self hexValueForComponentValue:green] forKey:@"green"];
	[dictionary setObject:[self hexValueForComponentValue:blue] forKey:@"blue"];
	[dictionary setObject:[self hexValueForComponentValue:alpha] forKey:@"alpha"];
	
	return dictionary;
}


/*
 * - reverseTransformedValue:
 */
-(id)reverseTransformedValue:(id)value
{
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:value];

	NSAssert(dictionary && [dictionary isKindOfClass:[NSDictionary class]], @"Nil or non-color can't be used!");
	
	CGFloat red = [self componentValueforHex:[dictionary objectForKey:@"red"]];
	CGFloat green = [self componentValueforHex:[dictionary objectForKey:@"green"]];
	CGFloat blue = [self componentValueforHex:[dictionary objectForKey:@"blue"]];
	CGFloat alpha = [self componentValueforHex:[dictionary objectForKey:@"alpha"]];
	
	return [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
}


/*
 * - hexValueForComponentValue
 *   I suppose this could be its own value transformer.
 */
- (NSString *)hexValueForComponentValue:(CGFloat)color
{
	NSString *result = [NSString stringWithFormat:@"%lx", (NSUInteger)(color * COLOR_PRECISION )];
	
	return result;
}


/*
 * - componentValueforHex
 *   I suppose this could be its own value transformer.
 */
- (CGFloat)componentValueforHex:(NSString *)hex
{
	unsigned int intVal;
	CGFloat floatVal;
	NSScanner *scanner = [NSScanner scannerWithString:hex];
	[scanner scanHexInt:&intVal];
	floatVal =  (CGFloat)((CGFloat)intVal / COLOR_PRECISION );
	floatVal = floatVal > 1.0 ? 1.0 : floatVal;
	floatVal = floatVal < 0.0 ? 0.0 : floatVal;
	return floatVal;
}

@end
