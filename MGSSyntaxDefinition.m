//
//  MGSSyntaxDefinition.m
//  Fragaria
//
//  Created by Daniele Cattaneo on 03/02/15.
//
//

#import "MGSSyntaxDefinition.h"
#import "MGSFragariaFramework.h"


// syntax definition dictionary keys

NSString *SMLSyntaxDefinitionAllowSyntaxColouring = @"allowSyntaxColouring";
NSString *SMLSyntaxDefinitionKeywords = @"keywords";
NSString *SMLSyntaxDefinitionAutocompleteWords = @"autocompleteWords";
NSString *SMLSyntaxDefinitionRecolourKeywordIfAlreadyColoured = @"recolourKeywordIfAlreadyColoured";
NSString *SMLSyntaxDefinitionKeywordsCaseSensitive = @"keywordsCaseSensitive";
NSString *SMLSyntaxDefinitionBeginCommand = @"beginCommand";
NSString *SMLSyntaxDefinitionEndCommand = @"endCommand";
NSString *SMLSyntaxDefinitionBeginInstruction = @"beginInstruction";
NSString *SMLSyntaxDefinitionEndInstruction = @"endInstruction";
NSString *SMLSyntaxDefinitionBeginVariable = @"beginVariable";
NSString *SMLSyntaxDefinitionEndVariable = @"endVariable";
NSString *SMLSyntaxDefinitionFirstString = @"firstString";
NSString *SMLSyntaxDefinitionSecondString = @"secondString";
NSString *SMLSyntaxDefinitionFirstSingleLineComment = @"firstSingleLineComment";
NSString *SMLSyntaxDefinitionSecondSingleLineComment = @"secondSingleLineComment";
NSString *SMLSyntaxDefinitionBeginFirstMultiLineComment = @"beginFirstMultiLineComment";
NSString *SMLSyntaxDefinitionEndFirstMultiLineComment = @"endFirstMultiLineComment";
NSString *SMLSyntaxDefinitionBeginSecondMultiLineComment = @"beginSecondMultiLineComment";
NSString *SMLSyntaxDefinitionEndSecondMultiLineComment = @"endSecondMultiLineComment";
NSString *SMLSyntaxDefinitionFunctionDefinition = @"functionDefinition";
NSString *SMLSyntaxDefinitionExcludeFromKeywordStartCharacterSet = @"excludeFromKeywordStartCharacterSet";
NSString *SMLSyntaxDefinitionExcludeFromKeywordEndCharacterSet = @"excludeFromKeywordEndCharacterSet";
NSString *SMLSyntaxDefinitionIncludeInKeywordStartCharacterSet = @"includeInKeywordStartCharacterSet";
NSString *SMLSyntaxDefinitionIncludeInKeywordEndCharacterSet = @"includeInKeywordEndCharacterSet";


@implementation MGSSyntaxDefinition {
    NSArray *sortedAutocompleteWords;
}


