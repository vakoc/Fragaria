//
//  MGSColourScheme.m
//  Fragaria
//
//  Created by Jim Derry on 3/16/15.
//
//

#import "MGSColourScheme.h"
#import "MGSUserDefaultsDefinitions.h"
#import "MGSColourToPlainTextTransformer.h"


@interface MGSColourScheme ()

@property (nonatomic, assign, readwrite) NSDictionary *dictionaryRepresentation;
@property (nonatomic, assign, readwrite) NSDictionary *propertyListRepresentation;

+ (NSSet *) propertiesAll;
+ (NSSet *) propertiesOfTypeBool;
+ (NSSet *) propertiesOfTypeColor;
+ (NSSet *) propertiesOfTypeString;

@end

@implementation MGSColourScheme


#pragma mark - Initializers


/*
 * - initWithDictionary:
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
{
    if ((self = [self init]))
    {
        [self setDefaults];
        self.dictionaryRepresentation = dictionary;
    }

    return self;
}


/*
 * - initWithFile:
 */
- (instancetype)initWithFile:(NSString *)file
{
    if ((self = [self init]))
    {
        [self setDefaults];
        [self propertiesLoadFromFile:file];
    }

    return self;
}


/*
 * - init
 */
- (instancetype)init
{
	if ((self = [super init]))
	{
		[self setDefaults];
	}
	
	return self;
}


#pragma mark - General Properties


/*
 * @property dictionaryRepresentation
 * Publicly this is readonly, but we'll use the setter of this "representation"
 * internally in order to set the values from a dictionary.
 */
- (void)setDictionaryRepresentation:(NSDictionary *)dictionaryRepresentation
{
    [self setValuesForKeysWithDictionary:dictionaryRepresentation];
}

- (NSDictionary *)dictionaryRepresentation
{
    return [self dictionaryWithValuesForKeys:[[[self class] propertiesAll] allObjects]];
}


/*
 * @property propertyListRepresentation
 * Publicly this is readonly, but we'll use the setter of this "representation"
 * internally in order to set the values from a property list.
 */
- (void)setPropertyListRepresentation:(NSDictionary *)propertyListRepresentation
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	NSValueTransformer *xformer = [NSValueTransformer valueTransformerForName:@"MGSColourToPlainTextTransformer"];

    for (NSString *key in [propertyListRepresentation allKeys])
    {
        if ([[[self class] propertiesOfTypeString] containsObject:key])
        {
			NSString *object = [propertyListRepresentation objectForKey:key];
            [dictionary setObject:object forKey:key];
        }
        if ([[[self class] propertiesOfTypeColor] containsObject:key])
        {
			NSColor *object = [xformer reverseTransformedValue:[propertyListRepresentation objectForKey:key]];
            [dictionary setObject:object forKey:key];
        }
        if ([[[self class] propertiesOfTypeBool] containsObject:key])
        {
			NSNumber *object = [propertyListRepresentation objectForKey:key];
            [dictionary setObject:object forKey:key];
        }
    }
    
    self.dictionaryRepresentation = dictionary;
}

- (NSDictionary *)propertyListRepresentation
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	NSValueTransformer *xformer = [NSValueTransformer valueTransformerForName:@"MGSColourToPlainTextTransformer"];

    for (NSString *key in [self.dictionaryRepresentation allKeys])
    {
        if ([[[self class] propertiesOfTypeString] containsObject:key])
        {
            [dictionary setObject:[self.dictionaryRepresentation objectForKey:key] forKey:key];
        }
        if ([[[self class] propertiesOfTypeColor] containsObject:key])
        {
			[dictionary setObject:[xformer transformedValue:[self.dictionaryRepresentation objectForKey:key]] forKey:key];
        }
        if ([[[self class] propertiesOfTypeBool] containsObject:key])
        {
            [dictionary setObject:[self.dictionaryRepresentation objectForKey:key] forKey:key];
        }
    }
    
    return dictionary;
}


#pragma mark - Instance Methods


/*
 * - isEqualToScheme:
 */
- (BOOL)isEqualToScheme:(MGSColourScheme *)scheme
{
    for (NSString *key in [[self class] colourProperties])
    {
		if (![[self valueForKey:key] isEqual:[scheme valueForKey:key]])
		{
//			NSLog(@"KEY=%@ and SELF=%@ and EXTERNAL=%@", key, [self valueForKey:key], [scheme valueForKey:key] );
			return NO;
		}
    }

    return YES;
}


/*
 * - propertiesLoadFromFile:
 */
- (void)propertiesLoadFromFile:(NSString *)file
{
	file = [file stringByStandardizingPath];
	NSAssert([[NSFileManager defaultManager] fileExistsAtPath:file], @"File %@ not found!", file);
	
    NSDictionary *fileContents = [NSDictionary dictionaryWithContentsOfFile:file];
	NSAssert(fileContents, @"Error reading file %@", file);

    self.propertyListRepresentation = fileContents;
    self.loadedFromFile = file;
}


