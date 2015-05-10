//
//  MGSFontToTextTransformer.m
//  Fragaria
//
//  Created by Jim Derry on 3/15/15.
//
//

#import "MGSFontToTextTransformer.h"

@implementation MGSFontToTextTransformer

+ (Class)transformedValueClass
{
    return [NSString class];
}


+ (BOOL)allowsReverseTransformation
{
    return NO;
}


- (id)transformedValue:(id)value
{
    NSFont *font;

	if (value)
	{
		if (![value isKindOfClass:[NSFont class]])
		{
			font = [NSUnarchiver unarchiveObjectWithData:value];
		}
		else
		{
			font = value;
		}
		return [NSString stringWithFormat:@"%@ - %.0fpt", [font fontName], [font pointSize]];
	}
	else
	{
		return NSLocalizedStringFromTableInBundle(@"Not Available", nil, [NSBundle bundleForClass:[self class]],  @"Font editing is not enabled in the editor settings.");
	}

}

@end
