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

@property (nonatomic, assign) IBOutlet NSView *paneEditing;
@property (nonatomic, assign) IBOutlet NSView *paneGutter;
@property (nonatomic, assign) IBOutlet NSView *paneAutocomplete;
@property (nonatomic, assign) IBOutlet NSView *paneIndenting;
@property (nonatomic, assign) IBOutlet NSView *paneTextFont;

@end

@implementation MGSPrefsEditorPropertiesViewController

/*
 *  - init
 */
- (id)init
{
    NSView *v;
    id nextResp;

    if ((self = [super initWithNibName:@"MGSPrefsEditorProperties" bundle:[NSBundle bundleForClass:[MGSPrefsEditorPropertiesViewController class]]]))
    {
        /* Install this view controller in the responder chain so that it will
         * receive the changeFont message. */
        v = [self view];
        nextResp = [v nextResponder];
        /* Yosemite already does this for us, so don't do it if it is not
         * needed. */
        if (nextResp != self)
        {
            [v setNextResponder:self];
            [self setNextResponder:nextResp];
        }
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
}

- (NSFont *)editorFont
{
    return [self.userDefaultsController.values valueForKey:MGSFragariaDefaultsTextFont];
}


/*
 * - hideableViews
 */
- (NSDictionary *)hideableViews
{
	return @{
			 NSStringFromSelector(@selector(paneEditing)) : [[MGSUserDefaultsDefinitions class] propertyGroupEditing],
			 NSStringFromSelector(@selector(paneGutter)) : [[MGSUserDefaultsDefinitions class] propertyGroupGutter],
			 NSStringFromSelector(@selector(paneAutocomplete)) : [[MGSUserDefaultsDefinitions class] propertyGroupAutocomplete],
			 NSStringFromSelector(@selector(paneIndenting)) : [[MGSUserDefaultsDefinitions class] propertyGroupIndenting],
			 NSStringFromSelector(@selector(paneTextFont)) : [[MGSUserDefaultsDefinitions class] propertyGroupTextFont],
			 };
}


@end
