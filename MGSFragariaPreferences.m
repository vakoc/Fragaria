//
//  MGSFragariaPreferences.m
//  Fragaria
//
//  Created by Jonathan on 14/09/2012.
//
//

#import "MGSFragariaPreferences.h"

#pragma mark - Global Keys for Accessing Preferences' Strings

// colour prefs
// persisted as [NSArchiver archivedDataWithRootObject:[NSColor whiteColor]]
NSString * const MGSFragariaPrefsCommandsColourWell = @"FragariaCommandsColourWell";
NSString * const MGSFragariaPrefsCommentsColourWell = @"FragariaCommentsColourWell";
NSString * const MGSFragariaPrefsInstructionsColourWell = @"FragariaInstructionsColourWell";
NSString * const MGSFragariaPrefsKeywordsColourWell = @"FragariaKeywordsColourWell";
NSString * const MGSFragariaPrefsAutocompleteColourWell = @"FragariaAutocompleteColourWell";
NSString * const MGSFragariaPrefsVariablesColourWell = @"FragariaVariablesColourWell";
NSString * const MGSFragariaPrefsStringsColourWell = @"FragariaStringsColourWell";
NSString * const MGSFragariaPrefsAttributesColourWell = @"FragariaAttributesColourWell";
NSString * const MGSFragariaPrefsNumbersColourWell = @"FragariaNumbersColourWell";
NSString * const MGSFragariaPrefsBackgroundColourWell = @"FragariaBackgroundColourWell";
NSString * const MGSFragariaPrefsTextColourWell = @"FragariaTextColourWell";
NSString * const MGSFragariaPrefsGutterTextColourWell = @"FragariaGutterTextColourWell";
NSString * const MGSFragariaPrefsInvisibleCharactersColourWell = @"FragariaInvisibleCharactersColourWell";
NSString * const MGSFragariaPrefsHighlightLineColourWell = @"FragariaHighlightLineColourWell";

// bool
NSString * const MGSFragariaPrefsColourNumbers = @"FragariaColourNumbers";
NSString * const MGSFragariaPrefsColourCommands = @"FragariaColourCommands";
NSString * const MGSFragariaPrefsColourComments = @"FragariaColourComments";
NSString * const MGSFragariaPrefsColourInstructions = @"FragariaColourInstructions";
NSString * const MGSFragariaPrefsColourKeywords = @"FragariaColourKeywords";
NSString * const MGSFragariaPrefsColourAutocomplete = @"FragariaColourAutocomplete";
NSString * const MGSFragariaPrefsColourVariables = @"FragariaColourVariables";
NSString * const MGSFragariaPrefsColourStrings = @"FragariaColourStrings";
NSString * const MGSFragariaPrefsColourAttributes = @"FragariaColourAttributes";
NSString * const MGSFragariaPrefsShowFullPathInWindowTitle = @"FragariaShowFullPathInWindowTitle";
NSString * const MGSFragariaPrefsShowLineNumberGutter = @"FragariaShowLineNumberGutter";
NSString * const MGSFragariaPrefsSyntaxColourNewDocuments = @"FragariaSyntaxColourNewDocuments";
NSString * const MGSFragariaPrefsLineWrapNewDocuments = @"FragariaLineWrapNewDocuments";
NSString * const MGSFragariaPrefsIndentNewLinesAutomatically = @"FragariaIndentNewLinesAutomatically";
NSString * const MGSFragariaPrefsOnlyColourTillTheEndOfLine = @"FragariaOnlyColourTillTheEndOfLine";
NSString * const MGSFragariaPrefsShowMatchingBraces = @"FragariaShowMatchingBraces";
NSString * const MGSFragariaPrefsShowInvisibleCharacters = @"FragariaShowInvisibleCharacters";
NSString * const MGSFragariaPrefsIndentWithSpaces = @"FragariaIndentWithSpaces";
NSString * const MGSFragariaPrefsColourMultiLineStrings = @"FragariaColourMultiLineStrings";
NSString * const MGSFragariaPrefsAutocompleteSuggestAutomatically = @"FragariaAutocompleteSuggestAutomatically";
NSString * const MGSFragariaPrefsAutocompleteIncludeStandardWords = @"FragariaAutocompleteIncludeStandardWords";
NSString * const MGSFragariaPrefsAutoSpellCheck = @"FragariaAutoSpellCheck";
NSString * const MGSFragariaPrefsAutoGrammarCheck = @"FragariaAutoGrammarCheck";
NSString * const MGSFragariaPrefsSmartInsertDelete = @"FragariaSmartInsertDelete";
NSString * const MGSFragariaPrefsAutomaticLinkDetection = @"FragariaAutomaticLinkDetection";
NSString * const MGSFragariaPrefsAutomaticQuoteSubstitution = @"FragariaAutomaticQuoteSubstitution";
NSString * const MGSFragariaPrefsUseTabStops = @"FragariaUseTabStops";
NSString * const MGSFragariaPrefsHighlightCurrentLine = @"FragariaHighlightCurrentLine";
NSString * const MGSFragariaPrefsAutomaticallyIndentBraces = @"FragariaAutomaticallyIndentBraces";
NSString * const MGSFragariaPrefsAutoInsertAClosingParenthesis = @"FragariaAutoInsertAClosingParenthesis";
NSString * const MGSFragariaPrefsAutoInsertAClosingBrace = @"FragariaAutoInsertAClosingBrace";
NSString * const MGSFragariaPrefsShowPageGuide = @"FragariaShowPageGuide";

