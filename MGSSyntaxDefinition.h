//
//  MGSSyntaxDefinition.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 03/02/15.
//
//

#import <Foundation/Foundation.h>
#import "ICUPattern.h"


@interface MGSSyntaxDefinition : NSObject

@property (readonly) NSString *functionDefinition;
@property (readonly) NSString *removeFromFunction;
@property (readonly) NSString *secondString;
@property (readonly) NSString *firstString;
@property (readonly) NSString *beginCommand;
@property (readonly) NSString *endCommand;
@property (readonly) NSSet *keywords;
@property (readonly) NSSet *autocompleteWords;
@property (readonly) NSArray *keywordsAndAutocompleteWords;
@property (readonly) NSString *beginInstruction;
@property (readonly) NSString *endInstruction;
@property (readonly) NSCharacterSet *beginVariableCharacterSet;
@property (readonly) NSCharacterSet *endVariableCharacterSet;
@property (readonly) NSString *firstSingleLineComment;
@property (readonly) NSString *secondSingleLineComment;
@property (readonly) NSMutableArray *singleLineComments;
@property (readonly) NSMutableArray *multiLineComments;
@property (readonly) NSString *beginFirstMultiLineComment;
@property (readonly) NSString*endFirstMultiLineComment;
@property (readonly) NSString*beginSecondMultiLineComment;
@property (readonly) NSString*endSecondMultiLineComment;
@property (readonly) NSCharacterSet *keywordStartCharacterSet;
@property (readonly) NSCharacterSet *keywordEndCharacterSet;
@property (readonly) NSCharacterSet *attributesCharacterSet;
@property (readonly) NSCharacterSet *letterCharacterSet;
@property (readonly) NSCharacterSet *numberCharacterSet;
@property (readonly) NSCharacterSet *nameCharacterSet;
@property (readonly) BOOL syntaxDefinitionAllowsColouring;
@property (readonly) BOOL recolourKeywordIfAlreadyColoured;
@property (readonly) BOOL keywordsCaseSensitive;
@property (readonly) ICUPattern *firstStringPattern;
@property (readonly) ICUPattern *secondStringPattern;
@property (readonly) ICUPattern *firstMultilineStringPattern;
@property (readonly) ICUPattern *secondMultilineStringPattern;
@property (readonly) unichar decimalPointCharacter;

- (instancetype)initFromSyntaxDictionary:(NSDictionary *)syntaxDictionary;

@end


