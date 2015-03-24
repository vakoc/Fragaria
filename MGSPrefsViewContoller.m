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

@end


@implementation MGSPrefsViewContoller {
    NSMutableArray *separators;
}


#pragma mark - Initialization

/*
 * - init
 */
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        _managedPropertiesProxy = [[MGSManagedPropertiesProxy alloc] initWithViewController:self];
        separators = [[NSMutableArray alloc] init];
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
	NSSet *propertiesRequired = [[MGSUserDefaultsDefinitions class] propertyGroupTheme];
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
- (NSDictionary *)hideableViews
{
	return @{};
}


- (NSArray *)keysForPanelSubviews
{
    return @[];
}


#pragma mark - Supporting Methods


/*
 * - showOrHideViews
 */
/* At this point, it's perfectly possible that the userDefaultsController
 hasn't been assigned yet, and so we don't know what the properties are
 that we're going to manage. */
- (void)showOrHideViews
{
	NSSet *propertiesAvailable = self.userDefaultsController.managedProperties;
    NSView *sep, *prev;
    NSArray *allViewsKeys, *cs;
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view removeConstraints:[self.view constraints]];
    for (sep in separators) {
        [sep removeFromSuperview];
    }
    [separators removeAllObjects];
	
    allViewsKeys = [self keysForPanelSubviews];
	for (NSString *key in allViewsKeys) {
        NSView *thisView = [self valueForKey:key];
		NSSet *propertiesRequired = [[self hideableViews] objectForKey:key];
        BOOL hidden = propertiesRequired && ![propertiesAvailable intersectsSet:propertiesRequired];
		
		if (self.hidesUselessPanels && hidden) {
            [self hidePanelView:thisView];
		} else {
            [self stackPanelView:thisView underPanelView:prev];
            prev = thisView;
		}
	}
    
    cs = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prev]|" options:0
      metrics:nil views:NSDictionaryOfVariableBindings(prev)];
    [self.view addConstraints:cs];
    
    /* This is needed to update the view's height, because the preference
     * window handler will cache it before the first display. */
    [self.view layoutSubtreeIfNeeded];
}


- (void)stackPanelView:(NSView *)view underPanelView:(NSView *)prev
{
    NSArray *cs;
    NSBox *newsep;
    
    cs = [NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|" options:0
      metrics:nil views:NSDictionaryOfVariableBindings(view)];
    [self.view addConstraints:cs];
    
    if (prev) {
        newsep = [[NSBox alloc] init];
        [newsep setTranslatesAutoresizingMaskIntoConstraints:NO];
        [newsep setBoxType:NSBoxSeparator];
        [self.view addSubview:newsep];
        cs = [NSLayoutConstraint constraintsWithVisualFormat:@"|[newsep]|"
          options:0 metrics:nil views:NSDictionaryOfVariableBindings(newsep)];
        [self.view addConstraints:cs];
        cs = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[newsep(==1)]"
          options:0 metrics:nil views:NSDictionaryOfVariableBindings(newsep)];
        [self.view addConstraints:cs];
        [separators addObject:newsep];
        
        cs = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[prev]-0-[newsep]"
          options:0 metrics:nil views:NSDictionaryOfVariableBindings(prev, newsep)];
        [self.view addConstraints:cs];
        
        cs = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[newsep]-0-[view]"
          options:0 metrics:nil views:NSDictionaryOfVariableBindings(newsep, view)];
    } else {
        cs = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]"
          options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
    }
    [self.view addConstraints:cs];
}


- (void)hidePanelView:(NSView*)view
{
    NSArray *cs;
    
    /* Move the view out of the bounds of its parent view */
    cs = @[[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight
        relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft
        multiplier:1.0 constant:0.0],
      [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop
        relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop
        multiplier:1.0 constant:0.0]];
    [self.view addConstraints:cs];
}


@end
