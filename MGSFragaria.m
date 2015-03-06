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
#import "SMLTextViewPrivate.h"
#import "MGSPreferencesObserver.h"


// BOOL
NSString * const MGSFOIsSyntaxColoured = @"isSyntaxColoured";
NSString * const MGSFOShowLineNumberGutter = @"showLineNumberGutter";
NSString * const MGSFOHasVerticalScroller = @"hasVerticalScroller";
NSString * const MGSFODisableScrollElasticity = @"disableScrollElasticity";
NSString * const MGSFOLineWrap = @"lineWrap";
NSString * const MGSFOShowsWarningsInGutter = @"showsWarningsInGutter";

// string
NSString * const MGSFOSyntaxDefinitionName = @"syntaxDefinition";

// NSView *
NSString * const ro_MGSFOTextView = @"firstTextView"; // readonly
NSString * const ro_MGSFOScrollView = @"firstTextScrollView"; // readonly

// NSObject
NSString * const MGSFODelegate = @"delegate";
NSString * const MGSFOBreakpointDelegate = @"breakpointDelegate";
NSString * const MGSFOSyntaxColouringDelegate = @"syntaxColouringDelegate";
NSString * const MGSFOAutoCompleteDelegate = @"autoCompleteDelegate";


#pragma mark - Implementation


@implementation MGSFragaria


@synthesize autoCompleteDelegate = _autoCompleteDelegate;
@synthesize syntaxDefinitionName = _syntaxDefinitionName;


// SMLTextView dynamic properties:
@dynamic string;
@dynamic backgroundColor, currentLineHighlightColour, textFont;
@dynamic highlightsCurrentLine, insertionPointColor, lineWrap, pageGuideColumn;
@dynamic syntaxColouring, showsInvisibleCharacters, showsPageGuide, tabWidth, textColor;
@dynamic showsMatchingBraces, insertClosingParenthesisAutomatically, insertClosingBraceAutomatically;
@dynamic indentWithSpaces, indentBracesAutomatically, indentNewLinesAutomatically, useTabStops;
@dynamic autoCompleteDelay, autoCompleteEnabled, autoCompleteWithKeywords;
@dynamic textInvisibleCharactersColour;


// SMLSyntaxColouring dynamic properties:
@dynamic colourForAttributes, colourForAutocomplete, colourForCommands, colourForComments, colourForInstructions;
@dynamic colourForKeywords, colourForNumbers, colourForStrings, colourForVariables, coloursAttributes;
@dynamic coloursAutocomplete, coloursCommands, coloursComments, coloursInstructions, coloursKeywords, coloursNumbers;
@dynamic coloursStrings, coloursVariables, syntaxColouringDelegate, coloursMultiLineStrings;
@dynamic coloursOnlyUntilEndOfLine;

// MGSLineNumberView dynamic properties:
@dynamic startingLineNumber;


#pragma mark - Properties - Document Properties


/*
 * @property syntaxDefinitionName:
 */
- (void)setSyntaxDefinitionName:(NSString *)value
{
	// @todo: (jsd) Perhaps this should move to SMLSytaxColouring?
	// SMLSyntaxColouring has a reference to its Fragaria, so
	// should be okay to set the delegate there.
    NSDictionary *syntaxDict;
    MGSSyntaxDefinition *syntaxDef;
	
    _syntaxDefinitionName = value;
    syntaxDict = [[MGSSyntaxController sharedInstance] syntaxDictionaryWithName:value];
    syntaxDef = [[MGSSyntaxDefinition alloc] initFromSyntaxDictionary:syntaxDict];
    [self.textView.syntaxColouring setSyntaxDefinition:syntaxDef];
    
    /* Update the default autocomplete delegate with the new
     * syntax definition, if needed. */
    if (!self.autoCompleteDelegate)
        [self setAutoCompleteDelegate:nil];
}


