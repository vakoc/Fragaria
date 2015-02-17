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


@implementation AppDelegate {
	NSArray *_breakPoints;
}


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
    self.viewTop.startingLineNumber = 2025;
	self.viewTop.showsLineNumbers = YES;
    self.viewTop.lineWrap = NO;

    /* Make the lower view interesting. */
    self.self.viewBottom.string = fileContent;
    //[self.viewBottom bind:@"string" toObject:self.viewTop withKeyPath:@"string" options:nil];
	self.viewBottom.showsLineNumbers = YES;
    self.viewBottom.lineWrap = NO;


	/* Sample Syntax Error Definitions */
    self.viewTop.syntaxErrors = [self makeSyntaxErrors];



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
	breakpointsForView:
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (NSSet*) breakpointsForView:(id)sender
{
	#pragma unused(sender)
    return [NSSet setWithArray:_breakPoints];
}

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	toggleBreakpointForView:onLine
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)toggleBreakpointForView:(id)sender onLine:(int)line;
{
	#pragma unused(sender)
	if ([_breakPoints containsObject:@(line)])
	{
		_breakPoints = [_breakPoints filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
			return ![evaluatedObject isEqualToValue:@(line)];
		}]];
	}
	else
	{
		if (_breakPoints)
		{
			_breakPoints = [_breakPoints arrayByAddingObject:@(line)];
		}
		else
		{
			_breakPoints = @[@(line)];
		}
	}
	
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


#pragma marks - Private


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
