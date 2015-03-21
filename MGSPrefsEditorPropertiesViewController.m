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


@property (nonatomic, assign) NSFont *editorFont;

@property (nonatomic, assign, readonly) NSColor *disabledLabelColour;

@property (nonatomic, weak) IBOutlet NSTextField *friendColourLabelPageGuide;
@property (nonatomic, assign, readonly) NSColor *colourLabelPageGuide;

@property (nonatomic, weak) IBOutlet NSTextField *friendColourLabelMinimumGutterWidth;
@property (nonatomic, assign, readonly) NSColor *colourLabelMinimumGutterWidth;

@property (nonatomic, weak) IBOutlet NSTextField *friendColourLabelDelay;
@property (nonatomic, assign, readonly) NSColor *colourLabelDelay;

@property (nonatomic, weak) IBOutlet NSTextField *friendColourLabelTabWidth;
@property (nonatomic, assign, readonly) NSColor *colourLabelTabWidth;

@property (nonatomic, weak) IBOutlet NSTextField *friendColourLabelIndentWidth;
@property (nonatomic, assign, readonly) NSColor *colourLabelIndentWidth;


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
    [self.propertiesController.values setValue:editorFont forKey:MGSFragariaDefaultsTextFont];
}

- (NSFont *)editorFont
{
    return [self.propertiesController.values valueForKey:MGSFragariaDefaultsTextFont];
}


/*
 *  @property disabledLabelColour
 *  Labels don't have a disabled appearance and there's no boolean value
 *  transformer, so get the label color here.
 */
- (NSColor *)disabledLabelColour
{
	// return [NSColor secondarySelectedControlColor];
	return [[NSColor controlTextColor] colorWithAlphaComponent:0.25];
}


/*
 *  @property colourLabelPageGuide
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelPageGuide
{
	return [NSSet setWithArray:@[@"self.friendColourLabelPageGuide.enabled"]];
}

- (NSColor *)colourLabelPageGuide
{
    return self.friendColourLabelPageGuide.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelMinimumGutterWidth
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelMinimumGutterWidth
{
	return [NSSet setWithArray:@[@"self.friendColourLabelMinimumGutterWidth.enabled"]];
}

- (NSColor *)colourLabelMinimumGutterWidth
{
    return self.friendColourLabelMinimumGutterWidth.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelDelay
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelDelay
{
	return [NSSet setWithArray:@[@"self.friendColourLabelDelay.enabled"]];
}

- (NSColor *)colourLabelDelay
{
    return self.friendColourLabelDelay.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelTabWidth
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelTabWidth
{
	return [NSSet setWithArray:@[@"self.friendColourLabelTabWidth.enabled"]];
}

- (NSColor *)colourLabelTabWidth
{
    return self.friendColourLabelTabWidth.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelIndentWidth
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelIndentWidth
{
	return [NSSet setWithArray:@[@"self.friendColourLabelIndentWidth.enabled"]];
}

- (NSColor *)colourLabelIndentWidth
{
    return self.friendColourLabelIndentWidth.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


@end