- (NSAttributedString *)attributedStringWithTemporaryAttributesApplied
{
    return [self.textView attributedStringWithTemporaryAttributesApplied];
}


#pragma mark - Properties - Overall Appearance and Display


/*
 * @property gutterFont
 */
-(void)setGutterFont:(NSFont *)gutterFont
{
	// @todo: (jsd) Property name harmonization?
    [self.gutterView setFont:gutterFont];
}

-(NSFont *)gutterFont
{
    return [self.gutterView font];
}


/*
 * @property gutterMinimumWidth
 */
- (void)setGutterMinimumWidth:(NSUInteger)gutterMinimumWidth
{
	// @todo: (jsd) This is a candidate for harmonizing the
	// property names and making dynamic (or deleting), too.
	// Would also have to decide to keep CGFloat or force it
	// to NSUInteger.
    self.gutterView.minimumWidth = (CGFloat)gutterMinimumWidth;
}

- (NSUInteger)gutterMinimumWidth
{
    return (NSUInteger)self.gutterView.minimumWidth;
}


/*
 * @property gutterTextColour
 */
-(void)setGutterTextColour:(NSColor *)gutterTextColour
{
	// @todo: (jsd) property name harmonization?
    [self.gutterView setTextColor:gutterTextColour];
}

-(NSColor *)gutterTextColour
{
    return [self.gutterView textColor];
}


/*
 * @property hasVerticalScroller:
 */
- (void)setHasVerticalScroller:(BOOL)value
{
	// @todo: (jsd) Should we override NSScrollView simply
	//        in order to achieve this affect? Or leave it
	//        to the developer to set autoHidesScrollers
	//        himself? If using KVC on the scrollView then
	//        there's going to be a differerence.
    self.scrollView.hasVerticalScroller = value;
    self.scrollView.autohidesScrollers = value;
}

- (BOOL)hasVerticalScroller
{
    return self.scrollView.hasVerticalScroller;
}


/*
 * @property isSyntaxColoured
 */
- (void)setIsSyntaxColoured:(BOOL)value
{
	// @todo: this one's hard to abstract away and make dynamic
	// because forwarding doesn't automatically use KVO's method
	// of checking for _is_ setters and getters. 
	[self.textView.syntaxColouring setSyntaxColoured:value];
}

- (BOOL)isSyntaxColoured
{
	return [self.textView.syntaxColouring isSyntaxColoured];
}


/*
 * @property scrollElasticityDisabled:
 */
- (void)setScrollElasticityDisabled:(BOOL)value
{
	//@todo: (jsd) Here is another argument for subclassing
	//       NSScrollView. It would allow a simple BOOL setter.
    NSScrollElasticity setting = value ? NSScrollElasticityNone : NSScrollElasticityAutomatic;
    [self.scrollView setVerticalScrollElasticity:setting];
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
	// @todo: (jsd) Changing the property name in MGSLineNumberView
	//        would allow making this property dynamic without
	//        breaking the current API.
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
	// @todo: Again subclass the scrollView. Add a synonym for
	// `rulersVisible` called showsGutter and make this dynamic.
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
	// @todo: (jsd) We can practically eliminate ALL
	// of the Fragaria level properties for things that
	// have components doing the work. As there's no
	// plan to expose this (no should there be), I wonder
	// if we should move this property to MGSLineNumberView,
	// and set the syntaxErrorController there.
    self.syntaxErrorController.showSyntaxErrors = value;
}

- (BOOL)showsWarningsInGutter
{
    return self.syntaxErrorController.showSyntaxErrors;
}


#pragma mark - Properties - Syntax Errors


/*
 * @property syntaxErrors:
 */
- (void)setSyntaxErrors:(NSArray *)errors
{
    self.syntaxErrorController.syntaxErrors = errors;
}

- (NSArray *)syntaxErrors
{
    return self.syntaxErrorController.syntaxErrors;
}


#pragma mark - Properties - Delegates


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


