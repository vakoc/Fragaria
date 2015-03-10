//
//  MGSFragariaView.h
//  Fragaria
//
//  File created by Jim Derry on 2015/02/07.
//
//  Implements an NSView subclass that abstracts several characteristics of Fragaria,
//  such as the use of Interface Builder to set delegates and assign key-value pairs.
//  Also provides property abstractions for Fragaria's settings and methods.
//

#import "MGSFragariaView.h"
#import "SMLSyntaxColouring.h"

#pragma mark - PRIVATE INTERFACE


@interface MGSFragariaView ()

@property (nonatomic, strong, readwrite) MGSFragaria *fragaria;

@end


#pragma mark - IMPLEMENTATION


@implementation MGSFragariaView

// Silence XCode warning, as it doesn't see the properties
// are indeed implemented.
@dynamic breakpointDelegate, syntaxColouringDelegate;


#pragma mark - Initialization and Setup


/*
 * - initWithCoder:
 *   Called when unarchived from a nib.
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
	if ((self = [super initWithCoder:coder]))
	{
		/*
		   Don't initialize in awakeFromNib otherwise
		   IB User Defined Runtime Attributes won't
		   be honored.
		 */
		self.fragaria = [[MGSFragaria alloc] initWithView:self];
	}
	return self;
}


/*
 * - initWithFrame:
 *   Called when used in a framework.
 */
- (instancetype)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
		/*
		   Don't initialize in awakeFromNib otherwise
		   IB User Defined Runtime Attributes won't
		   be honored.
		 */
		self.fragaria = [[MGSFragaria alloc] initWithView:self];
    }
    return self;
}


/*
 * Note: while it would be trivial to bypass Fragaria's setters for most of
 * these properties and use the system components properties directly, using
 * the MGSFragaria properties directly provides some limited testing against
 * MGSFragaria's interface. An extra message for a property setter is
 * negligible.
 * @todo: (jsd) MGSFragaria should use the MGSFragariaAPI, too, then these
 *              accessors can access the component propery directly.
 */


#pragma mark - Accessing Fragaria's Views


/*
 * @property textView
 */
-(SMLTextView *)textView
{
    return self.fragaria.textView;
}


/*
 * @property scrollView
 */
- (NSScrollView*)scrollView
{
    return self.fragaria.scrollView;
}


/*
 * @property gutterView
 */
- (MGSLineNumberView *)gutterView
{
    return self.fragaria.gutterView;
}

 
/*
 * @property syntaxColouring
 */
- (SMLSyntaxColouring *)syntaxColouring
{
    return self.fragaria.syntaxColouring;
}


#pragma mark - Accessing Text Content


/*
 * @property string
 */
- (void)setString:(NSString *)string
{
	self.fragaria.string = string;
    [self propagateValue:string forBinding:NSStringFromSelector(@selector(string))];
}

- (NSString *)string
{
	return self.fragaria.string;
}


/*
 * @property attributedStringWithTemporaryAttributesApplied
 */
- (NSAttributedString *)attributedStringWithTemporaryAttributesApplied
{
    return self.fragaria.attributedStringWithTemporaryAttributesApplied;
}


#pragma mark - Creating Split Panels


/*
 * - replaceTextStorage:
 */
- (void)replaceTextStorage:(NSTextStorage *)textStorage{
    [self.fragaria replaceTextStorage:textStorage];
}


#pragma mark - Configuring Syntax Highlighting


/*
 * @property syntaxColoured
 */
- (void)setSyntaxColoured:(BOOL)syntaxColoured
{
	[self.fragaria setSyntaxColoured:syntaxColoured];
}

- (BOOL)isSyntaxColoured
{
	return [self.fragaria isSyntaxColoured];
}


/*
 * @property syntaxDefinitionName
 */
- (void)setSyntaxDefinitionName:(NSString *)syntaxDefinitionName
{
	self.fragaria.syntaxDefinitionName = syntaxDefinitionName;
}

- (NSString *)syntaxDefinitionName
{
	return self.fragaria.syntaxDefinitionName;
}


/*
 * @property syntaxColouringDelegate
 */
- (void)setSyntaxColouringDelegate:(id<SMLSyntaxColouringDelegate>)syntaxColouringDelegate
{
    self.fragaria.syntaxColouringDelegate = syntaxColouringDelegate;
}

