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

@implementation MGSFragariaFontsAndColoursPrefsViewController

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
    }
    return self;
}


/*
 *  - setFontAction:
 */
- (IBAction)setFontAction:(id)sender
{
#pragma unused(sender)
    
	NSFontManager *fontManager = [NSFontManager sharedFontManager];
    NSData *fontData = [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:MGSFragariaPrefsTextFont];
    NSFont *font = [NSUnarchiver unarchiveObjectWithData:fontData];
	[fontManager setSelectedFont:font isMultiple:NO];
	[fontManager orderFrontFontPanel:nil];
}


/*
 *  - changeFont:
 */
- (void)changeFont:(id)sender
{
	NSFontManager *fontManager = sender;
	NSFont *panelFont = [fontManager convertFont:[fontManager selectedFont]];
	[[[NSUserDefaultsController sharedUserDefaultsController] values] setValue:[NSArchiver archivedDataWithRootObject:panelFont] forKey:MGSFragariaPrefsTextFont];
}


@end
