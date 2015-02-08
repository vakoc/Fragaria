//
//  AppDelegate.h
//  MGSFragariaView Demo
//
//  Created by Jim Derry on 2015/02/07.
//
//  A playgroundd and demonstration for MGSFragariaView, and
//  Fragaria and Smulton in general.
//

#import "AppDelegate.h"
#import "MGSFragariaFramework.h"


#pragma mark - PRIVATE INTERFACE


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (weak) IBOutlet MGSFragariaView *viewTop;

@property (weak) IBOutlet MGSFragariaView *viewBottom;

@property (weak) IBOutlet NSToolbarItem *buttonToggleHighlighting;

@property (weak) IBOutlet NSToolbarItem * buttonToggleLineNumbers;

@property (weak) IBOutlet NSToolbarItem * buttonToggleWordWrap;

@end


#pragma mark - IMPLEMENTATION


@implementation AppDelegate


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
    self.viewTop.string = fileContent;
    //self.viewTop.startingLineNumber = 2025;
	self.viewTop.showsLineNumbers = YES;
    self.viewTop.lineWrap = NO;

    /* Make the lower view interesting. */
    self.self.viewBottom.string = fileContent;
    //[self.viewBottom bind:@"string" toObject:self.viewTop withKeyPath:@"string" options:nil];
	self.viewBottom.showsLineNumbers = YES;
    self.viewBottom.lineWrap = NO;


	/* Sample Syntax Error Definitions */
    //self.viewTop.syntaxErrors = [self makeSyntaxErrors];



}


#pragma mark - Delegate methods


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	textDidChange:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)textDidChange:(NSNotification *)notification
{
	#pragma unused(notification)
	NSLog(@"%@", @"I'm the delegate.");

	// proving that `string` isn't KVC compliant.
	[self.viewTop willChangeValueForKey:@"string"];
	[self.viewTop didChangeValueForKey:@"string"];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	breakpointsForFile:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (NSSet*) breakpointsForFile:(NSString*)file
{
	#pragma unused(file)
	NSLog(@"%@", @"I'm the breakpoints delegate.");
    //return [NSSet setWithArray:@[@(6)]];
    return nil;
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	concludeDragOperation:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
	#pragma unused(sender)
	NSLog(@"%@", @"Something dropped here.");
}


#pragma mark - UI Handling


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	handleToggleLineNumbers:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (IBAction)handleToggleLineNumbers:(id)sender
{
	#pragma unused(sender)
	self.viewTop.showsLineNumbers = !self.viewTop.showsLineNumbers;
	self.viewBottom.showsLineNumbers = !self.viewBottom.showsLineNumbers;
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	handleToggleHighlighting:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (IBAction)handleToggleHighlighting:(id)sender
{
	#pragma unused(sender)
	self.viewTop.syntaxColoured = !self.viewTop.syntaxColoured;
	self.viewBottom.syntaxColoured = !self.viewBottom.syntaxColoured;
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	handleToggleLineWrap:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (IBAction)handleToggleLineWrap:(id)sender
{
	#pragma unused(sender)
	self.viewTop.lineWrap = !self.viewTop.lineWrap;
	self.viewBottom.lineWrap = !self.viewBottom.lineWrap;
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	handleToggleGutterWarnings:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (IBAction)handleToggleGutterWarnings:(id)sender
{
    #pragma unused(sender)
    self.viewTop.showsWarningsInGutter = !self.viewTop.showsWarningsInGutter;
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	handleToggleEditorWarnings:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (IBAction)handleToggleEditorWarnings:(id)sender
{
    #pragma unused(sender)
    BOOL current = self.viewTop.showsWarningsInEditor;
    self.viewTop.showsWarningsInEditor = !current;
}


#pragma marks - Private


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	makeSyntaxErrors
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (NSArray *)makeSyntaxErrors
{
    SMLSyntaxError *syntaxError = [SMLSyntaxError new];
    syntaxError.description = @"Syntax errors can be defined";
    syntaxError.line = 4;
    syntaxError.character = 3;
    syntaxError.length = 5;
    syntaxError.hideWarning = YES;
    syntaxError.warningStyle = kMGSErrorError;
    //syntaxError.customBackgroundColor = [NSColor magentaColor];

    SMLSyntaxError *syntaxError2 = [SMLSyntaxError new];
    syntaxError2.description = @"Multiple syntax errors can be defined for the same line, too.";
    syntaxError2.line = 4;
    syntaxError2.character = 12;
    syntaxError2.length = 7;
    syntaxError2.hideWarning = NO;
    syntaxError2.warningStyle = kMGSErrorAccess;
    //syntaxError2.customBackgroundColor = syntaxError.customBackgroundColor; // messy coloring if you use different colors on the same line!

    SMLSyntaxError *syntaxError3 = [SMLSyntaxError new];
    syntaxError3.description = @"This error will appear on top of a line break.";
    syntaxError3.line = 6;
    syntaxError3.character = 1;
    syntaxError3.length = 2;
    syntaxError3.hideWarning = NO;
    syntaxError3.warningStyle = kMGSErrorConfig;
    //syntaxError2.customBackgroundColor = syntaxError.customBackgroundColor; // messy coloring if you use different colors on the same line!

    SMLSyntaxError *syntaxError4 = [SMLSyntaxError new];
    syntaxError4.description = @"This error will be hidden.";
    syntaxError4.line = 10;
    syntaxError4.character = 12;
    syntaxError4.length = 7;
    syntaxError4.hideWarning = NO;
    //syntaxError2.customBackgroundColor = syntaxError.customBackgroundColor; // messy coloring if you use different colors on the same line!

    return @[syntaxError, syntaxError2, syntaxError3, syntaxError4];
}

@end
