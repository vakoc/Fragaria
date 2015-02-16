//
//  SMLSyntaxError.m
//  Fragaria
//
//  Created by Viktor Lidholt on 4/9/13.
//
//

#import "SMLSyntaxError.h"


float const kMGSErrorCategoryAccess = 100;
float const kMGSErrorCategoryConfig = 200;
float const kMGSErrorCategoryDocument = 300;
float const kMGSErrorCategoryInfo = 400;
float const kMGSErrorCategoryWarning = 500;
float const kMGSErrorCategoryError = 600;
float const kMGSErrorCategoryPanic = FLT_MAX;
float const kMGSErrorCategoryDefault = 500;


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

+ (NSImage *)defaultImageForWarningLevel:(float)level
{
	NSString *imageName;
	int result = (int)ceil(level/100.0);
	NSLog(@"%f, %d", level, result);
	switch ((int)ceil(level/100.0))
	{
		case 1:
			imageName  = @"messagesAccess";
			break;
		case 2:
			imageName  = @"messagesConfig";
			break;
		case 3:
			imageName  = @"messagesDocument";
			break;
		case 4:
			imageName  = @"messagesInfo";
			break;
		case 0:
		case 5:
			imageName  = @"messagesWarning";
			break;
		case 6:
			imageName  = @"messagesError";
			break;
		default:
			imageName  = @"messagesPanic";
			break;
	}

    NSImage *warningImage = [[NSBundle bundleForClass:[self class]] imageForResource:imageName];
	[warningImage setName:imageName]; // better for unit testing, name is otherwise nil.
    return warningImage;
}

+ (instancetype) errorWithDictionary:(NSDictionary *)dictionary
{
    return [[[self class] alloc] initWithDictionary:dictionary];
}


#pragma mark - Instance Methods

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [super init]))
    {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}


#pragma mark - Deprecated Class Methods


+ (NSImage *)imageForWarningStyle:(float)style
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
        _warningImage = [[self class] defaultImageForWarningLevel:self.warningLevel];
    }

    return _warningImage;
}


#pragma mark - Deprecated Properties


- (void)setWarningStyle:(float)style
{
    self.warningLevel = style;
}

- (float)warningStyle
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
    self.errorLineHighlightColor = customBackgroundColor;
}

- (NSColor *)customBackgroundColor
{
    return self.errorLineHighlightColor;
}

@end
