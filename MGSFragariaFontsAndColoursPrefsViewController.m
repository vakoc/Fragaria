//
//  MGSFragariaFontsAndColoursPrefsViewController.m
//  Fragaria
//
//  Created by Jonathan on 14/09/2012.
//
//

#import "MGSFragaria.h"
#import "MGSFragariaFramework.h"

@interface MGSFragariaFontsAndColoursPrefsViewController ()

@end

@implementation MGSFragariaFontsAndColoursPrefsViewController {
    NSFont *editorFont;
}

/*
 *  - init
 */
- (id)init {
    NSBundle *bundle;
    NSView *v;
    id nextResp;
    
    bundle = [NSBundle bundleForClass:[MGSFragariaFontsAndColoursPrefsViewController class]];
    self = [super initWithNibName:@"MGSPreferencesFontsAndColours" bundle:bundle];
    
    if (self) {
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
        
        NSData *fontData = [[NSUserDefaults standardUserDefaults] objectForKey:MGSFragariaPrefsTextFont];
        editorFont = [NSUnarchiver unarchiveObjectWithData:fontData];
    }
    return self;
}


/*
 *  - setFontAction:
 */
- (IBAction)setFontAction:(id)sender
{
    NSFontManager *fontManager = [NSFontManager sharedFontManager];
    [fontManager setSelectedFont:editorFont isMultiple:NO];
	[fontManager orderFrontFontPanel:nil];
}


/*
 *  - changeFont:
 */
- (void)changeFont:(id)sender
{
	NSFontManager *fontManager = sender;
	NSFont *panelFont = [fontManager convertFont:editorFont];
	[[[NSUserDefaultsController sharedUserDefaultsController] values] setValue:[NSArchiver archivedDataWithRootObject:panelFont] forKey:MGSFragariaPrefsTextFont];
}


@end
