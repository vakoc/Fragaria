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
char kcGutterTextFontChanged;
char kcGutterGutterTextColourWell;

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
    [defaultsController addObserver:self forKeyPath:@"values.FragariaTextFont" options:NSKeyValueObservingOptionInitial context:&kcGutterTextFontChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaGutterTextColourWell" options:NSKeyValueObservingOptionInitial context:&kcGutterGutterTextColourWell];
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
    else if (context == &kcGutterTextFontChanged)
    {
        self.fragaria.gutterFont = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:MGSFragariaPrefsTextFont]];
    }
    else if (context == &kcGutterGutterTextColourWell)
    {
        self.fragaria.gutterTextColour = [defaults valueForKey:MGSFragariaPrefsGutterTextColourWell];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


/*
 *  - setupInitialProperties
 */
- (void)setupInitialProperties
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.fragaria.gutterMinimumWidth = [defaults integerForKey:MGSFragariaPrefsGutterWidth];

    self.fragaria.showsGutter = [defaults boolForKey:MGSFragariaPrefsShowLineNumberGutter];;

    self.fragaria.isSyntaxColoured = [defaults boolForKey:MGSFragariaPrefsSyntaxColourNewDocuments];

    self.fragaria.autoSpellCheck = [defaults boolForKey:MGSFragariaPrefsAutoSpellCheck];

    self.fragaria.lineWrap = [defaults boolForKey:MGSFragariaPrefsLineWrapNewDocuments];

    self.fragaria.gutterFont = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:MGSFragariaPrefsTextFont]];

    self.fragaria.gutterTextColour = [NSUnarchiver unarchiveObjectWithData:[defaults valueForKey:MGSFragariaPrefsGutterTextColourWell]];
}


@end
