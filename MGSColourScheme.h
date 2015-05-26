//
//  MGSColourScheme.h
//  Fragaria
//
//  Created by Jim Derry on 3/16/15.
//
//

#import <Foundation/Foundation.h>


/**
 *   MGSColourScheme defines a colour scheme for MGSColourSchemeController.
 *   @discuss Property names (except for displayName) are identical
 *   to the MGSFragariaView property names.
 **/
@interface MGSColourScheme : NSObject

#pragma mark - Initializers
/// @name Initializers

/** 
 *  Initializes a new colour scheme instance from a dictionary.
 *  @param dictionary The dictionary representation of the plist file that
 *  defines the color scheme. This is a standard NSDictionary that may contain
 *  NSColor values, and is not property list.
 **/
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 *  Initializes a new colour scheme instance from a file.
 *  @param file The plist file which contains the colour scheme values.
 **/
- (instancetype)initWithFile:(NSString *)file;

/**
 *  Initializes a new colour scheme instance with default properties.
 **/
- (instancetype)init;


#pragma mark - Class Methods
/// @name Class Methods

/** An array of all of the properties of this class that constitute a scheme. */
+ (NSArray *) propertiesOfScheme;


/// @name General Properties

/** Indicates if this definition was loaded from a bundle. */
@property (nonatomic, assign) BOOL loadedFromBundle;

/** Indicates the complete and path and filename this instance was loaded
    from (if any). */
@property (nonatomic, strong) NSString *sourceFile;


/** An NSDictionary representation of the Colour Scheme Properties */
@property (nonatomic, assign, readonly) NSDictionary *dictionaryRepresentation;

/** An valid property list NSDictionary representation of the Colour Scheme
    properties.
    @discuss These are NSData objects already archived for disk. */
@property (nonatomic, assign, readonly) NSDictionary *propertyListRepresentation;


#pragma mark - Colour Scheme Properties
/// @name Colour Scheme Properties

/** Display name of the color scheme. */
@property (nonatomic, strong) NSString *displayName;

/** Base text color. */
@property (nonatomic, strong) NSColor *textColor;

/** Editor background color. */
@property (nonatomic, strong) NSColor *backgroundColor;

/** Syntax error background highlighting color. */
@property (nonatomic, strong) NSColor *defaultSyntaxErrorHighlightingColour;

/** Editor invisible characters color. */
@property (nonatomic, strong) NSColor *textInvisibleCharactersColour;

/** Editor current line highlight color. */
@property (nonatomic, strong) NSColor *currentLineHighlightColour;

/** Editor insertion point color. */
@property (nonatomic, strong) NSColor *insertionPointColor;

/** Syntax color for attributes. */
@property (nonatomic, strong) NSColor *colourForAttributes;

/** Syntax color for autocomplete. */
@property (nonatomic, strong) NSColor *colourForAutocomplete;

/** Syntax color for commands. */
@property (nonatomic, strong) NSColor *colourForCommands;

/** Syntax color for comments. */
@property (nonatomic, strong) NSColor *colourForComments;

/** Syntax color for instructions. */
@property (nonatomic, strong) NSColor *colourForInstructions;

/** Syntax color for keywords. */
@property (nonatomic, strong) NSColor *colourForKeywords;

/** Syntax color for numbers. */
@property (nonatomic, strong) NSColor *colourForNumbers;

/** Syntax color for strings. */
@property (nonatomic, strong) NSColor *colourForStrings;

/** Syntax color for variables. */
@property (nonatomic, strong) NSColor *colourForVariables;

/** Should attributes be colored? */
@property (nonatomic, assign) BOOL coloursAttributes;

/** Should autocomplete be colored? */
@property (nonatomic, assign) BOOL coloursAutocomplete;

/** Should commands be colored? */
@property (nonatomic, assign) BOOL coloursCommands;

/** Should comments be colored? */
@property (nonatomic, assign) BOOL coloursComments;

/** Should instructions be colored? */
@property (nonatomic, assign) BOOL coloursInstructions;

/** Should keywords be colored? */
@property (nonatomic, assign) BOOL coloursKeywords;

/** Should numbers be colored? */
@property (nonatomic, assign) BOOL coloursNumbers;

/** Should strings be colored? */
@property (nonatomic, assign) BOOL coloursStrings;

/** Should variables be colored? */
@property (nonatomic, assign) BOOL coloursVariables;


#pragma mark - Instance Methods
/// @name Instance Methods

/** Indicates if two schemes have the same colour settings.
    @param scheme The scheme that you want to compare to the receiver. */
- (BOOL)isEqualToScheme:(MGSColourScheme *)scheme;

/** Sets its values from a plist file.
    @param file The complete path and file to read. */
- (void)propertiesLoadFromFile:(NSString *)file;

/** Writes the object as a plist to the given file.
    @param file The complete path and file to write. */
- (BOOL)propertiesSaveToFile:(NSString *)file;


@end
