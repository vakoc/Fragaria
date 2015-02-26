//
//  MGSFragaria.m
//  Fragaria
//
//  Created by Jonathan on 05/05/2010.
//  Copyright 2010 mugginsoft.com. All rights reserved.
//

#import "MGSFragariaFramework.h"
#import "MGSFragaria.h"
#import "MGSFragariaPrivate.h"


// BOOL
NSString * const MGSFOIsSyntaxColoured = @"isSyntaxColoured";
NSString * const MGSFOShowLineNumberGutter = @"showLineNumberGutter";
NSString * const MGSFOHasVerticalScroller = @"hasVerticalScroller";
NSString * const MGSFODisableScrollElasticity = @"disableScrollElasticity";
NSString * const MGSFOLineWrap = @"lineWrap";
NSString * const MGSFOShowsWarningsInGutter = @"showsWarningsInGutter";

// string
NSString * const MGSFOSyntaxDefinitionName = @"syntaxDefinition";

// class name strings
// @todo: expose these to allow subclass name definition
// @todo: (jsd) Is this still a valid todo? Strings aren't used anywhere
//        and there's no infrastructure in place to allow substituting
//        other classes.
NSString * const MGSFOEditorTextViewClassName = @"editorTextViewClassName";
NSString * const MGSFOLineNumbersClassName = @"lineNumbersClassName";
NSString * const MGSFOGutterTextViewClassName = @"gutterTextViewClassName";
NSString * const MGSFOSyntaxColouringClassName = @"syntaxColouringClassName";

// NSView *
NSString * const ro_MGSFOTextView = @"firstTextView"; // readonly
NSString * const ro_MGSFOScrollView = @"firstTextScrollView"; // readonly

// NSObject
NSString * const MGSFODelegate = @"delegate";
NSString * const MGSFOBreakpointDelegate = @"breakpointDelegate";
NSString * const MGSFOSyntaxColouringDelegate = @"syntaxColouringDelegate";
NSString * const MGSFOAutoCompleteDelegate = @"autoCompleteDelegate";


// KVO context constants
char kcGutterWidthPrefChanged;
char kcSyntaxColourPrefChanged;
char kcSpellCheckPrefChanged;
char kcLineNumberPrefChanged;
char kcLineWrapPrefChanged;


@interface MGSFragaria ()

- (void)updateGutterView;

@end


#pragma mark - Implementation

@implementation MGSFragaria

@synthesize extraInterfaceController = _extraInterfaceController;
@synthesize syntaxErrorController = _syntaxErrorController;
@synthesize syntaxColouring = _syntaxColouring;

@synthesize docSpec;


#pragma mark - Properties - Document Properties

/*
 * @property documentName:
 * (synthesized)
 */


/*
 * @property syntaxDefinitionName:
 */
- (void)setSyntaxDefinitionName:(NSString *)value
{
    self.syntaxColouring.syntaxDefinitionName = value;
}

- (NSString *)syntaxDefinitionName
{
    return self.syntaxColouring.syntaxDefinitionName;
}


/*
 * @property string:
 */
- (void)setString:(NSString *)aString
{
	[self.textView setString:aString];
}

- (NSString *)string
{
	return self.textView.string;
}


/*
 * @property attributedString:
 */
- (void)setAttributedString:(NSAttributedString *)aString
{
	[self.textView setAttributedString:aString];
}

- (NSAttributedString *)attributedString
{
	return self.textView.attributedString;
}


/*
 * @property attributedStringWithTemporaryAttributesApplied
 */
- (NSAttributedString *)attributedStringWithTemporaryAttributesApplied
{
    // recolour the entire textview content
    [self.syntaxColouring pageRecolourTextView:self.textView options: @{ @"colourAll" : @(YES) }];

    // get content with layout manager temporary attributes persisted
    SMLLayoutManager *layoutManager = (SMLLayoutManager *)[self.textView layoutManager];

    return [layoutManager attributedStringWithTemporaryAttributesApplied];
}


#pragma mark - Properties - Overall Appearance and Display


/*
 * @property hasVerticalScroller:
 */
- (void)setHasVerticalScroller:(BOOL)value
{
    self.scrollView.hasVerticalScroller = value;
    self.scrollView.autohidesScrollers = value;
}

- (BOOL)hasVerticalScroller
{
    return self.scrollView.hasVerticalScroller;
}