- (id<SMLSyntaxColouringDelegate>)syntaxColoringDelegate
{
    return self.fragaria.syntaxColouringDelegate;
}


/*
 * @property BOOL coloursMultiLineStrings
 */
- (void)setColoursMultiLineStrings:(BOOL)coloursMultiLineStrings
{
    self.fragaria.coloursMultiLineStrings = coloursMultiLineStrings;
}

- (BOOL)coloursMultiLineStrings
{
    return self.fragaria.coloursMultiLineStrings;
}


/*
 * @property BOOL coloursOnlyUntilEndOfLine
 */
- (void)setColoursOnlyUntilEndOfLine:(BOOL)coloursOnlyUntilEndOfLine
{
    self.fragaria.coloursOnlyUntilEndOfLine = coloursOnlyUntilEndOfLine;
}

- (BOOL)coloursOnlyUntilEndOfLine
{
    return self.fragaria.coloursOnlyUntilEndOfLine;
}


#pragma mark - Configuring Autocompletion


/*
 * @property autoCompleteDelegate
 */
- (void)setAutoCompleteDelegate:(id<SMLAutoCompleteDelegate>)autoCompleteDelegate
{
    self.fragaria.autoCompleteDelegate = autoCompleteDelegate;
}

- (id<SMLAutoCompleteDelegate>)autoCompleteDelegate
{
    return self.fragaria.autoCompleteDelegate;
}


/*
 * @property double autoCompleteDelay
 */
- (void)setAutoCompleteDelay:(double)autoCompleteDelay
{
    self.fragaria.autoCompleteDelay = autoCompleteDelay;
}

- (double)autoCompleteDelay
{
    return self.fragaria.autoCompleteDelay;
}

 
/*
 * @property BOOL autoCompleteEnabled
 */
- (void)setAutoCompleteEnabled:(BOOL)autoCompleteEnabled
{
    self.fragaria.autoCompleteEnabled = autoCompleteEnabled;
}

- (BOOL)autoCompleteEnabled
{
    return self.fragaria.autoCompleteEnabled;
}

 
/*
 * @property BOOL autoCompleteWithKeywords
 */
- (void)setAutoCompleteWithKeywords:(BOOL)autoCompleteWithKeywords
{
    self.fragaria.autoCompleteWithKeywords = autoCompleteWithKeywords;
}

- (BOOL)autoCompleteWithKeywords
{
    return self.fragaria.autoCompleteWithKeywords;
}


#pragma mark - Highlighting the current line


/*
 * @property currentLineHighlightColour
 */
- (void)setCurrentLineHighlightColour:(NSColor *)currentLineHighlightColour
{
    self.fragaria.currentLineHighlightColour = currentLineHighlightColour;
}

- (NSColor *)currentLineHighlightColour
{
    return self.fragaria.currentLineHighlightColour;
}


/*
 * @property highlightsCurrentLine
 */
- (void)setHighlightsCurrentLine:(BOOL)highlightsCurrentLine
{
    self.fragaria.highlightsCurrentLine = highlightsCurrentLine;
}

- (BOOL)highlightsCurrentLine
{
    return self.fragaria.highlightsCurrentLine;
}


#pragma mark - Configuring the Gutter


/*
 * @property showsGutter
 */
- (void)setShowsGutter:(BOOL)showsGutter
{
	[self.fragaria setShowsGutter:showsGutter];
}

- (BOOL)showsGutter
{
	return [self.fragaria showsGutter];
}


/*
 * @property minimumGutterWidth
 */
- (void)setMinimumGutterWidth:(CGFloat)minimumGutterWidth
{
	self.fragaria.minimumGutterWidth = minimumGutterWidth;
}

- (CGFloat)minimumGutterWidth
{
	return self.fragaria.minimumGutterWidth;
}


/*
 * @property showsLineNumbers
 */
- (void)setShowsLineNumbers:(BOOL)showsLineNumbers
{
	[self.fragaria setShowsLineNumbers:showsLineNumbers];
}

- (BOOL)showsLineNumbers
{
	return [self.fragaria showsLineNumbers];
}


/*
 * @property startingLineNumber
 */
