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
char kcPageGuideChanged;
char kcSyntaxColourPrefChanged;
char kcTextColorChanged;


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
 *  - registerKVO
 */
-(void)registerKVO
{
    NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
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
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsShowPageGuide) options:NSKeyValueObservingOptionInitial context:&kcPageGuideChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsShowPageGuideAtColumn) options:NSKeyValueObservingOptionInitial context:&kcPageGuideChanged];

    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAutoSpellCheck) options:NSKeyValueObservingOptionInitial context:&kcAutoSomethingChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAutomaticQuoteSubstitution) options:NSKeyValueObservingOptionInitial context:&kcAutoSomethingChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAutomaticLinkDetection) options:NSKeyValueObservingOptionInitial context:&kcAutoSomethingChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsAutoGrammarCheck) options:NSKeyValueObservingOptionInitial context:&kcAutoSomethingChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsSmartInsertDelete) options:NSKeyValueObservingOptionInitial context:&kcAutoSomethingChanged];

    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsHighlightCurrentLine) options:NSKeyValueObservingOptionInitial context:&kcLineHighlightingChanged];
    [defaultsController addObserver:self forKeyPath:VK(MGSFragariaPrefsHighlightLineColourWell) options:NSKeyValueObservingOptionInitial context:&kcLineHighlightingChanged];
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
        self.fragaria.gutterTextColour = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:MGSFragariaPrefsGutterTextColourWell]];
    }
    else if (context == &kcInvisibleCharacterValueChanged)
    {
        self.fragaria.showsInvisibleCharacters = [[defaults valueForKey:MGSFragariaPrefsShowInvisibleCharacters] boolValue];
    }
    else if (context == &kcFragariaTextFontChanged)
    {
        fontValue = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:MGSFragariaPrefsTextFont]];
        self.fragaria.textFont = fontValue;   // these won't always be tied together, but this is current behavior.
        self.fragaria.gutterFont = fontValue; // these won't always be tied together, but this is current behavior.
    }
    else if (context == &kcFragariaInvisibleCharactersColourWellChanged)
    {
        self.fragaria.textInvisibleCharactersColour = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:MGSFragariaPrefsInvisibleCharactersColourWell]];
    }
    else if (context == &kcFragariaTabWidthChanged)
    {
        self.fragaria.textTabWidth = [[defaults valueForKey:MGSFragariaPrefsTabWidth] integerValue];
    }
    else if (context == &kcAutoSomethingChanged)
    {
        self.fragaria.continuousSpellCheckingEnabled = [[defaults valueForKey:MGSFragariaPrefsAutoSpellCheck] boolValue];
        self.fragaria.automaticQuoteSubstitutionEnabled = [[defaults valueForKey:MGSFragariaPrefsAutomaticQuoteSubstitution] boolValue];
        self.fragaria.automaticLinkDetectionEnabled = [[defaults valueForKey:MGSFragariaPrefsAutomaticLinkDetection] boolValue];
        self.fragaria.grammarCheckingEnabled = [[defaults valueForKey:MGSFragariaPrefsAutoGrammarCheck] boolValue];
        self.fragaria.smartInsertDeleteEnabled = [[defaults valueForKey:MGSFragariaPrefsSmartInsertDelete] boolValue];
    }
    else if (context == &kcBackgroundColorChanged)
    {
        self.fragaria.textView.backgroundColor = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:MGSFragariaPrefsBackgroundColourWell]];
    }
    else if (context == &kcInsertionPointColorChanged || context == &kcTextColorChanged)
    {
        colorValue = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:MGSFragariaPrefsTextColourWell]];
        self.fragaria.textView.insertionPointColor = colorValue;
        self.fragaria.textView.textColor = colorValue;
    }
    else if (context == &kcPageGuideChanged)
    {
        self.fragaria.pageGuideColumn = [[defaults valueForKey:MGSFragariaPrefsShowPageGuideAtColumn] integerValue];
        self.fragaria.showsPageGuide = [[defaults valueForKey:MGSFragariaPrefsShowPageGuide] boolValue];
    }
    else if (context == &kcLineHighlightingChanged)
    {
        self.fragaria.highlightsCurrentLine = [[defaults valueForKey:MGSFragariaPrefsHighlightCurrentLine] boolValue];
        self.fragaria.currentLineHighlightColour = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:MGSFragariaPrefsHighlightLineColourWell]];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
