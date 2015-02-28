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
char kcGutterWidthPrefChanged;
char kcSyntaxColourPrefChanged;
char kcSpellCheckPrefChanged;
char kcLineNumberPrefChanged;
char kcLineWrapPrefChanged;
char kcGutterGutterTextColourWell;
char kcInvisibleCharacterValueChanged;
char kcFragariaTextFontChanged;
char kcFragariaInvisibleCharactersColourWellChanged;
char kcFragariaTabWidthChanged;


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

}


/*
 *  - observerValueForKeyPath:ofObject:change:context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BOOL boolValue;
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
        NSFont *font = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:MGSFragariaPrefsTextFont]];
        self.fragaria.textFont = font;   // these won't always be tied together, but this is current behavior.
        self.fragaria.gutterFont = font; // these won't always be tied together, but this is current behavior.
    }
    else if (context == &kcFragariaInvisibleCharactersColourWellChanged)
    {
        self.fragaria.textInvisibleCharactersColour = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:MGSFragariaPrefsInvisibleCharactersColourWell]];
    }
    else if (context == &kcFragariaTabWidthChanged)
    {
        self.fragaria.textTabWidth = [[defaults valueForKey:MGSFragariaPrefsTabWidth] integerValue];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
