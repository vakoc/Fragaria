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

#import <Cocoa/Cocoa.h>
#import "MGSFragaria.h"
#import "SMLTextView.h"


/**
 *  MGSFragariaView abstracts much of Fragaria's overhead into an IB-compatible view.
 **/
@interface MGSFragariaView : NSView


#pragma mark - Properties - Delegates

/** The delegate providing MGSFragariaTextViewDelegate methods. */
@property (weak) IBOutlet id <MGSFragariaTextViewDelegate, MGSDragOperationDelegate> delegate;

/** The delegate providing MGSBreakpointDelegate methods. */
@property (weak) IBOutlet id <MGSBreakpointDelegate> breakPointDelegate;

/** The delegate for providing SMLSyntaxColouringDelegate methods. */
@property (weak) IBOutlet id <SMLSyntaxColouringDelegate> syntaxColoringDelegate;


#pragma mark - Properties - Document Support

@property (assign) NSString *string;                     ///< The content of the text editor as a plain string.

@property (assign) NSAttributedString *attributedString; ///< The content of the text editor as an attributed string.

@property (assign) NSString *syntaxDefinitionName;       ///< Indicates the syntax definition name, which indicates how to highlight the text.

@property (assign) NSArray *syntaxErrors;                ///< Contains an array of MGSSyntaxError objects, which can be displayed in the editor.


#pragma mark - Properties - Overall Appearance and Display

@property (assign) BOOL autoSpellCheck;                                ///< Specifies whether or not automatic spell checking is enabled.

@property (assign) BOOL hasVerticalScroller;                           ///< Indicates whether or not the vertical scroller is always present.

@property (assign) NSUInteger gutterMinimumWidth;                      ///< Specifies the minimum width of the line number gutter.

@property (assign) BOOL isSyntaxColoured;                              ///< Indicates whether or not the text editor is using syntax highlighting.

@property (assign) BOOL lineWrap;                                      ///< Indicates whether or not line wrap (word wrap) is on or off.

@property (assign) BOOL scrollElasticityDisabled;                      ///< Indicates whether text text view's "rubber band" effect is disabled.

@property (assign) BOOL showsLineNumbers;                              ///< Indicates whether or not the text editor is displaying line numbers when the gutter is visible.

@property (assign) BOOL showsGutter;                                   ///< Indicates whether or not the text editor gutter is visible.

@property (assign) BOOL showsWarningsInGutter;                         ///< Indicates whether or not error warnings are displayed in the gutter.

@property (assign) NSUInteger startingLineNumber;                      ///< Indicates the starting line number of the text view.

@property (assign) NSFont *textFont;                                   ///< Specifies the text editor font.

@property (assign) NSColor *textInvisibleCharactersColour;             ///< Specifies the colour to render invisible characters in the text view.




#pragma mark - KEY FRAGARIA METHOD PROMOTIONS

/**
 *  If possible, moves the text editor view to the given line.
 *  @param lineToGoTo The line to go to.
 *  @param centered If yes, tries to center the line in the view.
 *  @param highlight If yes, highlights line temporarily.
 */
- (void)goToLine:(NSInteger)lineToGoTo centered:(BOOL)centered highlight:(BOOL)highlight;


#pragma mark - DIRECT ACCESS

@property (strong, readonly) MGSFragaria *fragaria;   ///< A reference to the Fragaria instance owned by this view.

@property (assign) SMLTextView *textView;              ///< Provides direct access to Fragaria's text view instance.


@end
