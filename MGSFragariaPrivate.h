//
//  MGSFragariaPrivate.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 24/02/15.
//
//

@class MGSExtraInterfaceController;
@class MGSSyntaxErrorController;


// class extension
@interface MGSFragaria()

/**
 * The controller responsible for managing accessory dialogs for this instance
 * of MGSFragaria.
 */
@property (nonatomic, readwrite) MGSExtraInterfaceController *extraInterfaceController;
/**
 * The controller which manages and displays the syntax errors in Fragaria's
 * text view and gutter view.
 */
@property (nonatomic, strong, readwrite) MGSSyntaxErrorController *syntaxErrorController;

@end