/*
 * @property lineWrap:
 */
- (void)setLineWrap:(BOOL)value
{
    [self.textView setLineWrap:value];
    [self updateGutterView];
    [self updateErrorHighlighting];
}

- (BOOL)lineWrap
{
    return [self.textView lineWrap];
}


/*
 * @property scrollElasticityDisabled:
 */
- (void)setScrollElasticityDisabled:(BOOL)value
{
    NSScrollElasticity setting = value ? NSScrollElasticityNone : NSScrollElasticityAutomatic;
    [self.scrollView setVerticalScrollElasticity:setting];

    //    [self updateGutterView];
}

- (BOOL)scrollElasticityDisabled
{
    return (self.scrollView.verticalScrollElasticity == NSScrollElasticityNone);
}


/*
 * @property showsLineNumbers:
 */
- (void)setShowsLineNumbers:(BOOL)value
{
    self.gutterView.drawsLineNumbers = value;
}

- (BOOL)showsLineNumbers
{
    return self.gutterView.drawsLineNumbers;
}

/*
 * @property showsGutter
 */
- (void)setShowsGutter:(BOOL)showsGutter
{
    self.scrollView.rulersVisible = showsGutter;
}

- (BOOL)showsGutter
{
    return self.scrollView.rulersVisible;
}


/*
 * @property showsWarningsInGutter
 */
- (void)setShowsWarningsInGutter:(BOOL)value
{
    self.gutterView.showsWarnings = value;
    [self updateGutterView];
}

- (BOOL)showsWarningsInGutter
{
    return self.gutterView.showsWarnings;
}


/*
 * @property startingLineNumber:
 */
- (void)setStartingLineNumber:(NSUInteger)value
{
    [self.gutterView setStartingLineNumber:value];
}

- (NSUInteger)startingLineNumber
{
    return [self.gutterView startingLineNumber];
}


/*
 * @property isSyntaxColoured
 */
- (void)setIsSyntaxColoured:(BOOL)value
{
    [self.syntaxColouring setSyntaxColoured:value];
}

- (BOOL)isSyntaxColoured
{
    return [self.syntaxColouring isSyntaxColoured];
}


#pragma mark - Properties - Syntax Errors


/*
 * @property syntaxErrors:
 */
- (void)setSyntaxErrors:(NSArray *)errors
{
    self.syntaxErrorController.syntaxErrors = errors;
    [self.syntaxColouring highlightErrors];
    [self.gutterView setNeedsDisplay:YES];
}

- (NSArray *)syntaxErrors
{
    return self.syntaxErrorController.syntaxErrors;
}


#pragma mark - Properties - Delegates


/*
 * @property syntaxColouringDelegate
 */
- (void)setSyntaxColouringDelegate:(id<SMLSyntaxColouringDelegate>)syntaxColouringDelegate
{
    [self.syntaxColouring setSyntaxColouringDelegate:syntaxColouringDelegate];
}

- (id<SMLSyntaxColouringDelegate>)syntaxColouringDelegate
{
    return [self.syntaxColouring syntaxColouringDelegate];
}


/*
 * @property breakpointDelegate
 */
- (void)setBreakpointDelegate:(id<MGSBreakpointDelegate>)breakpointDelegate
{
    [self.gutterView setBreakpointDelegate:breakpointDelegate];
}

- (id<MGSBreakpointDelegate>)breakpointDelegate
{
    return self.gutterView.breakpointDelegate;
}


/*
 * @property textViewDelegate
 */
- (void)setTextViewDelegate:(id<MGSFragariaTextViewDelegate, MGSDragOperationDelegate>)textViewDelegate
{
    [self.textView setDelegate:textViewDelegate];
}

- (id<MGSFragariaTextViewDelegate>)textViewDelegate
{
    return self.textView.delegate;
}


#pragma mark - Properties - System Components


/*
 * @property extraInterfaceController
 */
- (void)setExtraInterfaceController:(MGSExtraInterfaceController *)extraInterfaceController
{
	_extraInterfaceController = extraInterfaceController;
}

- (MGSExtraInterfaceController *)extraInterfaceController
{
	if (!_extraInterfaceController)
		_extraInterfaceController = [[MGSExtraInterfaceController alloc] init];
	return _extraInterfaceController;
}


/*
 * @property syntaxErrorController
 */