/*
 * @property autoCompleteDelegate
 */
- (void)setAutoCompleteDelegate:(id<SMLAutoCompleteDelegate>)autoCompleteDelegate
{
    _autoCompleteDelegate = autoCompleteDelegate;
    if (autoCompleteDelegate)
        [self.textView setAutocompleteDelegate:autoCompleteDelegate];
    else
        [self.textView setAutocompleteDelegate:self.textView.syntaxColouring.syntaxDefinition];
}

- (id<SMLAutoCompleteDelegate>)autoCompleteDelegate
{
    return _autoCompleteDelegate;
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


#pragma mark - Instance Methods


/*
 * - initWithView:
 */
- (instancetype)initWithView:(NSView *)view
{
    return [self initWithView:view useStandardPreferences:YES];
}


/*
 * - initWithView:useStandardPreferences:
 */
- (instancetype)initWithView:(NSView*)view useStandardPreferences:(BOOL)autopref
{
    self = [super init];
    
    [self embedInView:view];
    if (autopref) {
        // create the temporary preferences observer
        _preferencesObserver = [[MGSPreferencesObserver alloc] initWithFragaria:self];
    }
    
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
    else if ([key isEqual:ro_MGSFOScrollView])
        return self.scrollView;
    else if ([key isEqual:ro_MGSFOTextView])
        return self.textView;
    
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
    _scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, [contentView bounds].size.width, [contentView bounds].size.height)];
    NSSize contentSize = [self.scrollView contentSize];
    [self.scrollView setBorderType:NSNoBorder];
    
    [self.scrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [[self.scrollView contentView] setAutoresizesSubviews:YES];
    [self.scrollView setPostsFrameChangedNotifications:YES];
    self.hasVerticalScroller = YES;
    
    // create textview
    _textView = [[SMLTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height)];
    [self.scrollView setDocumentView:self.textView];
    
    // create line numbers
    _gutterView = [[MGSLineNumberView alloc] initWithScrollView:self.scrollView fragaria:self];
    [self.scrollView setVerticalRulerView:self.gutterView];
    [self.scrollView setHasVerticalRuler:YES];
    [self.scrollView setHasHorizontalRuler:NO];
    
    // carryover default syntaxDefinition name from old docSpec
    self.syntaxDefinitionName = [MGSSyntaxController standardSyntaxDefinitionName];
    self.textView.syntaxColouring.fragaria = self;
    
    // add scroll view to content view
    [contentView addSubview:self.scrollView];
    
    // update the gutter view
    self.showsGutter = YES;
    
    _syntaxErrorController = [[MGSSyntaxErrorController alloc] init];
    self.syntaxErrorController.lineNumberView = self.gutterView;
    self.syntaxErrorController.textView = self.textView;
    [self setShowsWarningsInGutter:YES];
    
    [self setAutoCompleteDelegate:nil];
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
 * - replaceTextStorage:
 */
- (void)replaceTextStorage:(NSTextStorage*)textStorage
{
    [self.gutterView layoutManagerWillChangeTextStorage];
    [self.syntaxErrorController layoutManagerWillChangeTextStorage];
    [self.textView.syntaxColouring layoutManagerWillChangeTextStorage];
    
    [self.textView.layoutManager replaceTextStorage:textStorage];
    
    [self.gutterView layoutManagerDidChangeTextStorage];
    [self.syntaxErrorController layoutManagerDidChangeTextStorage];
    [self.textView.syntaxColouring layoutManagerDidChangeTextStorage];
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


#pragma mark - Message Forwarding


/*
 * -forwardingTargetForSelector:
 */
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.textView.syntaxColouring respondsToSelector:aSelector])
        return self.textView.syntaxColouring;
    else if ([self.textView respondsToSelector:aSelector])
        return self.textView;
	else if ([self.gutterView respondsToSelector:aSelector])
		return self.gutterView;
    return nil;
}


@end
