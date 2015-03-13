//
//  MGSUserDefaultsController.m
//  Fragaria
//
//  Created by Jim Derry on 3/3/15.
//
//

#import <objc/runtime.h>
#import "MGSUserDefaultsController.h"
#import "MGSUserDefaultsDefinitions.h"
#import "MGSUserDefaults.h"
#import "MGSFragariaView.h"


#pragma mark - NSMutableDictionary (MGSFragariaDict) - Interface

/*
 *  A category for NSMutableDictionary so that we can persist keys, if required.
 *  Uses KVC-compliant setValue:forKey: and valueForKey: to work.
 */
@interface NSMutableDictionary (MGSFragariaDict)

@property (nonatomic, assign) MGSUserDefaultsController *controller;

@end


#pragma mark - NSMutableDictionary (MGSFragariaDict) - Implementation


@implementation NSMutableDictionary (MGSFragariaDict)

/*
 *  @property controller
 */
- (void)setController:(MGSUserDefaultsController *)controller
{
	objc_setAssociatedObject(self, @selector(controller), controller, OBJC_ASSOCIATION_ASSIGN);
}

- (MGSUserDefaultsController *)controller
{
	return objc_getAssociatedObject(self, @selector(controller));
}



/*
 *  - setValue:forKey:
 */
- (void)setValue:(id)value forKey:(NSString *)key
{
    [self setObject:value forKey:key];

    if (self.controller.persistent)
    {
        [[MGSUserDefaults sharedUserDefaultsForGroupID:self.controller.groupID] setObject:value forKey:key];
    }
}


/*
 *  - valueForKey:
 */
- (id)valueForKey:(NSString *)key
{
    if (self.controller.persistent)
    {
        return [[MGSUserDefaults sharedUserDefaultsForGroupID:self.controller.groupID] objectForKey:key];
    }

    return [self objectForKey:key];
}

@end



#pragma mark - CATEGORY MGSUserDefaultsController

@interface MGSUserDefaultsController ()

@property (nonatomic, strong, readwrite) id values;

@end


#pragma mark - CLASS MGSUserDefaultsController - Implementation

static NSMutableDictionary *controllerInstances;

@implementation MGSUserDefaultsController

@synthesize managedInstances = _managedInstances;
@synthesize persistent = _persistent;


#pragma mark - Class Methods - Singleton Controllers

/*
 *  + sharedControllerForGroupID:
 */
+ (instancetype)sharedControllerForGroupID:(NSString *)groupID
{
    //static NSMutableDictionary *controllerInstances;
	
	@synchronized(self) {

        if (!controllerInstances)
        {
            controllerInstances = [[NSMutableDictionary alloc] init];
        }

		if ([[controllerInstances allKeys] containsObject:groupID])
		{
			return [controllerInstances objectForKey:groupID];
		}
	
		MGSUserDefaultsController *newController = [[[self class] alloc] initWithGroupID:groupID];
		[controllerInstances setObject:newController forKey:groupID];
		return newController;
	}
}


/*
 *  + sharedController
 */
+ (instancetype)sharedController
{
	return [[self class] sharedControllerForGroupID:MGSUSERDEFAULTS_GLOBAL_ID];
}


#pragma mark - Property Accessors

/*
 *  @property managedInstances
 */
- (void)setManagedInstances:(NSSet *)managedInstances
{
	NSAssert(![self.groupID isEqualToString:MGSUSERDEFAULTS_GLOBAL_ID],
			 @"You cannot set managedInstances for the global controller.");
	
	[self unregisterBindings:_managedProperties];
    _managedInstances = managedInstances;
	[self registerBindings:_managedProperties];
}

- (NSSet *)managedInstances
{
    if ([self.groupID isEqualToString:MGSUSERDEFAULTS_GLOBAL_ID])
    {
        NSMutableSet *allInstances = [[NSMutableSet alloc] init];

        for (MGSUserDefaultsController *controllerInstance in [controllerInstances allValues])
        {
            if (![controllerInstance.groupID isEqualToString:MGSUSERDEFAULTS_GLOBAL_ID])
            {
                [allInstances unionSet:controllerInstance.managedInstances];
            }
        }
        return allInstances;
    }
    else
    {
        return _managedInstances;
    }
}


