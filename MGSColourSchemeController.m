//
//  MGSColourSchemeController.m
//  Fragaria
//
//  Created by Jim Derry on 3/16/15.
//
//

#import "MGSColourSchemeController.h"
#import "MGSColourScheme.h"
#import "MGSColourSchemeSaveController.h"

#pragma mark - Constants

NSString * const KMGSColourSchemesFolder = @"Colour Schemes";
NSString * const KMGSColourSchemeExt = @"plist";


#pragma mark - Category


@interface MGSColourSchemeController ()

@property (nonatomic, strong, readwrite) NSMutableArray *colourSchemes;

@property (nonatomic, strong) MGSColourScheme *currentScheme;
@property (nonatomic, assign) BOOL currentSchemeIsCustom;

@property (nonatomic, assign) BOOL ignoreObservations;

@property (nonatomic, strong) MGSColourSchemeSaveController *saveController;

@end


#pragma mark - Implementation


@implementation MGSColourSchemeController


#pragma mark - Initializers

/*
 *  - init
 */
- (instancetype)init
{
	if ((self = [super init]))
	{
		[self setup];
	}
	
	return self;
}


/*
 *  - awakeFromNib
 */
- (void)awakeFromNib
{
    [self setup];
}


/*
 * - dealloc
 */
- (void)dealloc
{
    [self teardownObservers];
}


/*
 * - setup
 */
- (void)setup
{
	[self loadColourSchemes];
	
    [self setSortDescriptors:@[ [[NSSortDescriptor alloc] initWithKey:@"displayName"
                                                            ascending:YES
                                                             selector:@selector(localizedCaseInsensitiveCompare:)]
                                ]];

    // Connect our values.
    [self setContent:self.colourSchemes];
	
    // Setup observation of the properties of the connected outlets.
    [self setupObservers];

    // Set our current scheme based on the view settings.
	self.currentScheme = [self makeColourSchemeFromViewForScheme:nil];
    
	// If the current scheme matches an existing theme, then set it.
//    [self findAndSetCurrentScheme];
}


#pragma mark - Properties


/*
 * @property buttonSaveDeleteEnabled
 */
+ (NSSet *)keyPathsForValuesAffectingButtonSaveDeleteEnabled
{
    return [NSSet setWithArray:@[ @"self.selectionIndex", @"self.currentScheme" ]];
}
- (BOOL)buttonSaveDeleteEnabled
{
    BOOL result;
    result = self.currentScheme && !self.currentScheme.loadedFromBundle;
    result = result || self.currentSchemeIsCustom;

    return result;
}


/*
 * @property buttonSaveDeleteTitle
 */
+ (NSSet *)keyPathsForValuesAffectingButtonSaveDeleteTitle
{
    return [NSSet setWithArray:@[ @"self.selectionIndex", @"self.currentScheme" ]];
}
- (NSString *)buttonSaveDeleteTitle
{
    // Rules:
    // - If the current scheme is self.currentSchemeIsCustom, can save.
    // - If the current scheme is not built-in, can delete.
    // - Otherwise the button should read as saving (will be disabled).

    if ( self.currentSchemeIsCustom || self.currentScheme.loadedFromBundle)
    {
        return NSLocalizedString(@"Save Scheme…", @"The text for the save/delete scheme button when it should read Save Scheme…");
    }

    return NSLocalizedString(@"Delete Scheme…", @"The text for the save/delete scheme button when it should read Delete Scheme…");
}

#pragma mark - KVO/KVC


/*
 * -setupObservers
 */
- (void)setupObservers
{
    // Observe the correct keypaths in the defaultsObjectController
    for (NSString *key in [[MGSColourScheme class] propertiesOfScheme])
    {
        if ([[self.objectController.content allKeys] containsObject:key])
        {
            NSString *keyPath = [NSString stringWithFormat:@"selection.%@", key];
            [self.objectController addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:(__bridge void *)(key)];
        }
    }

    [self addObserver:self forKeyPath:@"selectionIndex" options:NSKeyValueObservingOptionNew context:@"schemeMenu"];
    [self addObserver:self forKeyPath:@"objectController.content" options:NSKeyValueObservingOptionNew context:@"defaultsObjectController"];
}


/*
 * - teardownObservers
 */
- (void)teardownObservers
{
    // Observe the correct keypaths in the defaultsObjectController
    for (NSString *key in [[MGSColourScheme class] propertiesOfScheme])
    {
        if ([[self.objectController.content allKeys] containsObject:key])
        {
            NSString *keyPath = [NSString stringWithFormat:@"selection.%@", key];
            [self.objectController removeObserver:self forKeyPath:keyPath context:(__bridge void *)(key)];
        }
    }

    [self removeObserver:self forKeyPath:@"selectionIndex" context:@"schemeMenu"];
    [self removeObserver:self forKeyPath:@"defaultsObjectController.content" context:@"defaultsObjectController"];
}


