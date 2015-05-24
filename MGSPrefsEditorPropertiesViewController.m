//
//  MGSPrefsEditorPropertiesViewController.m
//  Fragaria
//
//  Created by Jim Derry on 3/15/15.
//
//

#import "MGSPrefsEditorPropertiesViewController.h"
#import "MGSUserDefaultsController.h"


@interface MGSPrefsEditorPropertiesViewController ()

@property IBOutlet NSView *paneEditing;
@property IBOutlet NSView *paneGutter;
@property IBOutlet NSView *paneAutocomplete;
@property IBOutlet NSView *paneIndenting;
@property IBOutlet NSView *paneTextFont;

@end


@implementation MGSPrefsEditorPropertiesViewController

/*
 *  - init
 */
- (id)init
{
    id nextResp;
    NSBundle *bundle;
    NSView *v;
    CGFloat width;
    
    self = [super init];
    bundle = [NSBundle bundleForClass:[MGSPrefsEditorPropertiesViewController class]];
    [bundle loadNibNamed:@"MGSPrefsEditorProperties" owner:self topLevelObjects:nil];
    
    width = [self.paneEditing frame].size.width;
    v = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, width, 0)];
    [self setView:v];
    
    /* Install this view controller in the responder chain so that it will
     * receive the changeFont message. */
    v = [self view];
    nextResp = [v nextResponder];
    /* Yosemite already does this for us, so don't do it if it is not
     * needed. */
    if (nextResp != self) {
        [v setNextResponder:self];
        [self setNextResponder:nextResp];
    }

    return self;
}


/*
 *  - setFontAction:
 */
- (IBAction)setFontAction:(id)sender
{
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    [fontManager setSelectedFont:self.editorFont isMultiple:NO];
    [fontManager orderFrontFontPanel:nil];
}


/*
 *  - changeFont:
 */
- (void)changeFont:(id)sender
{
    self.editorFont = [(NSFontManager *)sender convertFont:self.editorFont];
}


/*
 *  @property editorFont
 *  The property binding for the font is only one way because the value
 *  transformer is only one way, and it would be dangerous to make it
 *  reversible. As such we shall manage the properties directly.
 */
- (void)setEditorFont:(NSFont *)editorFont
{
    [self.userDefaultsController.values setValue:editorFont forKey:MGSFragariaDefaultsTextFont];
    [self.userDefaultsController.values setValue:editorFont forKey:MGSFragariaDefaultsGutterFont];
}

- (NSFont *)editorFont
{
    return [self.userDefaultsController.values valueForKey:MGSFragariaDefaultsTextFont];
}


/*
 * - hideableViews
 */
- (NSDictionary *)propertiesForPanelSubviews
{
	return @{
			 NSStringFromSelector(@selector(paneEditing)) : [[MGSUserDefaultsDefinitions class] propertyGroupEditing],
			 NSStringFromSelector(@selector(paneGutter)) : [[MGSUserDefaultsDefinitions class] propertyGroupGutter],
			 NSStringFromSelector(@selector(paneAutocomplete)) : [[MGSUserDefaultsDefinitions class] propertyGroupAutocomplete],
			 NSStringFromSelector(@selector(paneIndenting)) : [[MGSUserDefaultsDefinitions class] propertyGroupIndenting],
			 NSStringFromSelector(@selector(paneTextFont)) : [[MGSUserDefaultsDefinitions class] propertyGroupTextFont],
			 };
}


/*
 * - keysForPanelSubviews
 */
- (NSArray *)keysForPanelSubviews
{
    return @[
        NSStringFromSelector(@selector(paneEditing)),
        NSStringFromSelector(@selector(paneGutter)),
        NSStringFromSelector(@selector(paneAutocomplete)),
        NSStringFromSelector(@selector(paneIndenting)),
        NSStringFromSelector(@selector(paneTextFont))
    ];
}


@end
