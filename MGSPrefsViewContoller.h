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


/**
 *  Returns whether or not a property is a managed property. This is a KVC
 *  structure that returns @(YES) or @(NO) for keyPaths in the form of
 *  this_controller.managedProperties.propertyName.
 *  @discuss Useful for user interface enabled bindings to disable elements
 *  that the propertiesController doesn't manage.
 **/
@property (nonatomic, assign, readonly) id managedProperties;


/**
 *  Bindable property indicating whether or not the scheme menu should be
 *  enabled. If the instance does not have available every property for a
 *  scheme, then using the scheme selector can be quite messy.
 **/
@property (nonatomic, assign, readonly) BOOL areAllColourPropertiesAvailable;

@end
