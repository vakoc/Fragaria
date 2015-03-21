//
//  MGSPrefsViewContoller.h
//  Fragaria
//
//  Created by Jim Derry on 3/15/15.
//
//

#import <Cocoa/Cocoa.h>

@class MGSUserDefaultsController;


/**
 *  MGSPrefsViewContoller provides a base class for other MGSPrefsViewController
 *  classes. It is not implemented directly anywhere.
 *  @see MGSPrefsEditorPropertiesViewController
 *  @see MGSPrefsColourPropertiesViewController
 **/

@interface MGSPrefsViewContoller : NSViewController

/**
 *  The NSObjectController that the UI elements are bound to.
 */
@property (nonatomic, weak) IBOutlet NSObjectController *objectController;

/**
 *  A reference to the properties controller that is the model for this view.
 **/
@property (nonatomic, weak) MGSUserDefaultsController *propertiesController;

@end