- (void)setStartingLineNumber:(NSUInteger)startingLineNumber
{
	[self.fragaria setStartingLineNumber:startingLineNumber];
}

- (NSUInteger)startingLineNumber
{
	return [self.fragaria startingLineNumber];
}


/*
 * @property gutterFont
 */
- (void)setGutterFont:(NSFont *)gutterFont
{
    self.fragaria.gutterFont = gutterFont;
}

- (NSFont *)gutterFont
{
    return self.fragaria.gutterFont;
}

/*
 * @property gutterTextColour
 */
- (void)setGutterTextColour:(NSColor *)gutterTextColour
{
    self.fragaria.gutterTextColour = gutterTextColour;
}

- (NSColor *)gutterTextColour
{
    return self.fragaria.gutterTextColour;
}


#pragma mark - Showing Syntax Errors


/*
 * @property syntaxErrors
 */
- (void)setSyntaxErrors:(NSArray *)syntaxErrors
{
	self.fragaria.syntaxErrors = syntaxErrors;
}

- (NSArray *)syntaxErrors
{
	return self.fragaria.syntaxErrors;
}


/*
 * @property showsSyntaxErrors
 */
- (void)setShowsSyntaxErrors:(BOOL)showsSyntaxErrors
{
	[self.fragaria setShowsSyntaxErrors:showsSyntaxErrors];
}

- (BOOL)showsSyntaxErrors
{
	return [self.fragaria showsSyntaxErrors];
}


#pragma mark - Showing Breakpoints


/*
 * @property breakpointDelegate
 */
- (void)setBreakpointDelegate:(id<MGSBreakpointDelegate>)breakpointDelegate
{
	[self.fragaria setBreakpointDelegate:breakpointDelegate];
}

- (id<MGSBreakpointDelegate>)breakPointDelegate
{
	return self.fragaria.breakpointDelegate;
}


#pragma mark - Tabulation and Indentation


/*
 * @property tabWidth
 */
- (void)setTabWidth:(NSInteger)tabWidth
{
    self.fragaria.tabWidth = tabWidth;
}

- (NSInteger)tabWidth
{
    return self.fragaria.tabWidth;
}


/*
 * @property indentWidth
 */
- (void)setIndentWidth:(NSUInteger)indentWidth
{
    self.fragaria.indentWidth = indentWidth;
}

- (NSUInteger)indentWidth
{
    return self.fragaria.indentWidth;
}


/*
 * @property indentWithSpaces
 */
- (void)setIndentWithSpaces:(BOOL)indentWithSpaces
{
    self.fragaria.indentWithSpaces = indentWithSpaces;
}

- (BOOL)indentWithSpaces
{
    return self.fragaria.indentWithSpaces;
}


/*
 * @property useTabStops
 */
- (void)setUseTabStops:(BOOL)useTabStops
{
    self.fragaria.useTabStops = useTabStops;
}

- (BOOL)useTabStops
{
    return self.fragaria.useTabStops;
}


/*
 * @property indentBracesAutomatically
 */
- (void)setIndentBracesAutomatically:(BOOL)indentBracesAutomatically
{
    self.fragaria.indentBracesAutomatically = indentBracesAutomatically;
}

- (BOOL)indentBracesAutomatically
{
    return self.fragaria.indentBracesAutomatically;
}


/*
 * @property indentNewLinesAutomatically
 */
- (void)setIndentNewLinesAutomatically:(BOOL)indentNewLinesAutomatically
{
    self.fragaria.indentNewLinesAutomatically = indentNewLinesAutomatically;
}

- (BOOL)indentNewLinesAutomatically
{
    return self.fragaria.indentNewLinesAutomatically;
}


#pragma mark - Automatic Bracing


/*
 * @property insertClosingParenthesisAutomatically
 */
- (void)setInsertClosingParenthesisAutomatically:(BOOL)insertClosingParenthesisAutomatically
{
    self.fragaria.insertClosingParenthesisAutomatically = insertClosingParenthesisAutomatically;
}

- (BOOL)insertClosingParenthesisAutomatically
{
    return self.fragaria.insertClosingParenthesisAutomatically;
}


/*
 * @property insertClosingBraceAutomatically
 */