- (void)setSyntaxErrorController:(MGSSyntaxErrorController *)syntaxErrorController
{
    _syntaxErrorController = syntaxErrorController;
}

- (MGSSyntaxErrorController *)syntaxErrorController
{
    if (!_syntaxErrorController)
        _syntaxErrorController = [[MGSSyntaxErrorController alloc] init];
    return _syntaxErrorController;
}


/*
 * @property syntaxColouring
 */
- (void)setSyntaxColouring:(SMLSyntaxColouring *)syntaxColouring
{
    _syntaxColouring = syntaxColouring;
}

- (SMLSyntaxColouring *)syntaxColouring
{
    if (!_syntaxColouring)
        _syntaxColouring = [[SMLSyntaxColouring alloc] initWithFragaria:self];
    return _syntaxColouring;
}


/*
 * @property textView
 * (snythesized)
 */


/*
 * @property docSpec
 * (synthesized)
 */


#pragma mark - Class methods

/*
 * + initialize
 */
+ (void)initialize
{
    [MGSFragariaPreferences initializeValues];
}


/*
 * + createDocSpec
 */
+ (id)createDocSpec
{
    NSLog(@"This method is deprecated and has no effect.");
    return nil;
}


/*
 * + docSpec:setString:
 */
+ (void)docSpec:(id)docSpec setString:(NSString *)string
{
    NSLog(@"This method is deprecated and has no effect. Use the instance-based equivalent instead.");
}


/*
 * + docSpec:setString:options:
 */
+ (void)docSpec:(id)docSpec setString:(NSString *)string options:(NSDictionary *)options
{
    NSLog(@"This method is deprecated and has no effect. Use the instance-based equivalent instead.");
}


/*
 * docSpec:setAttributedString
 */
+ (void)docSpec:(id)docSpec setAttributedString:(NSAttributedString *)string
{
    NSLog(@"This method is deprecated and has no effect. Use the instance-based equivalent instead.");
}


/*
 * + docSpec:setAttributedString:options:
 */
+ (void)docSpec:(id)docSpec setAttributedString:(NSAttributedString *)string options:(NSDictionary *)options
{
    NSLog(@"This method is deprecated and has no effect. Use the instance-based equivalent instead.");
}


/*
 * + stringForDocSpec:
 */
+ (NSString *)stringForDocSpec:(id)docSpec
{
    NSLog(@"This method is deprecated and has no effect. Use the instance-based equivalent instead.");

    return nil;
}


/*
 * + attributedStringForDocSpec:
 */
+ (NSAttributedString *)attributedStringForDocSpec:(id)docSpec
{
    NSLog(@"This method is deprecated and has no effect. Use the instance-based equivalent instead.");

    return nil;
}


#pragma mark - Class methods (deprecated)

/*
 
 + currentInstance;
 
 */
+ (id)currentInstance
{
    NSLog(@"This method is deprecated and has no effect. Send action messages "
       "using -[NSApp sendAction:to:from], and retrieve Fragaria's "
       "properties by using the appropriate MGSFragaria instance directly.");
    return nil;
}

/*
 
 + currentInstance;
 
 */
+ (void)setCurrentInstance:(MGSFragaria *)anInstance
{
    NSLog(@"This method is deprecated and has no effect. Send action messages "
        "using -[NSApp sendAction:to:from], and retrieve Fragaria's "
        "properties by using the appropriate MGSFragaria instance directly.");
}

/*
 * + imageNamed
 */

+ (NSImage *) imageNamed:(NSString *)name
{
    NSLog(@"This method is deprecated and has no effect. It used to load images "
          "from the framework bundle, but that's probably not what you want. "
          "Load your own images from your application's own bundle instead.");
    return nil;
}

/*
 * + attributedStringWithTemporaryAttributesAppliedForDocSpec:
 */
+ (NSAttributedString *)attributedStringWithTemporaryAttributesAppliedForDocSpec:(id)docSpec
{
    NSLog(@"This method is deprecated and has no effect. Use the property "
          "attributedStringWithTemporaryAttributesApplied instead.");
    return nil;
}


#pragma mark - Instance Methods


/*
 * - initWithObject
 *
 * Designated initializer
 *
 * Calling this method enables us to use a predefined object for our doc spec.
 */
