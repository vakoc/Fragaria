//
//  MGSSyntaxDefinition.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 03/02/15.
//
//

#import <Foundation/Foundation.h>
#import "SMLAutoCompleteDelegate.h"

@class MGSFragaria;

/**
 *  This class defines a single instance of a syntax definition.
 **/
@interface MGSSyntaxDefinition : NSObject <SMLAutoCompleteDelegate>


@property (readonly) NSString *functionDefinition;              ///< An expression that defines what a function is.
@property (readonly) NSString *removeFromFunction;              ///< Content that should be removed from a function.
@property (readonly) NSString *secondString;                    ///< Secondary string delimiter.
@property (readonly) NSString *firstString;                     ///< Primary string delimiter.
@property (readonly) NSString *beginCommand;                    ///< Delimiter for the start of a command.
@property (readonly) NSString *endCommand;                      ///< Delimiter for the end of a command.
@property (readonly) NSSet *keywords;                           ///< An set of words that are considered keywords.
@property (readonly) NSSet *autocompleteWords;                  ///< A set of words that can be used for autocompletion.
@property (readonly) NSString *beginInstruction;                ///< Delimiter for the start of an instruction.
@property (readonly) NSString *endInstruction;                  ///< Delimiter for the end of an instruction.
@property (readonly) NSCharacterSet *beginVariableCharacterSet; ///< Characters that may start a variable.
@property (readonly) NSCharacterSet *endVariableCharacterSet;   ///< Characters that may terminate a variable.
@property (readonly) NSString *firstSingleLineComment;          ///< Primary starting delimiter for single line comments.
@property (readonly) NSString *secondSingleLineComment;         ///< Secondary starting delimiter for single line comments.
@property (readonly) NSMutableArray *singleLineComments;        ///< The collection of single line comments.
@property (readonly) NSMutableArray *multiLineComments;         ///< The collection of multiline comments.
@property (readonly) NSString *beginFirstMultiLineComment;      ///< Primary starting delimiter for multiline comments.
@property (readonly) NSString*endFirstMultiLineComment;         ///< Primary ending delimiter for multiline comments.
@property (readonly) NSString*beginSecondMultiLineComment;      ///< Secondary starting delimiter for multiline comments.
@property (readonly) NSString*endSecondMultiLineComment;        ///< Secondary ending delimiter for multiline comments.
@property (readonly) NSCharacterSet *keywordStartCharacterSet;  ///< Characters that may start a keyword.
@property (readonly) NSCharacterSet *keywordEndCharacterSet;    ///< Characters that may terminate a keyword.
@property (readonly) NSCharacterSet *attributesCharacterSet;    ///< Characters that attributes may used.
@property (readonly) NSCharacterSet *letterCharacterSet;        ///< Characters that constitute letters.
@property (readonly) NSCharacterSet *numberCharacterSet;        ///< Characters that constitute numbers.
@property (readonly) NSCharacterSet *nameCharacterSet;          ///< Characters that may be used in a name.
@property (readonly) BOOL syntaxDefinitionAllowsColouring;      ///< Determines if colouring for this syntax definition is allowed.
@property (readonly) BOOL recolourKeywordIfAlreadyColoured;     ///< Indicates whether or not keywords should be recolored.
@property (readonly) BOOL keywordsCaseSensitive;                ///< Indicates whether or not keywords are case-sensitive.
@property (readonly) NSString *firstStringPattern;              ///< The regex pattern for identifying primary strings.
@property (readonly) NSString *secondStringPattern;             ///< The regex pattern for identifying secondary strings.
@property (readonly) NSString *firstMultilineStringPattern;     ///< The regex pattern for identifying multiline strings (primary).
@property (readonly) NSString *secondMultilineStringPattern;    ///< The regex pattern for identifying multiline strings (secondary).
@property (readonly) unichar decimalPointCharacter;             ///< The character considered as a decimal separator.

/** A dictionary which describes this syntax definition. */
@property (readonly) NSDictionary *syntaxDictionary;


/** Designated initializer.
 *  Initializes a new syntax definition object from a dictionary object, usually
 *  read from a plist in the framework bundle.
 *  @param syntaxDictionary The dictionary representation of the plist file that
 *  defines the syntax. */
- (instancetype)initFromSyntaxDictionary:(NSDictionary *)syntaxDictionary;

/** Autocomplete delegate main method. Returns as autocomplete words the 
 * keywordsAndAutocompleteWords array. */
- (NSArray*)completions;


@end


