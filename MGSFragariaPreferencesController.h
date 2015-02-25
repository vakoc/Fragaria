//
//  MGSFragariaPreferencesController.h
//  Fragaria
//
//  Created by Jim Derry on 2/9/15.
//
//

/**
 *   MGSPreferencesController is meant to unify the user defaults for the
 *   disparate pieces that make up Fragaria, while satisfying different types
 *   of use cases for one or more MGSFragaria instances in a single application.
 *
 *   - A new instance should be able to start with sane global defaults. For
 *     example a single window application with a single instance of
 *     MGSFragaria.
 *   - A new instance should be able to use defaults that apply to it only. For
 *     example non-document applications that have more than one instance will
 *     want to maintain global defaults, and defaults for each additional
 *     instance that may be persistent. Changes to each instance should not be
 *     recorded in the global defaults.
 *   - A new instance should be able to start with sane global defaults.
 *     However it should be independent of all other instances and have its own
 *     properties set without affecting other properties. These changes are not
 *     persistent, and is consistent with document-based applications.
 *
 *   Additionally:
 *
 *   - Implementers will want some global changes to affect all instances.
 *     This can be configured on a property-by-property basis. For example all
 *     instances may have a common background color while permitting different
 *     fonts.
 *   - Implementers will want some instance changes to apply globally. For
 *     example if the background color of an instance changes, then perhaps
 *     this should be reflected globally.
 *
 *   This behavior is managed internally using `standardUserDefaults` when
 *   necessary and a non-persistent `NSUserDefaults` otherwise.
 **/


#import <Foundation/Foundation.h>


#pragma mark - All user defaults keys by function and type


/* Editor Properties */

extern NSString * const temp_MGSFragariaPrefsLineWrap;


#pragma mark - Interface


@interface MGSFragariaPreferencesController : NSObject

/// @name Controller Properties

/** 
 *   The string representing the `standardUserDefaults` sub-path.
 *
 *   @discussion When this property is `nil` then Fragaria property settings are
 *   non-persistent In this sense they work very much like standard properties
 *   on any object. They will still take their values from `standardUserDefaults`,
 *   but you are responsible for setting `standardUserDefaults` if you want
 *   persistence.
 *
 *   If you assign a string then all properties for this instance will remain
 *   persistent by being stored in the application's Preferences file under an
 *   array key named `MGSFragariaPreferences-<persistentPath>`. Instances will
 *   first obtain their defaults from `standardUserDefaults` for
 *   application-level behaviors, but then will use their own defaults for
 *   view-level settings.
 *
 *   When using `persistentPath` you may naturally want some properties tied
 *   to `standardUserDefaults`. You can accomplish this via KVO {tbd}.
 **/

@property (nonatomic,strong) NSString *persistentPath;


/// @name Editor Properties


@property (nonatomic,assign) BOOL lineWrap;              ///< Indicates whether or not the text editor word wraps text.


@end