- (void)setInsertClosingBraceAutomatically:(BOOL)insertClosingBraceAutomatically
{
    self.fragaria.insertClosingBraceAutomatically = insertClosingBraceAutomatically;
}

- (BOOL)insertClosingBraceAutomatically
{
    return self.fragaria.insertClosingBraceAutomatically;
}


/*
 * @property showsMatchingBraces
 */
- (void)setShowsMatchingBraces:(BOOL)showsMatchingBraces
{
    self.fragaria.showsMatchingBraces = showsMatchingBraces;
}

- (BOOL)showsMatchingBraces
{
    return self.fragaria.showsMatchingBraces;
}


#pragma mark - Page Guide and Line Wrap


/*
 * @property pageGuideColumn
 */
- (void)setPageGuideColumn:(NSInteger)pageGuideColumn
{
    self.fragaria.pageGuideColumn = pageGuideColumn;
}

- (NSInteger)pageGuideColumn
{
    return self.fragaria.pageGuideColumn;
}


/*
 * @property showsPageGuide
 */
-(void)setShowsPageGuide:(BOOL)showsPageGuide
{
    self.fragaria.showsPageGuide = showsPageGuide;
}

- (BOOL)showsPageGuide
{
    return self.fragaria.showsPageGuide;
}


/*
 * @property lineWrap
 */
- (void)setLineWrap:(BOOL)lineWrap
{
	[self.fragaria setLineWrap:lineWrap];
}

- (BOOL)lineWrap
{
	return [self.fragaria lineWrap];
}


#pragma mark - Showing Invisible Characters


/*
 * @property showsInvisibleCharacters
 */
- (void)setShowsInvisibleCharacters:(BOOL)showsInvisibleCharacters
{
    self.fragaria.showsInvisibleCharacters = showsInvisibleCharacters;
}

- (BOOL)showsInvisibleCharacters
{
    return self.fragaria.showsInvisibleCharacters;
}


/*
 * @property textInvisibleCharactersColour
 */
- (void)setTextInvisibleCharactersColour:(NSColor *)textInvisibleCharactersColor
{
	self.fragaria.textInvisibleCharactersColour = textInvisibleCharactersColor;
}

- (NSColor *)textInvisibleCharactersColour
{
	return self.fragaria.textInvisibleCharactersColour;
}


#pragma mark - Configuring Text Appearance


/*
 * @property textColor
 */
- (void)setTextColor:(NSColor *)textColor
{
    self.fragaria.textColor = textColor;
}

- (NSColor *)textColor
{
    return self.fragaria.textColor;
}


/*
 * @property backgroundColor
 */
- (void)setBackgroundColor:(NSColor *)backgroundColor
{
    self.fragaria.backgroundColor = backgroundColor;
}

- (NSColor *)backgroundColor
{
    return self.fragaria.backgroundColor;
}


/*
 * @property textFont
 */
- (void)setTextFont:(NSFont *)textFont
{
	self.fragaria.textFont = textFont;
}

- (NSFont *)textFont
{
	return self.fragaria.textFont;
}


#pragma mark - Configuring Additional Text View Behavior


/*
 * @property textViewDelegate
 */
- (void)setTextViewDelegate:(id<MGSFragariaTextViewDelegate, MGSDragOperationDelegate>)textViewDelegate
{
	[self.fragaria setTextViewDelegate:textViewDelegate];
}

- (id<MGSFragariaTextViewDelegate, MGSDragOperationDelegate>)textViewDelegate
{
	return self.fragaria.textViewDelegate;
}


/*
 * @property hasVerticalScroller
 */
- (void)setHasVerticalScroller:(BOOL)hasVerticalScroller
{
	[self.fragaria setHasVerticalScroller:hasVerticalScroller];
}

- (BOOL)hasVerticalScroller
{
	return [self.fragaria hasVerticalScroller];
}


/*
 * @property insertionPointColor
 */
- (void)setInsertionPointColor:(NSColor *)insertionPointColor
{
    self.fragaria.insertionPointColor = insertionPointColor;
}

- (NSColor *)insertionPointColor
{
    return self.fragaria.insertionPointColor;
}


/*
 * @property scrollElasticityDisabled
 */
- (void)setScrollElasticityDisabled:(BOOL)scrollElasticityDisabled
{
	[self.fragaria setScrollElasticityDisabled:scrollElasticityDisabled];
}