- (id)initWithObject:(id)object
{
	if ((self = [super init])) {

        // observe defaults that affect rendering
        // @todo: (jsd) Will have to delete this. Application is responsible for preferences
        //        and setting properties based on those. Future preferences framework.
        NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaGutterWidth" options:NSKeyValueObservingOptionNew context:&kcGutterWidthPrefChanged];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaSyntaxColourNewDocuments" options:NSKeyValueObservingOptionNew context:&kcSyntaxColourPrefChanged];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaAutoSpellCheck" options:NSKeyValueObservingOptionNew context:&kcSpellCheckPrefChanged];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaShowLineNumberGutter" options:NSKeyValueObservingOptionNew context:&kcLineNumberPrefChanged];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaLineWrapNewDocuments" options:NSKeyValueObservingOptionNew context:&kcLineWrapPrefChanged];
    }

	return self;
}


/*
 * - initWithView:
 */
- (instancetype)initWithView:(NSView *)view
{
    self = [self initWithObject:nil];
    [self embedInView:view];
    return self;
}


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


/*
 * - setObject:forKey:
 */

- (void)setObject:(id)object forKey:(id)key
{
    if ([key isEqual:MGSFOShowsWarningsInGutter]) {
        NSLog(@"Using setObject:forKey: with the MGSFOShowsWarningsInGutter "
              "property is not supported and has no effect. Please use "
              "setShowsWarningsInGutter:");
        return;
    } else if ([key isEqual:MGSFOSyntaxColouringDelegate]) {
        [self setSyntaxColouringDelegate:object];
        return;
    } else if ([key isEqual:MGSFOBreakpointDelegate]) {
        [self setBreakpointDelegate:object];
        return;
    } else if ([key isEqual:MGSFODelegate]) {
        [self setTextViewDelegate:object];
        return;
    } else if ([key isEqual:MGSFOAutoCompleteDelegate]) {
        [self setAutoCompleteDelegate:object];
        return;
    } else if ([key isEqual:MGSFOIsSyntaxColoured]) {
        [self setIsSyntaxColoured:[object boolValue]];
        return;
    } else if ([key isEqual:MGSFOSyntaxDefinitionName]) {
        [self setSyntaxDefinitionName:object];
         return;
    } else if ([key isEqual:MGSFOShowLineNumberGutter]) {
        [self setShowsGutter:[object boolValue]];
        return;
    } else if ([key isEqual:MGSFOHasVerticalScroller]) {
        [self setHasVerticalScroller:[object boolValue]];
        return;
    } else if ([key isEqual:MGSFODisableScrollElasticity]) {
        [self setScrollElasticityDisabled:[object boolValue]];
        return;
    } else if ([key isEqual:MGSFOLineWrap]) {
        [self setLineWrap:[object boolValue]];
        return;
    }
}


/*
 * - objectForKey:
 */
- (id)objectForKey:(id)key
{
    if ([key isEqual:MGSFOSyntaxColouringDelegate])
        return self.syntaxColouringDelegate;
    else if ([key isEqual:MGSFOBreakpointDelegate])
        return self.breakpointDelegate;
    else if ([key isEqual:MGSFODelegate])
        return self.textViewDelegate;
    else if ([key isEqual:MGSFOAutoCompleteDelegate])
        return self.autoCompleteDelegate;
    else if ([key isEqual:MGSFOIsSyntaxColoured])
        return @(self.isSyntaxColoured);
    else if ([key isEqual:MGSFOSyntaxDefinitionName])
         return self.syntaxDefinitionName;
    else if ([key isEqual:MGSFOShowLineNumberGutter])
        return @(self.showsGutter);
    else if ([key isEqual:MGSFOHasVerticalScroller])
        return @(self.hasVerticalScroller);
    else if ([key isEqual:MGSFODisableScrollElasticity])
        return @(self.scrollElasticityDisabled);
    else if ([key isEqual:MGSFOLineWrap])
        return @(self.lineWrap);

    return nil;
}


#pragma clang diagnostics pop


/*
 * - embedInView:
 */
