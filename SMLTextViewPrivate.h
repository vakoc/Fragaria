//
//  SMLTextViewPrivate.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 26/02/15.
//
//

#import <Cocoa/Cocoa.h>
#import "SMLTextView.h"
#import "SMLAutoCompleteDelegate.h"


@interface SMLTextView ()


/** The autocomplete delegate for this text view. This property is private
 * because it is set to an internal object when MGSFragaria's autocomplete
 * delegate is set to nil. */
@property id<SMLAutoCompleteDelegate> autocompleteDelegate;

/** The controller which manages the accessory user interface for this text
 * view. */
@property (readonly) MGSExtraInterfaceController *interfaceController;


@end
