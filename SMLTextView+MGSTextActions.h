//
//  SMLTextView+MGSTextActions.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 09/02/15.
//
//

#import <SMLTextView.h>


/* This category implements the editing options added by Fragaria to
 * NSTextView. */

@interface SMLTextView (MGSTextActions)

- (IBAction)removeNeedlessWhitespace:(id)sender;
- (IBAction)detab:(id)sender;
- (IBAction)entab:(id)sender;
- (void)performEntab;
- (void)performDetab;
- (IBAction)shiftLeft:(id)sender;
- (IBAction)shiftRight:(id)sender;
- (IBAction)lowercaseCharacters:(id)sender;
- (IBAction)uppercaseCharacters:(id)sender;
- (IBAction)capitalizeWord:(id)sender;
- (IBAction)goToLine:(id)sender;
- (void)performGoToLine:(NSInteger)lineToGoTo;
- (IBAction)closeTag:(id)sender;
- (IBAction)commentOrUncomment:(id)sender;
- (IBAction)removeLineEndings:(id)sender;
- (IBAction)changeLineEndings:(id)sender;
- (IBAction)prepareForXML:(id)sender;
- (IBAction)transpose:(id)sender;

@end
