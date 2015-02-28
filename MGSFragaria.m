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
#import "MGSTemporaryPreferencesObserver.h"


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


@interface MGSFragaria ()

@end


#pragma mark - Implementation


@implementation MGSFragaria


@synthesize syntaxErrorController = _syntaxErrorController;
@synthesize syntaxColouring = _syntaxColouring;

@synthesize autoCompleteDelegate = _autoCompleteDelegate;
@synthesize syntaxDefinitionName = _syntaxDefinitionName;


#pragma mark - Properties - Document Properties


/*
 * @property syntaxDefinitionName:
 */
- (void)setSyntaxDefinitionName:(NSString *)value
{
    NSDictionary *syntaxDict;
    MGSSyntaxDefinition *syntaxDef;
    
    _syntaxDefinitionName = value;
    syntaxDict = [[MGSSyntaxController sharedInstance] syntaxDictionaryWithName:value];
    syntaxDef = [[MGSSyntaxDefinition alloc] initFromSyntaxDictionary:syntaxDict];
    [self.syntaxColouring setSyntaxDefinition:syntaxDef];
    
    /* Update the default autocomplete delegate with the new
     * syntax definition, if needed. */
    if (!self.autoCompleteDelegate)
        [self setAutoCompleteDelegate:nil];
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
 * @property autoSpellCheck
 */
- (void)setAutoSpellCheck:(BOOL)autoSpellCheck
{
    self.textView.continuousSpellCheckingEnabled = autoSpellCheck;
}

- (BOOL)autoSpellCheck
{
    return self.textView.continuousSpellCheckingEnabled;
}

/*
 * @property backgroundColor
 */
- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    self.textView.backgroundColor = backgroundColor;
}

- (NSColor *)backgroundColor
{
    return self.textView.backgroundColor;
}

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
 * @property gutterFont
 */
-(void)setGutterFont:(NSFont *)gutterFont
{
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
    [self.gutterView setTextColor:gutterTextColour];
}

-(NSColor *)gutterTextColour
{
    return [self.gutterView textColor];
}


/*
 * @property insertionPointColor
 */
- (void)setInsertionPointColor:(NSColor *)insertionPointColor
{
    self.textView.insertionPointColor = insertionPointColor;
}

- (NSColor *)insertionPointColor
{
    return self.textView.insertionPointColor;
}


/*
 * @property lineWrap:
 */
- (void)setLineWrap:(BOOL)value
{
    [self.textView setLineWrap:value];
}

- (BOOL)lineWrap
{
    return [self.textView lineWrap];
}


/*
 * @property pageGuideColumn
 */
- (void)setPageGuideColumn:(NSInteger)pageGuideColumn
{
    self.textView.pageGuideColumn = pageGuideColumn;
}

- (NSInteger)pageGuideColumn
{
    return self.textView.pageGuideColumn;
}


/*
 * @property scrollElasticityDisabled:
 */
