//
//  AppDelegate.h
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/07.
//
//  A playground and demonstration for MGSFragariaView, and
//  Fragaria and Smulton in general.
//

#import "AppDelegate.h"
#import <MGSFragaria/MGSFragaria.h>
#import "MASPreferencesWindowController.h"
#import "PrefsFontsAndColorsViewController.h"
#import "PrefsTextEditingViewController.h"
#import "FeaturesWindowController.h"


#pragma mark - PRIVATE INTERFACE


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet MGSFragariaView *viewTop;

@property (weak) IBOutlet MGSFragariaView *viewBottom;


@property (nonatomic, strong) NSWindowController *preferencesWindowController;

@property (nonatomic, strong) FeaturesWindowController *featuresWindowController;


@property (strong) NSArray *breakpoints;

@end


#pragma mark - IMPLEMENTATION


@implementation AppDelegate

@synthesize preferencesWindowController = _preferencesWindowController;
@synthesize featuresWindowController = _featuresWindowController;


#pragma mark - Initialization and Setup


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	applicationDidFinishLaunching:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	#pragma unused(aNotification)

    /* Get a sample file to pre-populate the views. */
    NSString *file = [[NSBundle mainBundle] pathForResource:@"Lorem" ofType:@"html"];
    NSString *fileContent;
    NSError *error;
    if (file)
    {
        fileContent = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    }
    if (!file || error)
    {
        fileContent = @"<p>There was a nice file to load for you, but some reason I couldn't open it.</p>";
    }

    /* Make the upper view interesting. */
    self.viewTop.textView.string = fileContent;
    self.viewTop.startingLineNumber = 1;
	self.viewTop.showsLineNumbers = YES;
    self.viewTop.textView.lineWrap = NO;

    /* Make the lower view interesting. */
    self.self.viewBottom.string = fileContent;
	self.viewBottom.showsLineNumbers = YES;
    self.viewBottom.lineWrap = NO;


	/* Sample Syntax Error Definitions */
    self.viewTop.syntaxErrors = [self makeSyntaxErrors];
}


#pragma mark - Property Accessors

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	@preferencesWindowController
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (NSWindowController *)preferencesWindowController
{
    if (!_preferencesWindowController)
    {
        NSViewController *fontsAndColorsPrefsController = [[PrefsFontsAndColorsViewController alloc] init];
        NSViewController *textEditingPrefsController = [[PrefsTextEditingViewController alloc] init];
        NSArray *controllers = [[NSArray alloc] initWithObjects:fontsAndColorsPrefsController, textEditingPrefsController, nil];

        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    }
    return _preferencesWindowController;
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	@featuresWindowController
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (NSWindowController *)featuresWindowController
{
    if (!_featuresWindowController)
    {
        _featuresWindowController = [[FeaturesWindowController alloc] initWithWindowNibName:@"Features"];
        _featuresWindowController.viewTop = self.viewTop;
        _featuresWindowController.viewBottom = self.viewBottom;
    }
    return _featuresWindowController;
}


#pragma mark - Delegate methods

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	textDidChange:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)textDidChange:(NSNotification *)notification
{
	#pragma unused(notification)
	NSLog(@"%@", @"textDidChange: notification.");
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	breakpointsForView:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (NSSet*) breakpointsForView:(id)sender
{
	#pragma unused(sender)
    return [NSSet setWithArray:self.breakpoints];
}

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	toggleBreakpointForView:onLine
        This simple demonstration simply toggles breakpoints every
        time the line number is clicked.
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)toggleBreakpointForView:(id)sender onLine:(int)line;
{
	#pragma unused(sender)
	if ([self.breakpoints containsObject:@(line)])
	{
		self.breakpoints = [self.breakpoints filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
			return ![evaluatedObject isEqualToValue:@(line)];
		}]];
	}
	else
	{
		if (self.breakpoints)
		{
			self.breakpoints = [self.breakpoints arrayByAddingObject:@(line)];
		}
		else
		{
			self.breakpoints = @[@(line)];
		}
	}
	
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	concludeDragOperation:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
	#pragma unused(sender)
	NSLog(@"%@", @"concludeDragOperation: delegate method.");
}


#pragma mark - UI Handling

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	openPreferences:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (IBAction)openPreferences:(id)sender
{
    [self.preferencesWindowController showWindow:nil];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	openFeatures:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (IBAction)openFeatures:(id)sender
{
    [self.featuresWindowController showWindow:nil];
}


#pragma mark - Private

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	makeSyntaxErrors
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (NSArray *)makeSyntaxErrors
{
    SMLSyntaxError *error1 = [SMLSyntaxError errorWithDictionary:@{
                                                                   @"description" : @"Syntax errors can be defined",
                                                                   @"line" : @(4),
                                                                   @"character" : @(3),
                                                                   @"length" : @(5),
                                                                   @"hidden" : @(NO),
                                                                   @"warningLevel" : @(kMGSErrorCategoryError)
                                                                   }];

    SMLSyntaxError *error2 = [[SMLSyntaxError alloc] initWithDictionary:@{
                                                                          @"description" : @"Multiple syntax errors can be defined for the same line, too.",
                                                                          @"line" : @(4),
                                                                          @"character" : @(12),
                                                                          @"length" : @(7),
                                                                          @"hidden" : @(NO),
                                                                          @"warningLevel" : @(kMGSErrorCategoryAccess)
                                                                          }];

    SMLSyntaxError *error3 = [[SMLSyntaxError alloc] init];
    error3.description = @"This error will appear on top of a line break.";
    error3.line = 6;
    error3.character = 1;
    error3.length = 2;
    error3.hidden = NO;
    error3.warningLevel = kMGSErrorCategoryConfig;

    SMLSyntaxError *error4 = [SMLSyntaxError new];
    error4.description = @"This error will not be hidden.";
    error4.line = 10;
    error4.character = 12;
    error4.length = 7;
    error4.hidden = NO;

    return @[error1, error2, error3, error4];
}


@end
