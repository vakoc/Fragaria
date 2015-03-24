//
//  MGSPrefsViewContoller.m
//  Fragaria
//
//  Created by Jim Derry on 3/15/15.
//
//

#import "MGSPrefsViewContoller.h"
#import "MGSUserDefaultsController.h"


#pragma mark - MGSManagedPropertiesProxy Class

/*
 *  This bindable proxy object exists to support the managedProperties 
 *  property, whereby we return a @(BOOL) indicating whether or not the
 *  view controller's NSUserDefaultsController is managing the property
 *  in the keypath, e.g., `viewController.managedProperties.textColour`.
 */
@interface MGSManagedPropertiesProxy : NSObject

@property (nonatomic, weak) MGSUserDefaultsController *userDefaultsController;
@property (nonatomic, weak) MGSPrefsViewContoller *viewController;

@end


@implementation MGSManagedPropertiesProxy

/*
 * - init
 */
- (instancetype)initWithViewController:(MGSPrefsViewContoller *)viewController
{
    if ((self = [super init]))
    {
        self.viewController = viewController;
    }

    return self;
}


/*
 * - valueForKey
 */
-(id)valueForKey:(NSString *)key
{
    BOOL managesProperty = [self.userDefaultsController.managedProperties containsObject:key];

    return @(managesProperty);
}

@end


#pragma mark - MGSPrefsViewController

@interface MGSPrefsViewContoller ()

@property (nonatomic, strong) MGSManagedPropertiesProxy *managedPropertiesProxy;

@property (nonatomic, strong) NSMutableDictionary *constraintsDict;

@end


@implementation MGSPrefsViewContoller


#pragma mark - Initialization

/*
 * - init
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        _managedPropertiesProxy = [[MGSManagedPropertiesProxy alloc] initWithViewController:self];
		_constraintsDict = [[NSMutableDictionary alloc] init];
    }

    return self;
}


#pragma mark - Property Accessors

/*
 *  @property setUserDefaultsController
 */
- (void)setUserDefaultsController:(MGSUserDefaultsController *)userDefaultsController
{
    [self willChangeValueForKey:@"managedProperties"];
    _userDefaultsController = userDefaultsController;
    self.managedPropertiesProxy.userDefaultsController = userDefaultsController;
    [self didChangeValueForKey:@"managedProperties"];
	[self showOrHideViews];
}


/*
 * @property managedProperties
 */
- (id)managedProperties
{
    return self.managedPropertiesProxy;
}


/*
 * @property areAllColourPropertiesAvailable
 */
+ (NSSet *)keyPathsForValuesAffectingAreAllColourPropertiesAvailable
{
	return [NSSet setWithArray:@[ @"managedProperties" ]];
}
- (BOOL)areAllColourPropertiesAvailable
{
	NSSet *propertiesAvailable = self.userDefaultsController.managedProperties;
	NSSet *propertiesRequired = [[MGSUserDefaultsDefinitions class] propertyGroupThemeColours];
	return [propertiesRequired isSubsetOfSet:propertiesAvailable];
}


/*
 * @property hidesUselessPanels
 */
- (void)setHidesUselessPanels:(BOOL)hidesUselessPanels
{
	_hidesUselessPanels = hidesUselessPanels;
	[self showOrHideViews];
}


#pragma mark - Instance Methods

/*
 * - hideableViews
 *   Subclasses wishing to support automatic view hiding should override this.
 *   See the reference implementation for an example of the dictionary format.
 */
- (NSDictionary *)hideableViews;
{
	return @{};
}


#pragma mark - Supporting Methods


/*
 * - showOrHideViews
 */
- (void)showOrHideViews
{
	/* At this point, it's perfectly possible that the userDefaultsController
       hasn't been assigned yet, and so we don't know what the properties are
	   that we're going to manage. */
	
	NSSet *propertiesAvailable = self.userDefaultsController.managedProperties;
	
	for (NSString *key in [[self hideableViews] allKeys])
	{
		NSLayoutConstraint *constraint;
		if ([[self.constraintsDict allKeys] containsObject:key])
		{
			constraint = [self.constraintsDict objectForKey:key];
		}
		else
		{
			constraint = [self makeHideConstraintForView:[self valueForKey:key]];
			[self.constraintsDict setObject:constraint forKey:key];
		}
		
		NSSet *propertiesRequired = [[self hideableViews] objectForKey:key];

		[self.view layoutSubtreeIfNeeded];
		
		if (self.hidesUselessPanels && ![propertiesAvailable intersectsSet:propertiesRequired])
		{
			[[self valueForKey:key] addConstraint:constraint];
		}
		else
		{
			[[self valueForKey:key] removeConstraint:constraint];
		}
		 
		[self.view layoutSubtreeIfNeeded];
	}
}


/*
 * - makeHideConstraintForView
 */
- (NSLayoutConstraint *)makeHideConstraintForView:(NSView *)view
{
	return [NSLayoutConstraint constraintWithItem:view
										attribute:NSLayoutAttributeHeight
										relatedBy:NSLayoutRelationEqual
										   toItem:nil
										attribute:NSLayoutAttributeNotAnAttribute
									   multiplier:1.0
										 constant:0.0];
}


@end