/*
 * - observeValueForKeyPath:ofObject:change:context:
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSString *localContext = (__bridge NSString *)(context);

    if ([localContext isEqualToString:@"defaultsObjectController"])
    {
        NSLog(@"This should be a one-time shot, otherwise we're in trouble for re-registering too many observers.");
        [self setup];
    }
    else if ( !self.ignoreObservations && [[[MGSColourScheme class] propertiesOfScheme] containsObject:localContext] )
    {
        [self willChangeValueForKey:@"buttonSaveDeleteEnabled"];
        [self willChangeValueForKey:@"buttonSaveDeleteTitle"];
        [self findAndSetCurrentScheme];
        [self didChangeValueForKey:@"buttonSaveDeleteEnabled"];
        [self didChangeValueForKey:@"buttonSaveDeleteTitle"];
    }
    else if ([object isEqualTo:self] && !self.ignoreObservations && [localContext isEqualToString:@"schemeMenu"])
    {
        [self willChangeValueForKey:@"buttonSaveDeleteEnabled"];
        [self willChangeValueForKey:@"buttonSaveDeleteTitle"];
        MGSColourScheme *newScheme = [self.arrangedObjects objectAtIndex:self.selectionIndex];
        if (self.currentSchemeIsCustom)
        {
            self.ignoreObservations = YES;
            [self removeObject:self.currentScheme];
            self.currentSchemeIsCustom = NO;
            self.ignoreObservations = NO;
        }
        self.currentScheme = newScheme;
        [self applyColourSchemeToView];
        [self didChangeValueForKey:@"buttonSaveDeleteEnabled"];
        [self didChangeValueForKey:@"buttonSaveDeleteTitle"];
    }
}


#pragma mark - Actions


/*
 * - addDeleteButtonAction
 */
- (IBAction)addDeleteButtonAction:(id)sender
{
    // Rules:
    // - If the current scheme is self.currentSchemeIsCustom, will save.
    // - If the current scheme is not built-in, will delete.
    // - Otherwise someone forgot to bind to the enabled property properly.

    if (self.currentSchemeIsCustom)
    {
        __block NSString *path = [self applicationSupportDirectory];
        path = [path stringByAppendingPathComponent:KMGSColourSchemesFolder];

        [[NSFileManager defaultManager] createDirectoryAtPath: path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];

        self.saveController = [[MGSColourSchemeSaveController alloc] init];
        self.saveController.schemeName = NSLocalizedString(@"New Scheme", @"Default name for new schemes.");
        [self.saveController showSchemeNameGetter:self.parentView.window completion:^(void) {
            if (self.saveController.schemeName)
            {
                NSCharacterSet* cleanCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>"];
                NSString *cleanName = [[self.saveController.schemeName componentsSeparatedByCharactersInSet:cleanCharacters] componentsJoinedByString:@""];

                path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",cleanName, KMGSColourSchemeExt]];
                self.currentScheme.displayName = self.saveController.schemeName;
                [self.currentScheme propertiesSaveToFile:path];
                self.currentSchemeIsCustom = NO;
            }
        }];
    }
    else if (!self.currentScheme.loadedFromBundle)
    {
        self.saveController = [[MGSColourSchemeSaveController alloc] init];
        [self.saveController showDeleteConfirmation: self.parentView.window completion:^void (BOOL cancelled) {
            if (!cancelled)
            {
                [self removeObject:self.currentScheme];
                [[NSFileManager defaultManager] removeItemAtPath:self.currentScheme.sourceFile error:nil];
            }
        }];
    }

}


#pragma mark - Private/Internal


/*
 * - findMatchingSchemeForScheme:
 *   We're not forcing applications to store the name of a scheme, so try
 *   to determine what the current theme is based on the properties.
 */
- (MGSColourScheme *)findMatchingSchemeForScheme:(MGSColourScheme *)scheme
{
	// arrangedObjects may not exist yet, so lets sort things ourselves...
    NSArray *sortedArray = [self.colourSchemes sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        return [[a valueForKey:@"displayName"] localizedCaseInsensitiveCompare:[b valueForKey:@"displayName"]];
    }];

    // ignore the custom theme if it's in the list. Convoluted, but avoids string checking.
    sortedArray = [sortedArray objectsAtIndexes:[sortedArray indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return !( self.currentSchemeIsCustom && [self.currentScheme isEqual:obj] );
    }]];

    for (MGSColourScheme *item in sortedArray)
	{
		if ([scheme isEqualToScheme:item])
		{
            return item;
		}
	}

	return nil;
}


/*
 * - applicationSupportDirectory
 *   Get access to the user's Application Support directory, creating if needed.
 */
- (NSString *)applicationSupportDirectory
{
	NSArray *URLS = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory
														   inDomains:NSUserDomainMask];
	if (URLS)
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSURL *appSup = [URLS firstObject];
		NSURL *finalURL;
		NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
		
		if (infoDictionary.count != 0)
		{
			finalURL = [appSup URLByAppendingPathComponent:[infoDictionary objectForKey:@"CFBundleExecutable"] isDirectory:YES];
		}
		else
		{
			// Unit testing results in empty infoDictionary, so use a custom location.
			finalURL = [appSup URLByAppendingPathComponent:@"MGSFragaria Framework Unit Tests" isDirectory:YES];
		}
		
		if (![fileManager changeCurrentDirectoryPath:[finalURL path]])
		{
			[fileManager createDirectoryAtURL:finalURL
                  withIntermediateDirectories:YES
								   attributes:nil
                                        error:nil];
		}
		return [finalURL path];
	}
	else
	{
		return nil;
	}
}


