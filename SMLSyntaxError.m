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
@synthesize errorForegroundHighlightColor = _errorForegroundHighlightColor;
@synthesize warningImage = _warningImage;

// to be deprecated
@synthesize code; // deprecated; separate line as reminder to remove.

#pragma mark - Class Methods

+ (NSImage *)defaultImageForWarningLevel:(float)level
{
	NSString *imageName;

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
    return warningImage;
}

+ (instancetype) errorWithDictionary:(NSDictionary *)dictionary
{
    return [[[self class] alloc] initWithDictionary:dictionary];
}


#pragma mark - Instance Methods

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if ((self = [self init])) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    
    self.errorLineHighlightColor = [NSColor colorWithCalibratedRed:1 green:1 blue:0.7 alpha:1];
    self.errorBackgroundHighlightColor = [NSColor orangeColor];
    self.errorForegroundHighlightColor = [NSColor whiteColor];
    self.line = 1;
    self.character = 1;
    self.warningLevel = kMGSErrorCategoryWarning;
    
    return self;
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


-(void)setErrorForegroundHighlightColor:(NSColor *)errorForegroundHighlightColor
{
    errorForegroundHighlightColor = errorForegroundHighlightColor;
}

- (NSColor *)errorForegroundHighlightColor
{
    if (!_errorForegroundHighlightColor)
    {
        _errorForegroundHighlightColor = [NSColor whiteColor];
    }

    return _errorForegroundHighlightColor;
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
