//
//  MGSFragariaPrivate.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 24/02/15.
//
//

@class MGSExtraInterfaceController;
@class MGSSyntaxErrorController;
@class SMLSyntaxColouring;
@class MGSLineNumberView;
@class MGSPreferencesObserver;


#pragma mark - Class Extension


@interface MGSFragaria()


#pragma mark - System Components


/** The controller which manages and displays the syntax errors in Fragaria's
 *  text view and gutter view. */
@property (readonly) MGSSyntaxErrorController *syntaxErrorController;

/** Fragaria's left ruler. Handles display of line numbers, breakpoints and
 *  syntax error badges. */
@property (readonly) MGSLineNumberView *gutterView;

/** Fragaria's preferences obsever, used for supporting the default preference
 *  panels.  */
@property (readonly) MGSPreferencesObserver *preferencesObserver;


@end