/*
 * - addColourSchemesFromPath
 *   Given a directory path, load all of the plist files that are there.
 */
- (void)addColourSchemesFromPath:(NSString *)path bundleFlag:(BOOL)bundleFlag
{
	// Build list of files to load.
	NSString *directory = [path stringByAppendingPathComponent:KMGSColourSchemesFolder];
	NSFileManager *fileManager = [NSFileManager defaultManager];

	NSString *filter = [NSString stringWithFormat:@"self ENDSWITH '.%@'", KMGSColourSchemeExt];
	NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:directory error:nil];
	fileArray = [fileArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:filter]];
	
	// Append each file to the dictionary of colour schemes. By design,
	// subsequently loaded schemes with the same name replace existing.
	// This lets the application bundle override the framework, and lets
	// the user's Application Support override everything else.
	for (NSString *file in fileArray)
	{
		NSString *complete = [directory stringByAppendingPathComponent:file];
        MGSColourScheme *scheme = [[MGSColourScheme alloc] initWithFile:complete];
		scheme.loadedFromBundle = bundleFlag;
		[self.colourSchemes addObject:scheme];
	}
}


/*
 * - loadColourSchemes
 *   Look in several possible locations for scheme files.
 */
- (void)loadColourSchemes
{
	self.colourSchemes = [[NSMutableArray alloc] init];
	
	// Load schemes from this bundle
	NSString *path = [[NSBundle bundleForClass:[self class]] bundlePath];
	path = [path stringByAppendingPathComponent:@"Resources"];
	[self addColourSchemesFromPath:path bundleFlag:YES];
	
	// Load schemes from app bundle
	path = [[NSBundle mainBundle] bundlePath];
	path = [path stringByAppendingPathComponent:@"Resources"];
	[self addColourSchemesFromPath:path bundleFlag:YES];
	
	// Load schemes from application support
	path = [self applicationSupportDirectory];
	[self addColourSchemesFromPath:path bundleFlag:NO];
}


/*
 * - makeColourSchemeFromView
 *   The defaultsObjectController contains all of the current colour settings 
 *   for the instance of FragariaView, so return an instance of MGSColourScheme
 *   with these settings.
 */
- (MGSColourScheme *)makeColourSchemeFromViewForScheme:(MGSColourScheme *)currentViewScheme
{
    if (!currentViewScheme)
    {
        currentViewScheme = [[MGSColourScheme alloc] init];
    }

    for (NSString *key in [[MGSColourScheme class] propertiesOfScheme])
    {
        if ([[self.objectController.content allKeys] containsObject:key])
        {
            [currentViewScheme setValue:[self.objectController.selection valueForKey:key] forKey:key];
        }
    }

	return currentViewScheme;
}


/*
 * - applyColourSchemeToView
 *   apply the current colour scheme directly to the defaultsObjectController.
 */
- (void)applyColourSchemeToView
{
    self.ignoreObservations = YES;
    for (NSString *key in [[MGSColourScheme class] propertiesOfScheme])
    {
        if ([[self.objectController.content allKeys] containsObject:key])
        {
            id remote = [self.objectController.selection valueForKey:key];
            id local = [self.currentScheme valueForKey:key];
            if (![remote isEqual:local])
            {
                [self.objectController.selection setValue:[self.currentScheme valueForKey:key] forKey:key];
            }
        }
    }
    self.ignoreObservations = NO;
}


/*
 * - findAndSetCurrentScheme
 *   If the view's settings match a known scheme, then set that as the active
 *   scheme, otherwise create a new (unsaved) scheme.
 */
- (void)findAndSetCurrentScheme
{
	MGSColourScheme *currentViewScheme = [self makeColourSchemeFromViewForScheme:nil];
    MGSColourScheme *matchingScheme = [self findMatchingSchemeForScheme:currentViewScheme];

	if (matchingScheme)
    {
        if (self.currentSchemeIsCustom)
        {
            [self removeObject:self.currentScheme];
        }
		self.currentScheme = matchingScheme;
        self.selectionIndex = [self.arrangedObjects indexOfObject:self.currentScheme];
        self.currentSchemeIsCustom = NO;
    }
    else
    {
        if (!self.currentSchemeIsCustom)
        {
            // Create and activate a custom scheme.
			self.currentScheme = currentViewScheme;
            self.currentSchemeIsCustom = YES;
            self.ignoreObservations = YES;
            [self addObject:self.currentScheme];
            self.ignoreObservations = NO;
		}
        else
        {
            // Take the current controller values.
            self.currentScheme = [self makeColourSchemeFromViewForScheme:self.currentScheme];
        }
    }
}


@end
