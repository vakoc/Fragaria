//
//  MGSPrefsColourPropertiesViewController.m
//  Fragaria
//
//  Created by Jim Derry on 3/15/15.
//
//

#import "MGSPrefsColourPropertiesViewController.h"
#import "MGSFragariaView+Definitions.h"


@interface MGSPrefsColourPropertiesViewController ()

@property IBOutlet NSView *paneScheme;
@property IBOutlet NSView *paneEditorColours;
@property IBOutlet NSView *paneSyntaxColours;
@property IBOutlet NSView *paneOtherSettings;

@end


@implementation MGSPrefsColourPropertiesViewController

/*
 *  - init
 */
- (id)init
{
    NSBundle *bundle;
    NSView *view;
    CGFloat width;
    
    self = [super init];
    bundle = [NSBundle bundleForClass:[MGSPrefsColourPropertiesViewController class]];
    [bundle loadNibNamed:@"MGSPrefsColourProperties" owner:self topLevelObjects:nil];
    
    width = [self.paneScheme frame].size.width;
    view = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, width, 0)];
    [self setView:view];
    
    return self;
}


/*
 * - hideableViews
 */
- (NSDictionary *)propertiesForPanelSubviews
{
	return @{
			 NSStringFromSelector(@selector(paneScheme)) : [MGSFragariaView propertyGroupTheme],
			 NSStringFromSelector(@selector(paneEditorColours)) : [MGSFragariaView propertyGroupEditorColours],
			 NSStringFromSelector(@selector(paneSyntaxColours)) : [MGSFragariaView propertyGroupSyntaxHighlighting],
			 NSStringFromSelector(@selector(paneOtherSettings)) : [MGSFragariaView propertyGroupColouringExtraOptions],
			 };
}


/*
 * - keysForPanelSubviews
 */
- (NSArray *)keysForPanelSubviews
{
    return @[
        NSStringFromSelector(@selector(paneScheme)),
        NSStringFromSelector(@selector(paneEditorColours)),
        NSStringFromSelector(@selector(paneSyntaxColours)),
        NSStringFromSelector(@selector(paneOtherSettings))
    ];
}


@end