- (void)setScrollElasticityDisabled:(BOOL)value
{
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
 * @property showsInvisibleCharacters
 */
- (void)setShowsInvisibleCharacters:(BOOL)showsInvisibleCharacters
{
    self.textView.layoutManager.showsInvisibleCharacters = showsInvisibleCharacters;
}

- (BOOL)showsInvisibleCharacters
{
    return self.textView.layoutManager.showsInvisibleCharacters;
}


/*
 * @property showsPageGuide
 */
- (void)setShowsPageGuide:(BOOL)showsPageGuide
{
    self.textView.showsPageGuide = showsPageGuide;
}

- (BOOL)showsPageGuide
{
    return self.textView.showsPageGuide;
}


/*
 * @property showsWarningsInGutter
 */
- (void)setShowsWarningsInGutter:(BOOL)value
{
    self.syntaxErrorController.showSyntaxErrors = value;
}

- (BOOL)showsWarningsInGutter
{
    return self.syntaxErrorController.showSyntaxErrors;
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
 * @property textColor
 */
- (void)setTextColor:(NSColor *)textColor
{
    self.textView.textColor = textColor;
}

- (NSColor *)textColor
{
    return self.textView.textColor;
}


/*
 * @property textCurrentLineHighlightColor
 */
- (void)setTextCurrentLineHighlightColour:(NSColor *)textCurrentLineHighlightColour
{
    self.textView.currentLineHighlightColour = textCurrentLineHighlightColour;
}

- (NSColor *)textCurrentLineHighlightColour
{
    return self.textView.currentLineHighlightColour;
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


/*
 * @property textFont
 */
- (void)setTextFont:(NSFont *)textFont
{
    SMLLayoutManager *layoutManager = (SMLLayoutManager *)self.textView.layoutManager;

    layoutManager.textFont =textFont;
    self.textView.textFont = textFont;
}

- (NSFont *)textFont
{
    return self.textView.textFont;
}


/*
 * @property textInvisibleCharactersColor
 */
- (void)setTextInvisibleCharactersColour:(NSColor *)textInvisibleCharactersColour
{
    SMLLayoutManager *layoutManager = (SMLLayoutManager *)self.textView.layoutManager;
    layoutManager.textInvisibleCharactersColour = textInvisibleCharactersColour;
}

- (NSColor *)textInvisibleCharactersColour
{
    SMLLayoutManager *layoutManager = (SMLLayoutManager *)self.textView.layoutManager;
    return layoutManager.textInvisibleCharactersColour;
}


/*
 * @property textTabWidth
 */
- (void)setTextTabWidth:(NSInteger)textTabWidth
{
    self.textView.tabWidth = textTabWidth;
}

- (NSInteger)textTabWidth
{
    return self.textView.tabWidth;
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


/*
 * @property autoCompleteDelegate
 */
- (void)setAutoCompleteDelegate:(id<SMLAutoCompleteDelegate>)autoCompleteDelegate
{
    _autoCompleteDelegate = autoCompleteDelegate;
    if (autoCompleteDelegate)
        [self.textView setAutocompleteDelegate:autoCompleteDelegate];
    else
        [self.textView setAutocompleteDelegate:self.syntaxColouring.syntaxDefinition];
}

- (id<SMLAutoCompleteDelegate>)autoCompleteDelegate
{
    return _autoCompleteDelegate;
}


#pragma mark - Properties - System Components


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
 * (synthesized)
 */


#pragma mark - Class methods

/*
 * + initialize
 */
+ (void)initialize
{
    NSLog(@"This method is deprecated. Its only purpose is to register user defaults. "
          "Fragaria shouldn't be doing that for you; you should use your own defaults. "
          "The helper framework MGSFragariaPreferences can provide suggested defaults and "
          "suggested keynames for you. "
          "VERY SOON this automatic registration will stop. Make the transition today.");
    [MGSFragariaPreferences initializeValues];
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
    self = [super init];
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
    self.hasVerticalScroller = YES;
    
    // create textview
    self.textView = [[SMLTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height) fragaria:self];
    [self.scrollView setDocumentView:self.textView];
    
    // create line numbers
    self.gutterView = [[MGSLineNumberView alloc] initWithScrollView:self.scrollView fragaria:self];
    [self.scrollView setVerticalRulerView:self.gutterView];
    [self.scrollView setHasVerticalRuler:YES];
    [self.scrollView setHasHorizontalRuler:NO];
    
    // carryover default syntaxDefinition name from old docSpec
    self.syntaxDefinitionName = [MGSSyntaxController standardSyntaxDefinitionName];
    
    // add syntax colouring
    [self.syntaxColouring recolourExposedRange];
    
    // add scroll view to content view
    [contentView addSubview:self.scrollView];
    
    // update the gutter view
    [self.scrollView setRulersVisible:[self showsLineNumbers]];
    
    // apply default line wrapping
    [self.textView setLineWrap:[[SMLDefaults valueForKey:MGSFragariaPrefsLineWrapNewDocuments] boolValue]];
    
    _syntaxErrorController = [[MGSSyntaxErrorController alloc] init];
    self.syntaxErrorController.lineNumberView = self.gutterView;
    self.syntaxErrorController.textView = self.textView;
    [self setShowsWarningsInGutter:YES];
    
    [self setAutoCompleteDelegate:nil];

    // create the temporary preferences observer
    self.temporaryPreferencesObserver = [[MGSTemporaryPreferencesObserver alloc] initWithFragaria:self];
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



@end