- (BOOL)scrollElasticityDisabled
{
	return [self.fragaria scrollElasticityDisabled];
}


/*
 * - goToLine:centered:highlight
 */
- (void)goToLine:(NSInteger)lineToGoTo centered:(BOOL)centered highlight:(BOOL)highlight
{
	[self.fragaria goToLine:lineToGoTo centered:centered highlight:highlight];
}


#pragma mark - Syntax Highlighting Colours


/*
 * @property colourForAutocomplete
 */
- (void)setColourForAutocomplete:(NSColor *)colourForAutocomplete
{
    self.fragaria.syntaxColouring.colourForAutocomplete = colourForAutocomplete;
}

- (NSColor *)colourForAutocomplete
{
    return self.fragaria.syntaxColouring.colourForAutocomplete;
}


/*
 * @property colourForAttributes
 */
- (void)setColourForAttributes:(NSColor *)colourForAttributes
{
    self.fragaria.syntaxColouring.colourForAttributes = colourForAttributes;
}

- (NSColor *)colourForAttributes
{
    return self.fragaria.syntaxColouring.colourForAttributes;
}


/*
 * @property colourForCommands
 */
- (void)setColourForCommands:(NSColor *)colourForCommands
{
    self.fragaria.syntaxColouring.colourForCommands = colourForCommands;
}

- (NSColor *)colourForCommands
{
    return self.fragaria.syntaxColouring.colourForCommands;
}


/*
 * @property colourForComments
 */
- (void)setColourForComments:(NSColor *)colourForComments
{
    self.fragaria.syntaxColouring.colourForComments = colourForComments;
}

- (NSColor *)colourForComments
{
    return self.fragaria.syntaxColouring.colourForComments;
}


/*
 * @property colourForInstructions
 */
- (void)setColourForInstructions:(NSColor *)colourForInstructions
{
    self.fragaria.syntaxColouring.colourForInstructions = colourForInstructions;
}

- (NSColor *)colourForInstructions
{
    return self.fragaria.syntaxColouring.colourForInstructions;
}


/*
 * @property colourForKeywords
 */
- (void)setColourForKeywords:(NSColor *)colourForKeywords
{
    self.fragaria.syntaxColouring.colourForKeywords = colourForKeywords;
}

- (NSColor *)colourForKeywords
{
    return self.fragaria.syntaxColouring.colourForKeywords;
}


/*
 * @property colourForNumbers
 */
- (void)setColourForNumbers:(NSColor *)colourForNumbers
{
    self.fragaria.syntaxColouring.colourForNumbers = colourForNumbers;
}

- (NSColor *)colourForNumbers
{
    return self.fragaria.syntaxColouring.colourForNumbers;
}


/*
 * @property colourForStrings
 */
- (void)setColourForStrings:(NSColor *)colourForStrings
{
    self.fragaria.syntaxColouring.colourForStrings = colourForStrings;
}

- (NSColor *)colourForStrings
{
    return self.fragaria.syntaxColouring.colourForStrings;
}


/*
 * @property colourForVariables
 */
- (void)setColourForVariables:(NSColor *)colourForVariables
{
    self.fragaria.syntaxColouring.colourForVariables = colourForVariables;
}

- (NSColor *)colourForVariables
{
    return self.fragaria.syntaxColouring.colourForVariables;
}


#pragma mark - Syntax Highlighter Colouring Options


/*
 * @property coloursAttributes
 */
- (void)setColoursAttributes:(BOOL)coloursAttributes
{
    self.fragaria.syntaxColouring.coloursAttributes = coloursAttributes;
}

- (BOOL)coloursAttributes
{
    return self.fragaria.syntaxColouring.coloursAttributes;
}

/*
 * @property coloursAutocomplete
 */
- (void)setColoursAutocomplete:(BOOL)coloursAutocomplete
{
    self.fragaria.syntaxColouring.coloursAutocomplete = coloursAutocomplete;
}

- (BOOL)coloursAutocomplete
{
    return self.fragaria.syntaxColouring.coloursAutocomplete;
}


/*
 * @property coloursCommands
 */
- (void)setColoursCommands:(BOOL)coloursCommands
{
    self.fragaria.syntaxColouring.coloursCommands = coloursCommands;
}

