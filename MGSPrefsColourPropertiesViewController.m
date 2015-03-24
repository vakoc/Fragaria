//
//  MGSPrefsColourPropertiesViewController.m
//  Fragaria
//
//  Created by Jim Derry on 3/15/15.
//
//

#import "MGSPrefsColourPropertiesViewController.h"
#import "MGSUserDefaultsDefinitions.h"


@interface MGSPrefsColourPropertiesViewController ()

@property (nonatomic, assign) IBOutlet NSView *paneScheme;
@property (nonatomic, assign) IBOutlet NSView *paneEditorColours;
@property (nonatomic, assign) IBOutlet NSView *paneSyntaxColours;
@property (nonatomic, assign) IBOutlet NSView *paneOtherSettings;

@end


@implementation MGSPrefsColourPropertiesViewController

/*
 *  - init
 */
- (id)init
{
    self = [super initWithNibName:@"MGSPrefsColourProperties" bundle:[NSBundle bundleForClass:[MGSPrefsColourPropertiesViewController class]]];
    if (self)
	{
		[self view]; // Don't lazy load. We need you!
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
 * - hideableViews
 */
- (NSDictionary *)hideableViews
{
	return @{
			 NSStringFromSelector(@selector(paneScheme)) : [[MGSUserDefaultsDefinitions class] propertyGroupTheme],
			 NSStringFromSelector(@selector(paneEditorColours)) : [[MGSUserDefaultsDefinitions class] propertyGroupEditorColours],
			 NSStringFromSelector(@selector(paneSyntaxColours)) : [[MGSUserDefaultsDefinitions class] propertyGroupSyntaxHighlighting],
			 NSStringFromSelector(@selector(paneOtherSettings)) : [[MGSUserDefaultsDefinitions class] propertyGroupColouringExtraOptions],
			 };
}

@end
