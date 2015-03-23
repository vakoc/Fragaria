//
//  MGSFontToTextTransformer.m
//  Fragaria
//
//  Created by Jim Derry on 3/23/15.
//
//

#import "MGSColourToPlainTextTransformer.h"

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
	NSString *result = [NSString stringWithFormat:@"%lx", (NSUInteger)(color * 255.0)];
	
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
	floatVal =  (CGFloat)((CGFloat)intVal / 255);
	floatVal = floatVal > 1.0 ? 1.0 : floatVal;
	floatVal = floatVal < 0.0 ? 0.0 : floatVal;
	return floatVal;
}

@end
