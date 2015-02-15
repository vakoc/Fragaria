//
//  SMLSyntaxError.m
//  Fragaria
//
//  Created by Viktor Lidholt on 4/9/13.
//
//

#import "SMLSyntaxError.h"

@implementation SMLSyntaxError

// automatic
@synthesize line, character, length, description, hidden, warningLevel;

// manual
@synthesize errorLineHighlightColor = _errorLineHighlightColor;
@synthesize errorBackgroundHighlightColor = _errorBackgroundHighlightColor;
@synthesize errorForegroundHilightColor = _errorForegroundHilightColor;
@synthesize warningImage = _warningImage;

// to be deprecated
@synthesize code; // deprecated; separate line as reminder to remove.

#pragma mark - Class Methods

+ (NSImage *)defaultImageForWarningLevel:(MGSErrorType)level
{
    // Note these are in order by MGSErrorType. @todo: Bounds checking.
    NSArray *imageNames = @[@"messagesWarning", @"messagesAccess", @"messagesConfig", @"messagesDocument", @"messagesInfo", @"messagesWarning",@"messagesError", @"messagesPanic"];
    NSImage *warningImage = [[NSBundle bundleForClass:[self class]] imageForResource:imageNames[level]];
    return warningImage;
}


+ (NSImage *)imageForWarningStyle:(MGSErrorType)style
{
    return [[self class] defaultImageForWarningLevel:style];
}


#pragma mark - Property Accessors

- (void)setErrorLineHighlightColor:(NSColor *)errorLineHighlightColor
{
    _errorLineHighlightColor = errorLineHighlightColor;
}

- (NSColor *)errorLineHighlightColor
{
    if (!_errorLineHighlightColor)
    {
        _errorLineHighlightColor = [NSColor colorWithCalibratedRed:1 green:1 blue:0.7 alpha:1];
    }

    return _errorLineHighlightColor;
}


-(void)setErrorBackgroundHighlightColor:(NSColor *)errorBackgroundHighlightColor
{
    _errorBackgroundHighlightColor = errorBackgroundHighlightColor;
}

- (NSColor *)errorBackgroundHighlightColor
{
    if (!_errorBackgroundHighlightColor)
    {
        _errorBackgroundHighlightColor = [NSColor orangeColor];
    }

    return _errorBackgroundHighlightColor;
}


-(void)setErrorForegroundHilightColor:(NSColor *)errorForegroundHilightColor
{
    _errorForegroundHilightColor = errorForegroundHilightColor;
}

- (NSColor *)errorForegroundHilightColor
{
    if (!_errorForegroundHilightColor)
    {
        _errorForegroundHilightColor = [NSColor whiteColor];
    }

    return _errorForegroundHilightColor;
}


- (void)setWarningImage:(NSImage *)warningImage
{
    _warningImage = warningImage;
}

- (NSImage *)warningImage
{
    if (!_warningImage)
    {
        _warningImage = [[self class] defaultImageForWarningLevel:self.warningStyle];
    }

    return _warningImage;
}


#pragma mark - Deprecated Properties


- (void)setWarningStyle:(MGSErrorType)style
{
    self.warningLevel = style;
}

- (MGSErrorType)warningStyle
{
    return self.warningLevel;
}


- (void)setHideWarning:(BOOL)hideWarning
{
    self.hidden = hideWarning;
}

- (BOOL)hideWarning
{
    return self.hidden;
}


-(void)setCustomBackgroundColor:(NSColor *)customBackgroundColor
{
    self.errorBackgroundHighlightColor = customBackgroundColor;
}

- (NSColor *)customBackgroundColor
{
    return self.errorBackgroundHighlightColor;
}

@end
