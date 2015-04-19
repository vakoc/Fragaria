//
//  MGSUserDefaultsController.h
//  Fragaria
//
//  Created by Jim Derry on 3/3/15.
//
//

#import <Foundation/Foundation.h>
#import "MGSUserDefaultsDefinitions.h"
#import "MGSUserDefaultsControllerProtocol.h"

@class MGSFragariaView;


/**
 *  The MGSUserDefaultsController and its related class are intended to
 *  function as replacements for NSUserDefaults and NSUserDefaultsController,
 *  principally adding the benefit of being able to manage multiple sets of
 *  the same defaults keys for multiple instances of an object. This can be
 *  particularly useful when binding to user-interface controls.
 *
 *  In order to support shared defaults, i.e., a default that serves as a master
 *  for multiple instances, there's also a global default. For example if you
 *  wish to ensure that multiple text views' `backgroundColor` is shared, you
 *  can specify that that `backgroundColor` is a global property.
 *
 *  In general user defaults managed by this class are not compatible with
 *  NSUserDefaults. It's certainly possible to use NSUserDefaults to change
 *  or read managed keys, but there's not much point.
 **/

@interface MGSUserDefaultsController : NSObject <MGSUserDefaultsController>


#pragma mark - Class Methods - Singleton Controllers

/**
 *  Provides a shared controller for `groupID`.
 *  @discuss All instances of MGSFragariaView that you wish to manage
 *  with this toolset must belong to at least one `groupID`. Every instance
 *  of MGSFragariaView within the same `groupID` is affected.
 *  @param groupID Indicates the identified for this group
 *  of user defaults.
 **/
+ (instancetype)sharedControllerForGroupID:(NSString *)groupID;


/**
 *  Provides the shared controller for global defaults.
 *  @discuss This controller manages properties that you wish to remain
 *  common among all groups in your application. Every instance of
 *  MGSFragariaView that belongs to a `groupID` is affected.
 **/
+ (instancetype)sharedController;


#pragma mark - Properties

/**
 *  Indicates whether or not properties are stored in user defaults.
 **/
@property (nonatomic, assign, getter=isPersistent) BOOL persistent;


#pragma mark - <MGSUserDefaults> Conformance - Properties

/**
 *  The groupID uniquely identifies the preferences that
 *  are managed by instances of this controller.
 **/
@property (nonatomic,strong,readonly) NSString *groupID;


/**
 *  Specifies the instances of MGSFragaria whose properties are
 *  managed by an instance of this controller.
 *
 *  @discuss When used with the sharedController (without a groupID)
 *  setting this property will have no effect. It will only contain
 *  a set of MGSFragariaView instances for _all_ user defaults
 *  controllers.
 **/
@property (nonatomic,strong) NSSet *managedInstances;


/**
 *  Specifies a set of NSString indicating the name of every property
 *  that is to be managed by this instance of this class.
 **/
@property (nonatomic, strong) NSSet *managedProperties;


/**
 *  Provides KVO-compatible structure for use with NSObjectController.
 *  @discuss Use only KVC setValue:forKey: and valueForKey: with this
 *  object. In general you have no reason to manually manipulate values
 *  with this structure. Simply set MGSFragariaView properties instead.
 **/
@property (nonatomic,strong, readonly) id values;


@end