// integer
NSString * const MGSFragariaPrefsGutterWidth = @"FragariaGutterWidth";
NSString * const MGSFragariaPrefsTabWidth = @"FragariaTabWidth";
NSString * const MGSFragariaPrefsIndentWidth = @"FragariaIndentWidth";
NSString * const MGSFragariaPrefsShowPageGuideAtColumn = @"FragariaShowPageGuideAtColumn";
NSString * const MGSFragariaPrefsSpacesPerTabEntabDetab = @"FragariaSpacesPerTabEntabDetab";

// float
NSString * const MGSFragariaPrefsAutocompleteAfterDelay = @"FragariaAutocompleteAfterDelay";

// font
// persisted as [NSArchiver archivedDataWithRootObject:[NSFont fontWithName:@"Menlo" size:11]]
NSString * const MGSFragariaPrefsTextFont = @"FragariaTextFont";

// string
NSString * const MGSFragariaPrefsSyntaxColouringPopUpString = @"FragariaSyntaxColouringPopUpString";


#pragma mark - Statics used for this class


static id sharedInstance = nil;


#pragma mark - MGSFragariaPreferences Implementation

@implementation MGSFragariaPreferences

@synthesize fontsAndColoursPrefsViewController = _fontsAndColoursPrefsViewController;
@synthesize textEditingPrefsViewController = _textEditingPrefsViewController;


#pragma mark - Class Methods


/*
 *  + sharedInstance
 */
+ (MGSFragariaPreferences *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}


/*
 *  + allocWithZone:
 *    alloc with zone for singleton
 */
+ (id)allocWithZone:(NSZone *)zone
{
#pragma unused(zone)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	return [self sharedInstance];
#pragma clang diagnostic pop
}


#pragma mark - Instance methods

/*
 *  - init
 */
- (id)init
{
    if (sharedInstance) return sharedInstance;
    self = [super init];
    sharedInstance = self;
    return self;
}


/*
 *  - changeFont:
 */
- (void)changeFont:(id)sender
{
    /* NSFontManager will send this method up the responder chain */
    [_fontsAndColoursPrefsViewController changeFont:sender];
}


/*
 *  - revertToStandardSettings:
 */
- (void)revertToStandardSettings:(id)sender
{
	[[NSUserDefaultsController sharedUserDefaultsController] revertToInitialValues:nil];
}


#pragma mark - Property Accessors


/*
 *  @property MGSFragariaTextEditingPrefsViewController
 *    Don't allocate these resources unless someone actually needs them.
 */
-(MGSFragariaTextEditingPrefsViewController *)textEditingPrefsViewController
{
    if (!_textEditingPrefsViewController)
    {
        _textEditingPrefsViewController = [[MGSFragariaTextEditingPrefsViewController alloc] init];
    }

    return _textEditingPrefsViewController;
}


/*
 *  @property MGSFragariaFontsAndColoursPrefsViewController
 *    Don't allocate these resources unless someone actually needs them.
 */
-(MGSFragariaFontsAndColoursPrefsViewController *)fontsAndColoursPrefsViewController
{
    if (!_fontsAndColoursPrefsViewController)
    {
        _fontsAndColoursPrefsViewController = [[MGSFragariaFontsAndColoursPrefsViewController alloc] init];
    }

    return _fontsAndColoursPrefsViewController;
}

@end