- (instancetype)initFromSyntaxDictionary:(NSDictionary *)syntaxDictionary
{
    self = [super init];
    [self setDefaults];

    _syntaxDictionary = syntaxDictionary;
    
    // If the plist file is malformed be sure to set the values to something
    
    // syntax colouring
    id value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionAllowSyntaxColouring];
    if (value) {
        NSAssert([value isKindOfClass:[NSNumber class]], @"NSNumber expected");
        _syntaxDefinitionAllowsColouring = [value boolValue];
    } else {
        // default to YES
        _syntaxDefinitionAllowsColouring = YES;
    }
    
    // keywords
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionKeywords];
    if (value) {
        NSAssert([value isKindOfClass:[NSArray class]], @"NSArray expected");
        _keywords = [[NSSet alloc] initWithArray:value];
    }
    
    // autocomplete words
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionAutocompleteWords];
    if (value) {
        NSAssert([value isKindOfClass:[NSArray class]], @"NSArray expected");
        _autocompleteWords = [[NSSet alloc] initWithArray:value];
    }
    
    // recolour keywords
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionRecolourKeywordIfAlreadyColoured];
    if (value) {
        NSAssert([value isKindOfClass:[NSNumber class]], @"NSNumber expected");
        _recolourKeywordIfAlreadyColoured = [value boolValue];
    }
    
    // keywords case sensitive
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionKeywordsCaseSensitive];
    if (value) {
        NSAssert([value isKindOfClass:[NSNumber class]], @"NSNumber expected");
        _keywordsCaseSensitive = [value boolValue];
    }
    
    if (self.keywordsCaseSensitive == NO) {
        NSMutableArray *lowerCaseKeywords = [[NSMutableArray alloc] init];
        for (id item in self.keywords) {
            [lowerCaseKeywords addObject:[item lowercaseString]];
        }
        
        NSSet *lowerCaseKeywordsSet = [[NSSet alloc] initWithArray:lowerCaseKeywords];
        _keywords = lowerCaseKeywordsSet;
    }
    
    // begin command
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionBeginCommand];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        _beginCommand = value;
    } else {
        _beginCommand = @"";
    }
    
    // end command
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionEndCommand];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        _endCommand = value;
    } else {
        _endCommand = @"";
    }
    
    // begin instruction
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionBeginInstruction];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        _beginInstruction = value;
    } else {
        _beginInstruction = @"";
    }
    
    // end instruction
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionEndInstruction];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        _endInstruction = value;
    } else {
        _endInstruction = @"";
    }
    
    // begin variable
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionBeginVariable];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        _beginVariableCharacterSet = [NSCharacterSet characterSetWithCharactersInString:value];
    } else {
        _beginVariableCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@""];
    }
    
    // end variable
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionEndVariable];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        _endVariableCharacterSet = [NSCharacterSet characterSetWithCharactersInString:value];
    } else {
        _endVariableCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@""];
    }
    
    // first string
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionFirstString];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        _firstString = value;
    } else {
        _firstString = @"";
    }
    
    // second string
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionSecondString];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        _secondString = value;
    } else {
        _secondString = @"";
    }
    
    _singleLineComments = [NSMutableArray arrayWithCapacity:2];
    
    // first single line comment
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionFirstSingleLineComment];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        if (![value isEqual:@""])
            [_singleLineComments addObject:value];
    }
    
    // second single line comment
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionSecondSingleLineComment];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        if (![value isEqual:@""])
            [_singleLineComments addObject:value];
    }
    
    _multiLineComments = [NSMutableArray arrayWithCapacity:2];
    id pairedValue;
    
    // first multi line comment
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionBeginFirstMultiLineComment];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        if (![value isEqual:@""]) {
            pairedValue = [syntaxDictionary valueForKey:SMLSyntaxDefinitionEndFirstMultiLineComment];
            NSAssert([pairedValue isKindOfClass:[NSString class]], @"NSString expected");
            if (![pairedValue isEqual:@""])
                [_multiLineComments addObject:@[value, pairedValue]];
        }
    }
    
    // second multi line comment
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionBeginSecondMultiLineComment];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        if (![value isEqual:@""]) {
            pairedValue = [syntaxDictionary valueForKey:SMLSyntaxDefinitionEndSecondMultiLineComment];
            NSAssert([pairedValue isKindOfClass:[NSString class]], @"NSString expected");
            if (![pairedValue isEqual:@""])
                [_multiLineComments addObject:@[value, pairedValue]];
        }
    }
    
    // function definition
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionFunctionDefinition];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        _functionDefinition = value;
    } else {
        _functionDefinition = @"";
    }
    
    // exclude characters from keyword start character set
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionExcludeFromKeywordStartCharacterSet];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        NSMutableCharacterSet *temporaryCharacterSet = [self.keywordStartCharacterSet mutableCopy];
        [temporaryCharacterSet removeCharactersInString:value];
        _keywordStartCharacterSet = [temporaryCharacterSet copy];
    }
    
    // exclude characters from keyword end character set
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionExcludeFromKeywordEndCharacterSet];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        NSMutableCharacterSet *temporaryCharacterSet = [self.keywordEndCharacterSet mutableCopy];
        [temporaryCharacterSet removeCharactersInString:value];
        _keywordEndCharacterSet = [temporaryCharacterSet copy];
    }
    
    // include characters in keyword start character set
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionIncludeInKeywordStartCharacterSet];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        NSMutableCharacterSet *temporaryCharacterSet = [self.keywordStartCharacterSet mutableCopy];
        [temporaryCharacterSet addCharactersInString:value];
        _keywordStartCharacterSet = [temporaryCharacterSet copy];
    }
    
    // include characters in keyword end character set
    value = [syntaxDictionary valueForKey:SMLSyntaxDefinitionIncludeInKeywordEndCharacterSet];
    if (value) {
        NSAssert([value isKindOfClass:[NSString class]], @"NSString expected");
        NSMutableCharacterSet *temporaryCharacterSet = [self.keywordEndCharacterSet mutableCopy];
        [temporaryCharacterSet addCharactersInString:value];
        _keywordEndCharacterSet = [temporaryCharacterSet copy];
    }
    
    return self;
}


- (void)setDefaults {
    // name character set
    NSMutableCharacterSet *temporaryCharacterSet = [[NSCharacterSet letterCharacterSet] mutableCopy];
    [temporaryCharacterSet addCharactersInString:@"_"];
    _nameCharacterSet = [temporaryCharacterSet copy];
    
    // keyword start character set
    temporaryCharacterSet = [[NSCharacterSet letterCharacterSet] mutableCopy];
    [temporaryCharacterSet addCharactersInString:@"_:@#"];
    _keywordStartCharacterSet = [temporaryCharacterSet copy];
    
    // keyword end character set
    // see http://www.fileformat.info/info/unicode/category/index.htm for categories that make up the sets
    temporaryCharacterSet = [[NSCharacterSet whitespaceAndNewlineCharacterSet] mutableCopy];
    [temporaryCharacterSet formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
    [temporaryCharacterSet formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
    [temporaryCharacterSet removeCharactersInString:@"._-"]; // common separators in variable names
    _keywordEndCharacterSet = [temporaryCharacterSet copy];
    
    // number character set
    _numberCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    _decimalPointCharacter = [@"." characterAtIndex:0];
    
    // attributes character set
    temporaryCharacterSet = [[NSCharacterSet alphanumericCharacterSet] mutableCopy];
    [temporaryCharacterSet addCharactersInString:@" -"]; // If there are two spaces before an attribute
    _attributesCharacterSet = [temporaryCharacterSet copy];
}


- (NSArray*)completions
{
    if (!sortedAutocompleteWords) {
        NSArray *tmp;
        
        tmp = [self.autocompleteWords allObjects];
        sortedAutocompleteWords = [tmp sortedArrayUsingSelector:@selector(compare:)];
    }
    return sortedAutocompleteWords;
}


@end
