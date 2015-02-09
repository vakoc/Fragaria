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

- (IBAction)removeNeedlessWhitespaceAction:(id)sender;
- (IBAction)detabAction:(id)sender;
- (IBAction)entabAction:(id)sender;
- (void)performEntab;
- (void)performDetab;
- (IBAction)shiftLeftAction:(id)sender;
- (IBAction)shiftRightAction:(id)sender;
- (IBAction)toLowercaseAction:(id)sender;
- (IBAction)toUppercaseAction:(id)sender;
- (IBAction)capitaliseAction:(id)sender;
- (IBAction)goToLineAction:(id)sender;
- (void)performGoToLine:(NSInteger)lineToGoTo;
- (IBAction)closeTagAction:(id)sender;
- (IBAction)commentOrUncommentAction:(id)sender;
- (IBAction)emptyDummyAction:(id)sender;
- (IBAction)removeLineEndingsAction:(id)sender;
- (IBAction)changeLineEndingsAction:(id)sender;
- (IBAction)interchangeAdjacentCharactersAction:(id)sender;
- (IBAction)prepareForXMLAction:(id)sender;
- (IBAction)reloadText:(id)sender;

@end