- (void)embedInView:(NSView *)contentView
{
    NSAssert(contentView != nil, @"A content view must be provided.");
    
    // create text scrollview
	self.scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, [contentView bounds].size.width, [contentView bounds].size.height)];
	NSSize contentSize = [self.scrollView contentSize];
	[self.scrollView setBorderType:NSNoBorder];

	[self.scrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	[[self.scrollView contentView] setAutoresizesSubviews:YES];
	[self.scrollView setPostsFrameChangedNotifications:YES];
		
	// create textview
    self.textView = [[SMLTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height) fragaria:self];
	[self.scrollView setDocumentView:self.textView];

    // create line numbers
    self.gutterView = [[MGSLineNumberView alloc] initWithScrollView:self.scrollView fragaria:self];
    [self.scrollView setVerticalRulerView:self.gutterView];
    [self.scrollView setHasVerticalRuler:YES];
    [self.scrollView setHasHorizontalRuler:NO];
    
    MGSLineNumberDefaultsObserver *lineNumbers = [[MGSLineNumberDefaultsObserver alloc] initWithLineNumberView:self.gutterView];
    self.lineNumberDefObserv = lineNumbers;
	
    // carryover default syntaxDefinition name from old docSpec
    self.syntaxDefinitionName = @"Standard";

    // add syntax colouring
    [self.syntaxColouring recolourExposedRange];
	
	// add scroll view to content view
	[contentView addSubview:self.scrollView];
	
    // update the gutter view
    [self updateGutterView];
    [self.scrollView setRulersVisible:[self showsLineNumbers]];

    // apply default line wrapping
    [self.textView setLineWrap:[[SMLDefaults valueForKey:MGSFragariaPrefsLineWrapNewDocuments] boolValue]];

    [self setShowsWarningsInGutter:YES];
}


/*
 * - replaceCharactersInRange:withString:options
 */
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)text options:(NSDictionary *)options
{
    SMLTextView *textView = [self textView];
    [textView replaceCharactersInRange:range withString:text options:options];
}


/*
 * - goToLine:centered:highlight:
 */
- (void)goToLine:(NSInteger)lineToGoTo centered:(BOOL)centered highlight:(BOOL)highlight
{
    if (centered)
        NSLog(@"Warning: centered option is ignored.");
    [self.textView performGoToLine:lineToGoTo setSelected:highlight];
}


/*
 * - setString:options:
*/
- (void)setString:(NSString *)aString options:(NSDictionary *)options
{
	[self.textView setString:aString options:options];
}


/*
 * - setAttributedString:options:
 */
- (void)setAttributedString:(NSAttributedString *)aString options:(NSDictionary *)options
{
	[self.textView setAttributedString:aString options:options];
}


/*
 * - reloadString
 */
- (void)reloadString
{
    [self setString:[self string]];
}


#pragma mark - Instance Methods (deprecated)


/*
 * - textMenuController
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (MGSTextMenuController *)textMenuController
{
    return [MGSTextMenuController sharedInstance];
}
#pragma clang diagnostic pop


#pragma mark - Properties Internal Properties from MGSFragariaPrivate.h


/*
 * @property internalAutoCompleteDelegate
 */
- (id<SMLAutoCompleteDelegate>)internalAutoCompleteDelegate
{
    if (self.autoCompleteDelegate)
        return self.autoCompleteDelegate;
    else
        return self.syntaxColouring;
}


#pragma mark - KVO
/*
 
 - observeValueForKeyPath:ofObject:change:context:
 
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    BOOL boolValue;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	if (context == &kcGutterWidthPrefChanged) {

        [self updateGutterView];

    } else if (context == &kcLineNumberPrefChanged) {
        
        boolValue = [defaults boolForKey:MGSFragariaPrefsShowLineNumberGutter];
        [self setShowsGutter:boolValue];
        
    } else if (context == &kcSyntaxColourPrefChanged) {
        
        boolValue = [defaults boolForKey:MGSFragariaPrefsSyntaxColourNewDocuments];
        [self setIsSyntaxColoured:boolValue];
        
    } else if (context == &kcSpellCheckPrefChanged) {
        
        boolValue = [defaults boolForKey:MGSFragariaPrefsAutoSpellCheck];
        [[self textView] setContinuousSpellCheckingEnabled:boolValue];
        
    } else if (context == &kcLineWrapPrefChanged) {
        
        boolValue = [defaults boolForKey:MGSFragariaPrefsLineWrapNewDocuments];
        [[self textView] setLineWrap:boolValue];
        
    } else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


#pragma mark - Class extension
/*
 * - updateGutterView
 */
- (void) updateGutterView {
    [self.lineNumberDefObserv updateGutterView];
}


/*
 * - updateErrorHighlighting
 */
- (void) updateErrorHighlighting {
    [self.syntaxColouring highlightErrors];
}


@end
