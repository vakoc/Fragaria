//
//  MGSPrefsColourPropertiesViewController.m
//  Fragaria
//
//  Created by Jim Derry on 3/15/15.
//
//

#import "MGSPrefsColourPropertiesViewController.h"


@interface MGSPrefsColourPropertiesViewController ()

@property (nonatomic, assign, readonly) NSColor *disabledLabelColour;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelText;
@property (nonatomic, weak, readonly) NSColor *colourLabelText;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelBG;
@property (nonatomic, weak, readonly) NSColor *colourLabelBG;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelErrorHighlight;
@property (nonatomic, weak, readonly) NSColor *colourLabelErrorHighlight;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelCurrentLine;
@property (nonatomic, weak, readonly) NSColor *colourLabelCurrentLine;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelInsertionPoint;
@property (nonatomic, weak, readonly) NSColor *colourLabelInsertionPoint;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelInvisibles;
@property (nonatomic, weak, readonly) NSColor *colourLabelInvisibles;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelAutoComplete;
@property (nonatomic, weak, readonly) NSColor *colourLabelAutoComplete;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelAttributes;
@property (nonatomic, weak, readonly) NSColor *colourLabelAttributes;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelCommands;
@property (nonatomic, weak, readonly) NSColor *colourLabelCommands;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelComments;
@property (nonatomic, weak, readonly) NSColor *colourLabelComments;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelInstructions;
@property (nonatomic, weak, readonly) NSColor *colourLabelInstructions;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelKeywords;
@property (nonatomic, weak, readonly) NSColor *colourLabelKeywords;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelNumbers;
@property (nonatomic, weak, readonly) NSColor *colourLabelNumbers;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelStrings;
@property (nonatomic, weak, readonly) NSColor *colourLabelStrings;

@property (nonatomic, weak) IBOutlet NSColorWell *friendColourLabelVariables;
@property (nonatomic, weak, readonly) NSColor *colourLabelVariables;


@end


@implementation MGSPrefsColourPropertiesViewController

/*
 *  - init
 */
- (id)init
{
    self = [super initWithNibName:@"MGSPrefsColourProperties" bundle:[NSBundle bundleForClass:[MGSPrefsColourPropertiesViewController class]]];
    if (self) {

    }
    return self;
}


/*
 *  - viewDidLoad
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do view setup here.
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
 *  @property colourLabelText
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelText
{
    return [NSSet setWithArray:@[@"self.friendColourLabelText.enabled"]];
}

- (NSColor *)colourLabelText
{
    return self.friendColourLabelText.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelBG
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelBG
{
    return [NSSet setWithArray:@[@"self.friendColourLabelBG.enabled"]];
}

- (NSColor *)colourLabelBG
{
    return self.friendColourLabelBG.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelErrorHighlight
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelErrorHighlight
{
    return [NSSet setWithArray:@[@"self.friendColourLabelErrorHighlight.enabled"]];
}

- (NSColor *)colourLabelErrorHighlight
{
    return self.friendColourLabelErrorHighlight.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelCurrentLine
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelCurrentLine
{
    return [NSSet setWithArray:@[@"self.friendColourLabelCurrentLine.enabled"]];
}

- (NSColor *)colourLabelCurrentLine
{
    return self.friendColourLabelCurrentLine.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelInsertionPoint
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelInsertionPoint
{
    return [NSSet setWithArray:@[@"self.friendColourLabelInsertionPoint.enabled"]];
}

- (NSColor *)colourLabelInsertionPoint
{
    return self.friendColourLabelInsertionPoint.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelInvisibles
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelInvisibles
{
    return [NSSet setWithArray:@[@"self.friendColourLabelInvisibles.enabled"]];
}

- (NSColor *)colourLabelInvisibles
{
    return self.friendColourLabelInvisibles.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelAutoComplete
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelAutoComplete
{
    return [NSSet setWithArray:@[@"self.friendColourLabelAutoComplete.enabled"]];
}

- (NSColor *)colourLabelAutoComplete
{
    return self.friendColourLabelAutoComplete.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelAttributes
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelAttributes
{
    return [NSSet setWithArray:@[@"self.friendColourLabelAttributes.enabled"]];
}

- (NSColor *)colourLabelAttributes
{
    return self.friendColourLabelAttributes.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelCommands
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelCommands
{
    return [NSSet setWithArray:@[@"self.friendColourLabelCommands.enabled"]];
}

- (NSColor *)colourLabelCommands
{
    return self.friendColourLabelCommands.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelComments
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelComments
{
    return [NSSet setWithArray:@[@"self.friendColourLabelComments.enabled"]];
}

- (NSColor *)colourLabelComments
{
    return self.friendColourLabelComments.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelInstructions
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelInstructions
{
    return [NSSet setWithArray:@[@"self.friendColourLabelInstructions.enabled"]];
}

- (NSColor *)colourLabelInstructions
{
    return self.friendColourLabelInstructions.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelKeywords
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelKeywords
{
    return [NSSet setWithArray:@[@"self.friendColourLabelKeywords.enabled"]];
}

- (NSColor *)colourLabelKeywords
{
    return self.friendColourLabelKeywords.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelNumbers
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelNumbers
{
    return [NSSet setWithArray:@[@"self.friendColourLabelNumbers.enabled"]];
}

- (NSColor *)colourLabelNumbers
{
    return self.friendColourLabelNumbers.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelStrings
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelStrings
{
    return [NSSet setWithArray:@[@"self.friendColourLabelStrings.enabled"]];
}

- (NSColor *)colourLabelStrings
{
    return self.friendColourLabelStrings.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


/*
 *  @property colourLabelVariables
 */
+ (NSSet *)keyPathsForValuesAffectingColourLabelVariables
{
    return [NSSet setWithArray:@[@"self.friendColourLabelVariables.enabled"]];
}

- (NSColor *)colourLabelVariables
{
    return self.friendColourLabelVariables.enabled ? [NSColor controlTextColor] : self.disabledLabelColour;
}


@end
