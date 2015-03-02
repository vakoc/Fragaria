//
//  MGSTemporaryPreferencesObserver.m
//  Fragaria
//
//  Created by Jim Derry on 2/27/15.
//
//

#import "MGSTemporaryPreferencesObserver.h"
#import "MGSFragaria.h"

/* simple utility so we can use they key names without having to cross reference the strings every time. */
static NSString *VK(NSString *key)
{
    return [NSString stringWithFormat:@"values.%@", key];
}

// KVO context constants
char kcAutoSomethingChanged;
char kcBackgroundColorChanged;
char kcColoursChanged;
char kcFragariaInvisibleCharactersColourWellChanged;
char kcFragariaTabWidthChanged;
char kcFragariaTextFontChanged;
char kcInsertionPointColorChanged;
char kcGutterGutterTextColourWell;
char kcGutterWidthPrefChanged;
char kcInvisibleCharacterValueChanged;
char kcLineHighlightingChanged;
char kcLineNumberPrefChanged;
char kcLineWrapPrefChanged;
char kcMultiLineChanged;
char kcPageGuideChanged;
char kcSyntaxColourPrefChanged;
char kcTextColorChanged;
char kcShowMatchingBracesChanged;
char kcAutoInsertionPrefsChanged;
char kcIndentingPrefsChanged;


@interface MGSTemporaryPreferencesObserver ()

@property (nonatomic, weak) MGSFragaria *fragaria;

@end


@implementation MGSTemporaryPreferencesObserver

/*
 *  - initWithFragaria:
 */
- (instancetype)initWithFragaria:(MGSFragaria *)fragaria
{
    if ((self = [super init]))
    {
        self.fragaria = fragaria;
        [self registerKVO];
    }
	
    return self;
}


/*
 *  - init
 */
- (instancetype)init
{
    return [self initWithFragaria:nil];
}


/*
 * - dealloc
 */
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


/*
 *  - registerKVO
 */
-(void)registerKVO
{
    NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
	
	// SMLTextView
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsGutterWidth) options:NSKeyValueObservingOptionInitial context:&kcGutterWidthPrefChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsSyntaxColourNewDocuments) options:NSKeyValueObservingOptionInitial context:&kcSyntaxColourPrefChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsShowLineNumberGutter) options:NSKeyValueObservingOptionInitial context:&kcLineNumberPrefChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsLineWrapNewDocuments) options:NSKeyValueObservingOptionInitial context:&kcLineWrapPrefChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsGutterTextColourWell) options:NSKeyValueObservingOptionInitial context:&kcGutterGutterTextColourWell];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsTextFont) options:NSKeyValueObservingOptionInitial context:&kcFragariaTextFontChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsInvisibleCharactersColourWell) options:NSKeyValueObservingOptionInitial context:&kcFragariaInvisibleCharactersColourWellChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsShowInvisibleCharacters) options:NSKeyValueObservingOptionInitial context:&kcInvisibleCharacterValueChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsTabWidth) options:NSKeyValueObservingOptionInitial context:&kcFragariaTabWidthChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsBackgroundColourWell) options:NSKeyValueObservingOptionInitial context:&kcBackgroundColorChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsGutterTextColourWell) options:NSKeyValueObservingOptionInitial context:&kcInsertionPointColorChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsGutterTextColourWell) options:NSKeyValueObservingOptionInitial context:&kcTextColorChanged];
    
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsShowPageGuide) options:0 context:&kcPageGuideChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsShowPageGuideAtColumn) options:NSKeyValueObservingOptionInitial context:&kcPageGuideChanged];
    
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAutoSpellCheck) options:0 context:&kcAutoSomethingChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAutomaticLinkDetection) options:0 context:&kcAutoSomethingChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAutoGrammarCheck) options:0 context:&kcAutoSomethingChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsSmartInsertDelete) options:NSKeyValueObservingOptionInitial context:&kcAutoSomethingChanged];
    
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsHighlightCurrentLine) options:0 context:&kcLineHighlightingChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsHighlightLineColourWell) options:NSKeyValueObservingOptionInitial context:&kcLineHighlightingChanged];
    
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsShowMatchingBraces) options:NSKeyValueObservingOptionInitial context:&kcShowMatchingBracesChanged];
    
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAutoInsertAClosingBrace) options:0 context:&kcAutoInsertionPrefsChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAutoInsertAClosingParenthesis) options:NSKeyValueObservingOptionInitial context:&kcAutoInsertionPrefsChanged];
    
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsIndentWithSpaces) options:0 context:&kcIndentingPrefsChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsUseTabStops) options:0 context:&kcIndentingPrefsChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsIndentNewLinesAutomatically) options:0 context:&kcIndentingPrefsChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAutomaticallyIndentBraces) options:NSKeyValueObservingOptionInitial context:&kcIndentingPrefsChanged];

	// SMLSyntaxColouring
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsCommandsColourWell) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsCommentsColourWell) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsInstructionsColourWell) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsKeywordsColourWell) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAutocompleteColourWell) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsVariablesColourWell) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsStringsColourWell) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAttributesColourWell) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsNumbersColourWell) options:0 context:&kcColoursChanged];
	
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsColourCommands) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsColourComments) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsColourInstructions) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsColourKeywords) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsColourAutocomplete) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsColourVariables) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsColourStrings) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsColourAttributes) options:0 context:&kcColoursChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsColourNumbers) options:NSKeyValueObservingOptionInitial context:&kcColoursChanged];
	
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsColourMultiLineStrings) options:0 context:&kcMultiLineChanged];
	[defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsOnlyColourTillTheEndOfLine) options:NSKeyValueObservingOptionInitial context:&kcMultiLineChanged];
}


