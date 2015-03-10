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


#pragma mark - PRIVATE INTERFACE


@interface MGSFragariaView ()

@property (nonatomic, strong, readwrite) MGSFragaria *fragaria;

/* Protocol defines this as strong, but it's a reference, not a copy. */
@property (nonatomic, strong, readwrite) SMLTextView *textView;

@end


#pragma mark - IMPLEMENTATION


@implementation MGSFragariaView


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
        self.textView = self.fragaria.textView;
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
        self.textView = self.fragaria.textView;
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


/*
 * @property scrollView
 */


/*
 * @property gutterView
 */

 
/*
 * @property syntaxColouring
 */


#pragma mark - Accessing Text Content


/*
 * @property string
 */
- (void)setString:(NSString *)string
{
	[self.fragaria setString:string];
}

- (NSString *)string
{
	return [self.fragaria string];
}


/*
 * @property attributedStringWithTemporaryAttributesApplied
 */


#pragma mark - Creating Split Panels


/*
 * - replaceTextStorage:
 */


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
- (void)setSyntaxColoringDelegate:(id<SMLSyntaxColouringDelegate>)syntaxColoringDelegate
{
	[self.fragaria setSyntaxColouringDelegate:syntaxColoringDelegate];
}

- (id<SMLSyntaxColouringDelegate>)syntaxColoringDelegate
{
	return [self.fragaria syntaxColouringDelegate];
}


/*
 * @property BOOL coloursMultiLineStrings
 */


/*
 * @property BOOL coloursOnlyUntilEndOfLine
 */


#pragma mark - Configuring Autocompletion


/*
 * @property autoCompleteDelegate
 */


/*
 * @property double autoCompleteDelay
 */

 
/*
 * @property BOOL autoCompleteEnabled
 */

 
/*
 * @property BOOL autoCompleteWithKeywords
 */


#pragma mark - Highlighting the current line


/*
 * @property currentLineHighlightColour
 */


/*
 * @property highlightsCurrentLine
 */


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
- (void)setMinimumWGutteridth:(NSUInteger)minimumGutterWidth
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


/*
 * @property gutterTextColour
 */


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
- (void)setBreakPointDelegate:(id<MGSBreakpointDelegate>)breakPointDelegate
{
	[self.fragaria setBreakpointDelegate:breakPointDelegate];
}

- (id<MGSBreakpointDelegate>)breakPointDelegate
{
	return self.fragaria.breakpointDelegate;
}


#pragma mark - Tabulation and Indentation


/*
 * @property tabWidth
 */


/*
 * @property indentWidth
 */


/*
 * @property indentWithSpaces
 */


/*
 * @property useTabStops
 */


/*
 * @property indentBracesAutomatically
 */


/*
 * @property indentNewLinesAutomatically
 */


#pragma mark - Automatic Bracing


/*
 * @property insertClosingParenthesisAutomatically
 */


/*
 * @property insertClosingBraceAutomatically
 */


/*
 * @property showsMatchingBraces
 */


#pragma mark - Page Guide and Line Wrap


/*
 * @property pageGuideColumn
 */


/*
 * @property showsPageGuide
 */


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


/*
 * @property backgroundColor
 */


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
- (void)setTextViewDelegate:(id<MGSFragariaTextViewDelegate>)textViewDelegate
{
	[self.fragaria setTextViewDelegate:textViewDelegate];
}

- (id<MGSFragariaTextViewDelegate>)textViewDelegate
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


/*
 * @property colourForAttributes
 */


/*
 * @property colourForCommands
 */


/*
 * @property colourForComments
 */


/*
 * @property colourForInstructions
 */


/*
 * @property colourForKeywords
 */


/*
 * @property colourForNumbers
 */


/*
 * @property colourForStrings
 */


/*
 * @property colourForVariables
 */


#pragma mark - Syntax Highlighter Colouring Options


/*
 * @property coloursAttributes
 */


/*
 * @property coloursAutocomplete
 */


/*
 * @property coloursCommands
 */


/*
 * @property coloursComments
 */


/*
 * @property coloursInstructions
 */


/*
 * @property coloursKeywords
 */


/*
 * @property coloursNumbers
 */


/*
 * @property coloursStrings
 */


/*
 * @property coloursVariables
*/


@end