/*
 *  @property managedProperties
 */
- (void)setManagedProperties:(NSSet *)managedProperties
{
	[self unregisterBindings:_managedProperties];
    _managedProperties = managedProperties;
	[self registerBindings:_managedProperties];
}


/*
 *  @property persistent
 */
- (void)setPersistent:(BOOL)persistent
{
	if (_persistent == persistent) return;

    _persistent = persistent;

	if (persistent)
	{
        [[NSUserDefaults standardUserDefaults] setObject:self.values forKey:self.groupID];
        
		[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self
																  forKeyPath:[NSString stringWithFormat:@"values.%@", self.groupID]
																	 options:NSKeyValueObservingOptionNew
																	 context:(__bridge void *)(self.groupID)];
	}
	else
	{
		[[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self
                                                                     forKeyPath:[NSString stringWithFormat:@"values.%@", self.groupID]
                                                                        context:(__bridge void *)(self.groupID)];

        NSDictionary *defaultsValues = [[NSUserDefaults standardUserDefaults] objectForKey:self.groupID];

        for (NSString *key in self.values)
        {
            if (![[self.values valueForKey:key] isEqualTo:[defaultsValues valueForKey:key]])
            {
                [self.values setValue:[defaultsValues valueForKey:key] forKey:key];
            }
        }
	}
}

- (BOOL)isPersistent
{
	return _persistent;
}


#pragma mark - Initializers (not exposed)

/*
 *  - initWithGroupID:
 */
- (instancetype)initWithGroupID:(NSString *)groupID
{
	if ((self = [super init]))
	{
		_groupID = groupID;

		NSDictionary *defaults = [[MGSUserDefaultsDefinitions class] fragariaDefaultsDictionary];
		
		[[MGSUserDefaults sharedUserDefaultsForGroupID:groupID] registerDefaults:defaults];
		_values = [[NSMutableDictionary alloc] initWithDictionary:defaults];
		[(NSMutableDictionary *)_values setController:self];
	}
	
	return self;
}


/*
 *  - init
 *    Just in case someone tries to create their own instance
 *    of this class, we'll make sure it's always "Global".
 */
- (instancetype)init
{
	return [self initWithGroupID:MGSUSERDEFAULTS_GLOBAL_ID];
}


#pragma mark - Binding Registration/Unregistration and KVO Handling


/*
 *  -registerBindings
 */
- (void)registerBindings:(NSSet *)propertySet
{
	// Bind all relevant properties of each instance to `values` dictionary.
	[propertySet enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, BOOL *stop) {
		for (MGSFragariaView *fragaria in self.managedInstances)
		{
			[fragaria bind:key toObject:self.values withKeyPath:key options:nil];
		}
	}];
}


/*
 *  - unregisterBindings:
 */
- (void)unregisterBindings:(NSSet *)propertySet
{
    // Stop observing properties
    [propertySet enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id key, BOOL *stop) {
        for (MGSFragariaView *fragaria in self.managedInstances)
        {
            [fragaria unbind:key];
        }
    }];
}


/*
 * - observeValueForKeyPath:ofObject:change:context:
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	// The only keypath we've registered, but let's check in case we accidentally something.
	if ([[NSString stringWithFormat:@"values.%@", self.groupID] isEqualToString:keyPath])
	{
        NSDictionary *defaultsValues = [[NSUserDefaults standardUserDefaults] objectForKey:self.groupID];
        for (NSString *key in defaultsValues)
        {
            // If we use self.value valueForKey: here, we will get the value from defaults.
            if (![[defaultsValues valueForKey:key] isEqualTo:[self.values objectForKey:key]])
            {
                [self.values setValue:[defaultsValues valueForKey:key] forKey:key];
            }
        }
	}
}


@end
