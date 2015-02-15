//
//  MGSSyntaxErrorController.m
//  Fragaria
//
//  Created by Jim Derry on 2/15/15.
//
//

#import "MGSSyntaxErrorController.h"
#import "SMLSyntaxError.h"

@implementation MGSSyntaxErrorController


+ (NSArray *)linesWithErrorsInArray:(NSArray *)errorArray
{
    errorArray = [[self class] sanitizedErrorsInArray:errorArray];
    return [[errorArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden == %@", @(NO)]] valueForKeyPath:@"@distinctUnionOfObjects.line"];
}


+ (NSUInteger)errorCountForLine:(NSInteger)line inArray:(NSArray *)errorArray
{
    errorArray = [[self class] sanitizedErrorsInArray:errorArray];
    return [[[errorArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(line == %@) AND (hidden == %@)", @(line), @(NO)]] valueForKeyPath:@"@count"] integerValue];
}


+ (SMLSyntaxError *)errorForLine:(NSInteger)line inArray:(NSArray *)errorArray
{
    errorArray = [[self class] sanitizedErrorsInArray:errorArray];
    MGSErrorType highestErrorLevel = [[[[self class] errorsForLine:line inArray:errorArray] valueForKeyPath:@"@max.warningStyle"] integerValue];
    NSArray* errors = [[self errorsForLine:line inArray:errorArray] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"warningStyle = %@", @(highestErrorLevel)]];

    return errors.firstObject;
}


+ (NSArray*)errorsForLine:(NSInteger)line inArray:(NSArray *)errorArray
{
    errorArray = [[self class] sanitizedErrorsInArray:errorArray];
    return [errorArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(line == %@) AND (hidden == %@)", @(line), @(NO)]];
}


+ (NSArray *)nonHiddenErrorsInArray:(NSArray*)errorArray
{
    errorArray = [[self class] sanitizedErrorsInArray:errorArray];
    return [errorArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden == %@", @(NO)]];
}


+ (NSArray *)sanitizedErrorsInArray:(NSArray*)errorArray
{
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[SMLSyntaxError class]];
    }];
    return [errorArray filteredArrayUsingPredicate:filter];
}


+ (NSDictionary *)errorDecorationsInArray:(NSArray *)errorArray
{
    return [[self class] errorDecorationsInArray:errorArray size:NSMakeSize(0.0, 0.0)];
}



+ (NSDictionary *)errorDecorationsInArray:(NSArray *)errorArray size:(NSSize)size
{
    errorArray = [[self class] sanitizedErrorsInArray:errorArray];
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    for (NSNumber *line in [[self class] linesWithErrorsInArray:errorArray])
    {
        NSImage *image = [[[self class] errorForLine:[line integerValue] inArray:errorArray] warningImage];
        if (size.height > 0.0 && size.width > 0)
        {
            [image setSize:size];
        }
        [result setObject:image forKey:line];
    }

    return result;
}


@end
