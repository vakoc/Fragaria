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

@property (nonatomic, weak) MGSUserDefaultsController *propertiesController;
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
    BOOL managesProperty = [self.propertiesController.managedProperties containsObject:key];

    return @(managesProperty);
}

@end


#pragma mark - MGSPrefsViewController

@interface MGSPrefsViewContoller ()

@property (nonatomic, strong) MGSManagedPropertiesProxy *propertiesProxy;

@end


@implementation MGSPrefsViewContoller


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


/*
 *  @property propertiesController
 */
- (void)setPropertiesController:(MGSUserDefaultsController *)propertiesController
{
    [self willChangeValueForKey:@"managedProperties"];
    _propertiesController = propertiesController;
    self.propertiesProxy.propertiesController = propertiesController;
    [self didChangeValueForKey:@"managedProperties"];
}


/*
 * @property managedProperties
 */
- (id)managedProperties
{
    return self.propertiesProxy;
}


@end
