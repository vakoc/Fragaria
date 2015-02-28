//
//  MGSTemporaryPreferencesObserver.m
//  Fragaria
//
//  Created by Jim Derry on 2/27/15.
//
//

#import "MGSTemporaryPreferencesObserver.h"
#import "MGSFragaria.h"


// KVO context constants
char kcAutoSpellCheckChanged;
char kcBackgroundColorChanged;
char kcFragariaInvisibleCharactersColourWellChanged;
char kcFragariaTabWidthChanged;
char kcFragariaTextFontChanged;
char kcInsertionPointColorChanged;
char kcGutterGutterTextColourWell;
char kcGutterWidthPrefChanged;
char kcInvisibleCharacterValueChanged;
char kcLineNumberPrefChanged;
char kcLineWrapPrefChanged;
char kcPageGuideChanged;
char kcSpellCheckPrefChanged;
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
    [defaultsController addObserver:self forKeyPath:@"values.FragariaGutterWidth" options:NSKeyValueObservingOptionInitial context:&kcGutterWidthPrefChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaSyntaxColourNewDocuments" options:NSKeyValueObservingOptionInitial context:&kcSyntaxColourPrefChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaAutoSpellCheck" options:NSKeyValueObservingOptionInitial context:&kcSpellCheckPrefChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaShowLineNumberGutter" options:NSKeyValueObservingOptionInitial context:&kcLineNumberPrefChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaLineWrapNewDocuments" options:NSKeyValueObservingOptionInitial context:&kcLineWrapPrefChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaGutterTextColourWell" options:NSKeyValueObservingOptionInitial context:&kcGutterGutterTextColourWell];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaTextFont" options:NSKeyValueObservingOptionInitial context:&kcFragariaTextFontChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaInvisibleCharactersColourWell" options:NSKeyValueObservingOptionInitial context:&kcFragariaInvisibleCharactersColourWellChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaShowInvisibleCharacters" options:NSKeyValueObservingOptionInitial context:&kcInvisibleCharacterValueChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaTabWidth" options:NSKeyValueObservingOptionInitial context:&kcFragariaTabWidthChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaAutoSpellCheck" options:NSKeyValueObservingOptionInitial context:&kcAutoSpellCheckChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaBackgroundColourWell" options:NSKeyValueObservingOptionInitial context:&kcBackgroundColorChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaTextColourWell" options:NSKeyValueObservingOptionInitial context:&kcInsertionPointColorChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaTextColourWell" options:NSKeyValueObservingOptionInitial context:&kcTextColorChanged];

    [defaultsController addObserver:self forKeyPath:@"values.FragariaShowPageGuide" options:NSKeyValueObservingOptionInitial context:&kcPageGuideChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaShowPageGuideAtColumn" options:NSKeyValueObservingOptionInitial context:&kcPageGuideChanged];
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
    else if (context == &kcSpellCheckPrefChanged)
    {
        boolValue = [defaults boolForKey:MGSFragariaPrefsAutoSpellCheck];
        self.fragaria.autoSpellCheck = boolValue;
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
    else if (context == &kcAutoSpellCheckChanged)
    {
        self.fragaria.autoSpellCheck = [[defaults valueForKey:MGSFragariaPrefsAutoSpellCheck] boolValue];
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
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
