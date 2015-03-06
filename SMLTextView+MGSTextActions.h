//
//  SMLTextView+MGSTextActions.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 09/02/15.
//
//

#import "SMLTextView.h"


/**
 *  This category implements the editing options added by Fragaria to
 *  NSTextView.
 **/
@interface SMLTextView (MGSTextActions)

/**
 *  Sender wants to remove needless whitespace.
 *  @param sender The sender of the action.
 **/
- (IBAction)removeNeedlessWhitespace:(id)sender;

/**
 *  Sender wants to start the detab process.
 *  @param sender The sender of the action.
 **/
- (IBAction)detab:(id)sender;

/**
 *  Sender wants to start the entab process.
 *  @param sender The sender of the action.
 **/
- (IBAction)entab:(id)sender;

/** Convert spaces to tabs.
 *  @param numberOfSpaces The maximum width of a tabulation, in spaces. */
- (void)performEntabWithNumberOfSpaces:(NSInteger)numberOfSpaces;

/** Convert tabs to spaces.
 *  @param numberOfSpaces The maximum width of a tabulation, in spaces. */
- (void)performDetabWithNumberOfSpaces:(NSInteger)numberOfSpaces;

/**
 *  Sender wants to shift the text left.
 *  @param sender The sender of the action.
 **/
- (IBAction)shiftLeft:(id)sender;

/**
 *  Sender wants to shift the text right.
 *  @param sender The sender of the action.
 **/
- (IBAction)shiftRight:(id)sender;

/**
 *  Sender wants to convert selection to lower-case.
 *  @param sender The sender of the action.
 **/
- (IBAction)lowercaseCharacters:(id)sender;

/**
 *  Sender wants to convert selection to upper-case.
 *  @param sender The sender of the action.
 **/
- (IBAction)uppercaseCharacters:(id)sender;

/**
 *  Sender wants to capitalize every word.
 *  @param sender The sender of the action.
 **/
- (IBAction)capitalizeWord:(id)sender;

/**
 *  Sender wants to go to a specific line.
 *  @param sender The sender of the action.
 **/
- (IBAction)goToLine:(id)sender;

/**
 *  Perform a go to line operation.
 *  @param lineToGoTo The line to go to.
 *  @param highlight Indicates whether the line should be selected.
 **/
- (void)performGoToLine:(NSInteger)lineToGoTo setSelected:(BOOL)highlight;

/**
 *  The sender wants to close the current tag.
 *  @param sender The sender of the action.
 **/
- (IBAction)closeTag:(id)sender;

/**
 *  The sender wants to comment or uncomment code.
 *  @param sender The sender of the action.
 **/
- (IBAction)commentOrUncomment:(id)sender;

/**
 *  The sender wants to remove line breaks.
 *  @param sender The sender of the action.
 **/
- (IBAction)removeLineEndings:(id)sender;

/**
 *  The sender wants to prepare the text for XML.
 *  @param sender The sender of the action.
 **/
- (IBAction)prepareForXML:(id)sender;

/**
 *  The sender wants to transpose two characters.
 *  @param sender The sender of the action.
 **/
- (IBAction)transpose:(id)sender;


@end
