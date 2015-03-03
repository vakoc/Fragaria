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
@class MGSLineNumberDefaultsObserver;
@class MGSLineNumberView;
@class MGSPreferencesObserver;

#pragma mark - Class Extension


@interface MGSFragaria()


#pragma mark - System Components


/** The controller which manages and displays the syntax errors in Fragaria's
 * text view and gutter view. */
@property (nonatomic, strong, readonly) MGSSyntaxErrorController *syntaxErrorController;

/** The observer which manages the properties of MGSLineNumberView. Will be
 * removed in the near future. */
@property MGSLineNumberDefaultsObserver *lineNumberDefObserv;

/** Fragaria's left ruler. Handles display of line numbers, breakpoints and
 * syntax error badges. */
@property MGSLineNumberView *gutterView;

/** Fragaria's scroll view. */
@property (nonatomic, strong) NSScrollView *scrollView;

/** Fragaria's text view. */
@property (nonatomic, strong) SMLTextView *textView;

/** Fragaria's preferences obsever, used for supporting the default preference
 * panels.  */
@property (nonatomic, strong) MGSPreferencesObserver *preferencesObserver;


@end

