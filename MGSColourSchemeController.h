//
//  MGSColourSchemeController.h
//  Fragaria
//
//  Created by Jim Derry on 3/16/15.
//
//

#import <Foundation/Foundation.h>

@class MGSPreferencesController;


/**
 *  MGSColourSchemeController manages MGSColourScheme instances for use in
 *  UI applications. Although it's designed for use with the MGSFragariaView
 *  settings panel(s), it should be suitable for use in other classes, too.
 *  As an NSArrayController descendent, it can be instantiated by IB.
 *
 *  MGSColourSchemeController doesn't pretend to know anything about your
 *  views or make assumptions about property names. These are only accessible
 *  via an NSObjectController that you connect to defaultsObjectController.
 *  And of course that NSObjectController must be connected to the
 *  MGSUserDefaultsController that is providing model data for your view.
 *
 *  Schemes are loaded first from the framework bundle, then the application
 *  bundle, then finally from the application's Application Support folder.
 *  Subsequent schemes with the same displayName replace schemes loaded
 *  earilier, given you the chance to modify them without modifying the
 *  framework bundle.
 *
 *  No part of Fragaria saves the scheme name. Consequently the colour scheme
 *  controller looks for a matching named scheme for the current colour
 *  settings, which effectively prevents duplicated schemes.
 *
 *  Schemes are saved in the application's Application Support/Colour Schemes
 *  directory, and only those schemes can be deleted.
 *
 *  To create a new scheme, you have to modify an already existing scheme, at
 *  which point the name of the scheme changes to Custom Settings. This
 *  scheme can then be saved when ready.
 *
 *  This makes it impossible to modify existing schemes per se, however the
 *  workaround is to modify the existing scheme and save it with a new name,
 *  The previous version can then be selected and deleted. This is consistent
 *  with the behaviour in other text editors.
 **/
@interface MGSColourSchemeController : NSArrayController


/// @name IBOutlet Properties - Controls

/** A reference to the MGSUserDefaultsController for the view.
    @discuss This controller needs to know where the model data for your view
    is. Your view should access MGSFragariaView properties with an
    NSOBjectController. This property is a reference to that controller. */
@property (nonatomic, assign) IBOutlet NSObjectController *defaultsObjectController;

/** A popup list that provides the current list of available schemes. */
@property (nonatomic, assign) IBOutlet NSPopUpButton *schemeMenu;

/** A button used to save or delete a scheme.
    @discuss Its action should be set to -addDeleteButtonAction:
    You can get a suitable title and enabled state from buttonSaveDeleteTitle
    and buttonSaveDeleteEnabled respectively. */
@property (nonatomic, assign) IBOutlet NSButton *schemeSaveDeleteButton;

/** A reference to the parent view. */
@property (nonatomic, assign) IBOutlet NSView *parentView;


/// @name Properties - Bindable for UI Use

/** The current correct state of a save/delete button. Bind the button to
 this property in interface builder to ensure its correct state. */
@property (nonatomic, assign, readonly) BOOL buttonSaveDeleteEnabled;

/** A title for the save/delete button. Bind the button to this property
 in interface builder for automatic localized button name. */
@property (nonatomic, assign, readonly) NSString *buttonSaveDeleteTitle;


/// @name Actions

/** The add/delete button action.
    @discuss When your button's title is bound to buttonSaveDelete title,
    the title will update dynamically to reflect the correct action. 
    @param sender The object that sent the action. */
- (IBAction)addDeleteButtonAction:(id)sender;



@end
