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

@interface MGSManagedPropertiesProxy : NSObject

@property (nonatomic, weak) MGSUserDefaultsController *userDefaultsController;
@property (nonatomic, weak) MGSPrefsViewContoller *viewController;

@end

@implementation MGSManagedPropertiesProxy

/*
 * - init
 *   This is a simple class and there's no need to specify multiple
 *   classes. Simply return the value appropriate to how we init'd.
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

@property (nonatomic, strong) MGSManagedPropertiesProxy *propertiesProxy;

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
        _propertiesProxy = [[MGSManagedPropertiesProxy alloc] initWithViewController:self];
    }

    return self;
}


#pragma mark - Property Accessors

/*
 *  @property setUserDefaultsController
 */
- (void)setUserDefaultsController:(MGSUserDefaultsController *)setUserDefaultsController
{
    [self willChangeValueForKey:@"managedProperties"];
    _userDefaultsController = setUserDefaultsController;
    self.propertiesProxy.userDefaultsController = setUserDefaultsController;
    [self didChangeValueForKey:@"managedProperties"];
	[self showOrHideViews];
}


/*
 * @property managedProperties
 */
- (id)managedProperties
{
    return self.propertiesProxy;
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
	NSSet *propertiesAvailable = self.userDefaultsController.managedProperties;
	
	if (!self.constraintsDict)
	{
		self.constraintsDict = [[NSMutableDictionary alloc] init];
	}
	
	for (NSString *key in [[self hideableViews] allKeys])
	{
		NSLayoutConstraint *hiddenConstraint;
		if ([[self.constraintsDict allKeys] containsObject:key])
		{
			hiddenConstraint = [self.constraintsDict objectForKey:key];
		}
		else
		{
			hiddenConstraint = [self makeHideConstraintForView:[self valueForKey:key]];
			[self.constraintsDict setObject:hiddenConstraint forKey:key];
		}
		
		NSSet *propertiesRequired = [[self hideableViews] objectForKey:key];

		[self.view layoutSubtreeIfNeeded];
		
		if (![propertiesAvailable intersectsSet:propertiesRequired] && self.hidesUselessPanels)
		{
			[[self valueForKey:key] addConstraint:hiddenConstraint];
		}
		else
		{
			[[self valueForKey:key] removeConstraint:hiddenConstraint];
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
