//
//  MGSSyntaxErrors.m
//  Fragaria
//
//  Created by Jim Derry on 2/14/15.
//
//


#import "MGSSyntaxErrors.h"
#import "SMLSyntaxError.h"


@implementation MGSSyntaxErrors

@synthesize syntaxErrors = _syntaxErrors;

#pragma mark - Instance Methods - Instantiation


- (instancetype)initWithErrorsFromArray:(NSArray *)errors
{
    if ((self = [super init]))
    {
        self.syntaxErrors = errors;
    }
    return self;
}


#pragma mark - Setting and clearing errors


- (void)addErrorFromDictionary:(NSDictionary*)error
{
    [self addError:[SMLSyntaxError errorWithDictionary:error]];
}


- (void)addError:(id<MGSSyntaxError>)error
{
    if (self.syntaxErrors)
    {
        self.syntaxErrors = [self.syntaxErrors arrayByAddingObject:error];
    }
    else
    {
        self.syntaxErrors = [NSArray arrayWithObject:error];
    }
}


#pragma mark - Accessing error data

- (NSArray *)linesWithErrors
{
    return [[self.syntaxErrors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden == %@", @(NO)]] valueForKeyPath:@"@distinctUnionOfObjects.line"];

}


- (NSUInteger)errorCountForLine:(NSInteger)line
{
    NSUInteger result = [[[self.syntaxErrors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(line == %@) AND (hidden == %@)", @(line), @(NO)]] valueForKeyPath:@"@count"] integerValue];
    NSLog(@"%lu", (unsigned long)result);
    return [[[self.syntaxErrors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(line == %@) AND (hidden == %@)", @(line), @(NO)]] valueForKeyPath:@"@count"] integerValue];
}


- (id<MGSSyntaxError>)errorForLine:(NSInteger)line
{
    MGSSyntaxErrorType highestErrorLevel = [[[self errorsForLine:line] valueForKeyPath:@"@max.warningStyle"] integerValue];
    NSArray* errors = [[self errorsForLine:line] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"warningStyle = %@", @(highestErrorLevel)]];

    return errors.firstObject;
}


- (NSArray*)errorsForLine:(NSInteger)line
{
    return [self.syntaxErrors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(line == %@) AND (hidden == %@)", @(line), @(NO)]];
}


- (NSArray *)nonHiddenErrors
{
    return [self.syntaxErrors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden == %@", @(NO)]];
}


#pragma mark - Properties


- (void)setSyntaxErrors:(NSArray *)syntaxErrors
{
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject conformsToProtocol:@protocol(MGSSyntaxError)];
    }];
    _syntaxErrors = [syntaxErrors filteredArrayUsingPredicate:filter];
}

- (NSArray *)syntaxErrors
{
    return _syntaxErrors;
}


@end
