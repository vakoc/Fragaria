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
    [defaultsController addObserver:self forKeyPath:@"values.FragariaGutterWidth" options:NSKeyValueObservingOptionNew context:&kcGutterWidthPrefChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaSyntaxColourNewDocuments" options:NSKeyValueObservingOptionNew context:&kcSyntaxColourPrefChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaAutoSpellCheck" options:NSKeyValueObservingOptionNew context:&kcSpellCheckPrefChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaShowLineNumberGutter" options:NSKeyValueObservingOptionNew context:&kcLineNumberPrefChanged];
    [defaultsController addObserver:self forKeyPath:@"values.FragariaLineWrapNewDocuments" options:NSKeyValueObservingOptionNew context:&kcLineWrapPrefChanged];
}


/*
 *  - observerValueForKeyPath:ofObject:change:context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BOOL boolValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (context == &kcLineNumberPrefChanged)
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
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


@end