/*
 * - propertiesSaveToFile:
 */
- (BOOL)propertiesSaveToFile:(NSString *)file
{
    file = [file stringByStandardizingPath];
	NSDictionary *props = self.propertyListRepresentation;
	return [props writeToFile:file atomically:YES];
}


#pragma mark - Category and Private


/*
 * - setDefaults
 */
- (void)setDefaults
{
    // Use the built-in defaults instead of reinventing wheels.
    NSDictionary *defaults = [MGSUserDefaultsDefinitions fragariaDefaultsDictionary];

	self.loadedFromBundle = NO;
	
    self.displayName = NSLocalizedString(@"Custom Settings", @"Name for Custom Settings scheme.");

    self.textColor = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsTextColor]];
    self.backgroundColor = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsBackgroundColor]];
    self.defaultSyntaxErrorHighlightingColour = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsDefaultErrorHighlightingColor]];

	self.textInvisibleCharactersColour = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsTextInvisibleCharactersColour]];
	self.currentLineHighlightColour = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsCurrentLineHighlightColour]];
	self.insertionPointColor = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsInsertionPointColor]];

    self.colourForAttributes = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsColourForAttributes]];
    self.colourForAutocomplete = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsColourForAutocomplete]];
    self.colourForCommands = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsColourForCommands]];
    self.colourForComments = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsColourForComments]];
    self.colourForInstructions = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsColourForInstructions]];
    self.colourForKeywords = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsColourForKeywords]];
    self.colourForNumbers = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsColourForNumbers]];
    self.colourForStrings = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsColourForStrings]];
    self.colourForVariables = [NSUnarchiver unarchiveObjectWithData:defaults[MGSFragariaDefaultsColourForVariables]];

    self.coloursAttributes = [defaults[MGSFragariaDefaultsColoursAttributes] boolValue];
    self.coloursAutocomplete = [defaults[MGSFragariaDefaultsColoursAutocomplete ] boolValue];
    self.coloursCommands = [defaults[MGSFragariaDefaultsColoursCommands] boolValue];
    self.coloursComments = [defaults[MGSFragariaDefaultsColoursComments] boolValue];
    self.coloursInstructions = [defaults[MGSFragariaDefaultsColoursInstructions] boolValue];
    self.coloursKeywords = [defaults[MGSFragariaDefaultsColoursKeywords] boolValue];
    self.coloursNumbers = [defaults[MGSFragariaDefaultsColoursNumbers] boolValue];
    self.coloursStrings = [defaults[MGSFragariaDefaultsColoursStrings] boolValue];
    self.coloursVariables = [defaults[MGSFragariaDefaultsColoursVariables] boolValue];
}


/*
 * + propertiesAll
 */
+ (NSSet *)propertiesAll
{
	NSSet *result = [[[self class] propertiesOfTypeString] setByAddingObjectsFromSet:self.propertiesOfTypeColor];
	result = [result setByAddingObjectsFromSet:[[self class] propertiesOfTypeBool]];
	return result;
}


/*
 * + propertiesOfTypeBool
 */
+ (NSSet*)propertiesOfTypeBool
{
	return [NSSet setWithArray:
			@[MGSFragariaDefaultsColoursAttributes, MGSFragariaDefaultsColoursAutocomplete, MGSFragariaDefaultsColoursCommands,
			  MGSFragariaDefaultsColoursComments, MGSFragariaDefaultsColoursInstructions, MGSFragariaDefaultsColoursKeywords,
			  MGSFragariaDefaultsColoursNumbers, MGSFragariaDefaultsColoursStrings, MGSFragariaDefaultsColoursVariables
			  ]];
}


/*
 * + propertiesOfTypeColor
 */
+ (NSSet *)propertiesOfTypeColor
{
	return [NSSet setWithArray:
			@[MGSFragariaDefaultsTextColor, MGSFragariaDefaultsBackgroundColor, MGSFragariaDefaultsDefaultErrorHighlightingColor,
              MGSFragariaDefaultsTextInvisibleCharactersColour, MGSFragariaDefaultsCurrentLineHighlightColour, MGSFragariaDefaultsInsertionPointColor,
              MGSFragariaDefaultsColourForAttributes, MGSFragariaDefaultsColourForAutocomplete, MGSFragariaDefaultsColourForCommands,
              MGSFragariaDefaultsColourForComments, MGSFragariaDefaultsColourForInstructions, MGSFragariaDefaultsColourForKeywords,
              MGSFragariaDefaultsColourForNumbers, MGSFragariaDefaultsColourForStrings, MGSFragariaDefaultsColourForVariables,
			  ]];
}


/*
 * + propertiesOfTypeString
 */
+ (NSSet *)propertiesOfTypeString
{
	return [NSSet setWithArray:@[@"displayName"]];
}


/*
 * + colourProperties
 */
+ (NSArray *)colourProperties
{
	return [[self.propertiesOfTypeColor setByAddingObjectsFromSet:self.propertiesOfTypeBool] allObjects];
}


@end
