//
//  SMLSyntaxError.m
//  Fragaria
//
//  Created by Viktor Lidholt on 4/9/13.
//
//

#import "SMLSyntaxError.h"

@implementation SMLSyntaxError

@synthesize line, character, length, description, code, hidden, warningStyle;
@synthesize errorLineHighlightColor = _errorLineHighlightColor;
@synthesize errorBackgroundHighlightColor = _errorBackgroundHighlightColor; // @todo: not yet implemented.
@synthesize errorForegroundHilightColor = _errorForegroundHilightColor;     // @todo: not yet implemented.

#pragma mark - Class Methods

+ (instancetype) errorWithDictionary:(NSDictionary *)dictionary;
{
    return [[[self class] alloc] initWithDictionary:dictionary];
}

+ (NSImage *)imageForWarningStyle:(MGSSyntaxErrorType)style
{
    // Note these are in order by MGSErrorType.
    NSArray *imageNames = @[@"messagesWarning", @"messagesAccess", @"messagesConfig", @"messagesDocument", @"messagesInfo", @"messagesWarning", @"messagesError", @"messagesPanic"];
    NSImage *warningImage = [[NSBundle bundleForClass:[self class]] imageForResource:imageNames[style]];
    [warningImage setSize:NSMakeSize(16.0, 16.0)];
    return warningImage;
}


#pragma mark - Instance Methods

- (instancetype)initWithDictionary:(NSDictionary *)errorDict
{
    if ((self = [super init]))
    {
        [self setValuesForKeysWithDictionary:errorDict];
    }
    return self;
}


#pragma mark - Property Accessors

- (void)setErrorLineHighlightColor:(NSColor *)errorLineHighlightColor
{
    _errorLineHighlightColor = errorLineHighlightColor;
}

- (NSColor*)errorLineHighlightColor
{
    if (_errorLineHighlightColor)
    {
        return _errorLineHighlightColor;
    }
    else
    {
        return [NSColor colorWithCalibratedRed:1 green:1 blue:0.7 alpha:1];
    }
}


- (NSImage *)warningImage
{
    return [[self class] imageForWarningStyle:self.warningStyle];
}

@end
