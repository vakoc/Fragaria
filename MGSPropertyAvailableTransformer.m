//
//  MGSPropertyAvailableTransformer.m
//  Fragaria
//
//  Created by Jim Derry on 3/15/15.
//
//

#import "MGSPropertyAvailableTransformer.h"

@implementation MGSPropertyAvailableTransformer

+ (Class)transformedValueClass
{
    return [NSNumber class];
}


+ (BOOL)allowsReverseTransformation
{
    return NO;
}


- (id)transformedValue:(id)value
{
    return @(value != nil);
}

@end