/*
 *  - observerValueForKeyPath:ofObject:change:context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BOOL boolValue;
    NSColor *colorValue;
    NSFont *fontValue;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (context == &kcGutterWidthPrefChanged)
    {
        self.fragaria.gutterMinimumWidth = [defaults integerForKey:MGSFragariaPrefsGutterWidth];
    }
    else if (context == &kcLineNumberPrefChanged)
    {
        boolValue = [defaults boolForKey:MGSFragariaPrefsShowLineNumberGutter];
        self.fragaria.showsGutter = boolValue;
    }
    else if (context == &kcSyntaxColourPrefChanged)
    {
        boolValue = [defaults boolForKey:MGSFragariaPrefsSyntaxColourNewDocuments];
        self.fragaria.isSyntaxColoured = boolValue;
    }
    else if (context == &kcLineWrapPrefChanged)
    {
        boolValue = [defaults boolForKey:MGSFragariaPrefsLineWrapNewDocuments];
        self.fragaria.lineWrap = boolValue;
    }
    else if (context == &kcGutterGutterTextColourWell)
    {
        self.fragaria.gutterTextColour = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsGutterTextColourWell]];
    }
    else if (context == &kcInvisibleCharacterValueChanged)
    {
        self.fragaria.showsInvisibleCharacters = [defaults boolForKey:MGSFragariaPrefsShowInvisibleCharacters];
    }
    else if (context == &kcFragariaTextFontChanged)
    {
        fontValue = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsTextFont]];
        self.fragaria.textFont = fontValue;   // these won't always be tied together, but this is current behavior.
        self.fragaria.gutterFont = fontValue; // these won't always be tied together, but this is current behavior.
    }
    else if (context == &kcFragariaInvisibleCharactersColourWellChanged)
    {
        self.fragaria.textInvisibleCharactersColour = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsInvisibleCharactersColourWell]];
    }
    else if (context == &kcFragariaTabWidthChanged)
    {
        self.fragaria.tabWidth = [defaults integerForKey:MGSFragariaPrefsTabWidth];
    }
    else if (context == &kcAutoSomethingChanged)
    {
        self.fragaria.continuousSpellCheckingEnabled = [defaults integerForKey:MGSFragariaPrefsAutoSpellCheck];
        self.fragaria.grammarCheckingEnabled = [defaults integerForKey:MGSFragariaPrefsAutoGrammarCheck];
        self.fragaria.smartInsertDeleteEnabled = [defaults integerForKey:MGSFragariaPrefsSmartInsertDelete];
    }
    else if (context == &kcShowMatchingBracesChanged)
    {
        self.fragaria.showsMatchingBraces = [defaults boolForKey:MGSFragariaPrefsShowMatchingBraces];
    }
    else if (context == &kcAutoInsertionPrefsChanged)
    {
        self.fragaria.insertClosingBraceAutomatically = [defaults boolForKey:MGSFragariaPrefsAutoInsertAClosingBrace];
        self.fragaria.insertClosingParenthesisAutomatically = [defaults boolForKey:MGSFragariaPrefsAutoInsertAClosingParenthesis];
    }
    else if (context == &kcIndentingPrefsChanged)
    {
        self.fragaria.indentWithSpaces = [defaults boolForKey:MGSFragariaPrefsIndentWithSpaces];
        self.fragaria.useTabStops = [defaults boolForKey:MGSFragariaPrefsUseTabStops] ;
        self.fragaria.indentNewLinesAutomatically = [defaults boolForKey:MGSFragariaPrefsIndentNewLinesAutomatically];
        self.fragaria.indentBracesAutomatically = [defaults boolForKey:MGSFragariaPrefsAutomaticallyIndentBraces];
    }
    else if (context == &kcBackgroundColorChanged)
    {
        self.fragaria.textView.backgroundColor = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsBackgroundColourWell]];
    }
    else if (context == &kcInsertionPointColorChanged || context == &kcTextColorChanged)
    {
        colorValue = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsTextColourWell]];
        self.fragaria.textView.insertionPointColor = colorValue;
        self.fragaria.textView.textColor = colorValue;
    }
    else if (context == &kcPageGuideChanged)
    {
        self.fragaria.pageGuideColumn = [defaults integerForKey:MGSFragariaPrefsShowPageGuideAtColumn];
        self.fragaria.showsPageGuide = [defaults boolForKey:MGSFragariaPrefsShowPageGuide];
    }
    else if (context == &kcLineHighlightingChanged)
    {
        self.fragaria.highlightsCurrentLine = [defaults boolForKey:MGSFragariaPrefsHighlightCurrentLine];
        self.fragaria.currentLineHighlightColour = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsHighlightLineColourWell]];
    }
    else if (context == &kcMultiLineChanged)
    {
        self.fragaria.colourMultiLineStringsEnabled = [defaults boolForKey:MGSFragariaPrefsColourMultiLineStrings];
        self.fragaria.colourOnlyUntilEndOfLineEnabled = [defaults boolForKey:MGSFragariaPrefsOnlyColourTillTheEndOfLine];
    }
    else if (context == &kcColoursChanged)
    {
        self.fragaria.coloursAttributes = [defaults boolForKey:MGSFragariaPrefsColourAttributes];
        self.fragaria.coloursAutocomplete = [defaults boolForKey:MGSFragariaPrefsColourAutocomplete];
        self.fragaria.coloursCommands = [defaults boolForKey:MGSFragariaPrefsColourCommands];
        self.fragaria.coloursComments = [defaults boolForKey:MGSFragariaPrefsColourComments];
        self.fragaria.coloursInstructions = [defaults boolForKey:MGSFragariaPrefsColourInstructions];
        self.fragaria.coloursKeywords = [defaults boolForKey:MGSFragariaPrefsColourKeywords];
        self.fragaria.coloursNumbers = [defaults boolForKey:MGSFragariaPrefsColourNumbers];
        self.fragaria.coloursStrings = [defaults boolForKey:MGSFragariaPrefsColourStrings];
        self.fragaria.coloursVariables = [defaults boolForKey:MGSFragariaPrefsColourVariables];
        self.fragaria.colourForAttributes = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsAttributesColourWell]];
        self.fragaria.colourForAutocomplete = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsAutocompleteColourWell]];
        self.fragaria.colourForCommands = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsCommandsColourWell]];
        self.fragaria.colourForComments = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsCommentsColourWell]];
        self.fragaria.colourForInstructions = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsInstructionsColourWell]];
        self.fragaria.colourForKeywords = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsKeywordsColourWell]];
        self.fragaria.colourForNumbers = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsNumbersColourWell]];
        self.fragaria.colourForStrings = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsStringsColourWell]];
        self.fragaria.colourForVariables = [NSUnarchiver unarchiveObjectWithData:[defaults objectForKey:MGSFragariaPrefsVariablesColourWell]];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