- (BOOL)coloursCommands
{
    return self.fragaria.syntaxColouring.coloursCommands;
}


/*
 * @property coloursComments
 */
- (void)setColoursComments:(BOOL)coloursComments
{
    self.fragaria.syntaxColouring.coloursComments = coloursComments;
}

- (BOOL)coloursComments
{
    return self.fragaria.syntaxColouring.coloursComments;
}


/*
 * @property coloursInstructions
 */
- (void)setColoursInstructions:(BOOL)coloursInstructions
{
    self.fragaria.syntaxColouring.coloursInstructions = coloursInstructions;
}

- (BOOL)coloursInstructions
{
    return self.fragaria.syntaxColouring.coloursInstructions;
}


/*
 * @property coloursKeywords
 */
- (void)setColoursKeywords:(BOOL)coloursKeywords
{
    self.fragaria.syntaxColouring.coloursKeywords = coloursKeywords;
}

- (BOOL)coloursKeywords
{
    return self.fragaria.syntaxColouring.coloursKeywords;
}


/*
 * @property coloursNumbers
 */
- (void)setColoursNumbers:(BOOL)coloursNumbers
{
    self.fragaria.syntaxColouring.coloursNumbers = coloursNumbers;
}

- (BOOL)coloursNumbers
{
    return self.fragaria.syntaxColouring.coloursNumbers;
}


/*
 * @property coloursStrings
 */
- (void)setColoursStrings:(BOOL)coloursStrings
{
    self.fragaria.syntaxColouring.coloursStrings = coloursStrings;
}

- (BOOL)coloursStrings
{
    return self.fragaria.syntaxColouring.coloursStrings;
}


/*
 * @property coloursVariables
*/
- (void)setColoursVariables:(BOOL)coloursVariables
{
    self.fragaria.syntaxColouring.coloursVariables = coloursVariables;
}

- (BOOL)coloursVariables
{
    return self.fragaria.syntaxColouring.coloursVariables;
}


#pragma mark - KVO/KVC/BINDING Handling


/*
 * - propagateValue:forBinding
 *   courtesy of Tom Dalling.
 */
-(void)propagateValue:(id)value forBinding:(NSString*)binding;
{
    NSParameterAssert(binding != nil);

    // WARNING: bindingInfo contains NSNull, so it must be accounted for
    NSDictionary* bindingInfo = [self infoForBinding:binding];
    if (!bindingInfo)
    {
        return; //there is no binding
    }

    // Apply the value transformer, if one has been set
    NSDictionary* bindingOptions = [bindingInfo objectForKey:NSOptionsKey];

    if (bindingOptions)
    {
        NSValueTransformer* transformer = [bindingOptions valueForKey:NSValueTransformerBindingOption];

        if (!transformer || (id)transformer == [NSNull null])
        {
            NSString* transformerName = [bindingOptions valueForKey:NSValueTransformerNameBindingOption];

            if(transformerName && (id)transformerName != [NSNull null])
            {
                transformer = [NSValueTransformer valueTransformerForName:transformerName];
            }
        }

        if (transformer && (id)transformer != [NSNull null])
        {
            if([[transformer class] allowsReverseTransformation])
            {
                value = [transformer reverseTransformedValue:value];
            }
            else
            {
                NSLog(@"WARNING: binding \"%@\" has value transformer, but it doesn't allow reverse transformations in %s", binding, __PRETTY_FUNCTION__);
            }
        }
    }

    id boundObject = [bindingInfo objectForKey:NSObservedObjectKey];

    if(!boundObject || boundObject == [NSNull null])
    {
        NSLog(@"ERROR: NSObservedObjectKey was nil for binding \"%@\" in %s", binding, __PRETTY_FUNCTION__);
        return;
    }

    NSString* boundKeyPath = [bindingInfo objectForKey:NSObservedKeyPathKey];

    if(!boundKeyPath || (id)boundKeyPath == [NSNull null])
    {
        NSLog(@"ERROR: NSObservedKeyPathKey was nil for binding \"%@\" in %s", binding, __PRETTY_FUNCTION__);
        return;
    }

    [boundObject setValue:value forKeyPath:boundKeyPath];
}


@end
