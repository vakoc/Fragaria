//
//  AppDelegate.h
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/03/15.
//
//  A playground and demonstration for MGSFragariaView and the new-style
//  preferences panels.
//
//

#import "AppDelegate.h"
#import <MGSFragaria/MGSFragaria.h>
#import "MASPreferencesWindowController.h"
#import "PrefsColorsViewController.h"
#import "PrefsEditorViewController.h"
#import "MGSUserDefaultsController.h"
#import "MGSUserDefaultsDefinitions.h"


#pragma mark - PRIVATE INTERFACE


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet MGSFragariaView *viewTop;

@property (weak) IBOutlet MGSFragariaView *viewBottom;


@property (nonatomic, strong) NSWindowController *preferencesWindowController;


@property (strong) NSArray *breakpoints;

@end


#pragma mark - IMPLEMENTATION


@implementation AppDelegate

@synthesize preferencesWindowController = _preferencesWindowController;


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


    /* Assign groupID's first so they will take values from defaults. In this
       example each "group" will consist of only a single instance of
       MGSFragariaView. The global group will control properties we want to
       keep in common amongst *all* MGSFragariaView instances that are in a
       group. */
    MGSUserDefaultsController *topGroup = [MGSUserDefaultsController sharedControllerForGroupID:@"topWindowGroup"];
    MGSUserDefaultsController *bottomGroup = [MGSUserDefaultsController sharedControllerForGroupID:@"bottomWindowGroup"];
    //MGSUserDefaultsController *globalGroup = [MGSUserDefaultsController sharedController];


    /* In this example, each instance will manage *all* of MGSFragariaView's
       properties, and the topGroup's properties will persist on disk (you can
       see the properties in the topWindowGroup array in this sample app's
       preferences plist after running it once). */
    NSArray *managedProperties = [[MGSUserDefaultsDefinitions fragariaDefaultsDictionary] allKeys];

    topGroup.managedInstances = [NSSet setWithArray:@[self.viewTop]];
    topGroup.managedProperties = [NSSet setWithArray:managedProperties];
    topGroup.persistent = YES;

    bottomGroup.managedInstances = [NSSet setWithArray:@[self.viewBottom]];
    bottomGroup.managedProperties = [NSSet setWithArray:managedProperties];


    /* Make the upper view interesting. */
    self.viewTop.textView.string = fileContent;
    self.viewTop.startingLineNumber = 314;
	self.viewTop.showsLineNumbers = YES;

    /* Make the lower view interesting. */
    [self.viewBottom.fragaria replaceTextStorage:self.viewTop.textView.textStorage];
	self.viewBottom.showsLineNumbers = YES;

    /* These are defined in the user defined runtime properties, but our
       defaults are overwriting them. */
    self.viewTop.syntaxDefinitionName = @"html";
    self.viewBottom.syntaxDefinitionName = @"html";

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
        PrefsEditorViewController *editorPrefsController = [[PrefsEditorViewController alloc] init];
        PrefsColorsViewController *colorsPrefsController = [[PrefsColorsViewController alloc] init];

        // Prefs will control topGroup.
        editorPrefsController.propertiesController = [MGSUserDefaultsController sharedControllerForGroupID:@"topWindowGroup"];
		colorsPrefsController.propertiesController = [MGSUserDefaultsController sharedControllerForGroupID:@"topWindowGroup"];

        NSArray *controllers = @[editorPrefsController, colorsPrefsController];

        NSString *title = NSLocalizedString(@"Preferences", @"Common title for Preferences window");
        _preferencesWindowController = [[MASPreferencesWindowController alloc] initWithViewControllers:controllers title:title];
    }
    return _preferencesWindowController;
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
- (NSSet*) breakpointsForFragaria:(id)sender
{
    return [NSSet setWithArray:self.breakpoints];
}

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	toggleBreakpointForFragaria:onLine
        This simple demonstration simply toggles breakpoints every
        time the line number is clicked.
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)toggleBreakpointForFragaria:(id)sender onLine:(NSUInteger)line;
{
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


#pragma mark - Private

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	makeSyntaxErrors
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (NSArray *)makeSyntaxErrors
{
    SMLSyntaxError *error1 = [SMLSyntaxError errorWithDictionary:@{
                                                                   @"errorDescription" : @"Syntax errors can be defined",
                                                                   @"line" : @(4),
                                                                   @"character" : @(3),
                                                                   @"length" : @(5),
                                                                   @"hidden" : @(NO),
                                                                   @"warningLevel" : @(kMGSErrorCategoryError)
                                                                   }];

    SMLSyntaxError *error2 = [[SMLSyntaxError alloc] initWithDictionary:@{
                                                                          @"errorDescription" : @"Multiple syntax errors can be defined for the same line, too.",
                                                                          @"line" : @(4),
                                                                          @"character" : @(12),
                                                                          @"length" : @(7),
                                                                          @"hidden" : @(NO),
                                                                          @"warningLevel" : @(kMGSErrorCategoryAccess)
                                                                          }];

    SMLSyntaxError *error3 = [[SMLSyntaxError alloc] init];
    error3.errorDescription = @"This error will appear on top of a line break.";
    error3.line = 6;
    error3.character = 1;
    error3.length = 2;
    error3.hidden = NO;
    error3.warningLevel = kMGSErrorCategoryConfig;

    SMLSyntaxError *error4 = [SMLSyntaxError new];
    error4.errorDescription = @"This error will not be hidden.";
    error4.line = 10;
    error4.character = 12;
    error4.length = 7;
    error4.hidden = NO;

    return @[error1, error2, error3, error4];
}


@end
