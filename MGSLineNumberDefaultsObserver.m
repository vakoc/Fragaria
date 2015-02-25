/*
 
 MGSFragaria
 Written by Jonathan Mitchell, jonathan@mugginsoft.com
 Find the latest version at https://github.com/mugginsoft/Fragaria
 
 Smultron version 3.6b1, 2009-09-12
 Written by Peter Borg, pgw3@mac.com
 Find the latest version at http://smultron.sourceforge.net

 Copyright 2004-2009 Peter Borg
 
 Licensed under the Apache License, Version 2.0 (the "License"); you may not use
 this file except in compliance with the License. You may obtain a copy of the
 License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed
 under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
 CONDITIONS OF ANY KIND, either express or implied. See the License for the
 specific language governing permissions and limitations under the License.
*/

#import "MGSFragaria.h"
#import "MGSFragariaFramework.h"


@implementation MGSLineNumberDefaultsObserver


#pragma mark - Instance methods

/*
 * - init
 */
- (id)init
{
	self = [self initWithFragaria:nil];
	
	return self;
}


/*
 * - initWithFragaria
 */
- (instancetype)initWithFragaria:(MGSFragaria *)fragaria
{
    if ((self = [super init]))
    {
        _fragaria = fragaria;

        NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaTextFont" options:NSKeyValueObservingOptionNew context:@"TextFontChanged"];
    }

    return self;
}


/*
 * - dealloc
 */
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}



#pragma mark - KVO

/*
 * - observeValueForKeyPath:ofObject:change:context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([(__bridge NSString *)context isEqualToString:@"TextFontChanged"]) {
        [self updateGutterView];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


#pragma mark - View updating

/*
 * - updateGutterView
 */
- (void) updateGutterView
{
    // @todo: We're still using the docSpec indirectly, but at least we're not longer dependent
    //        upon it for initialization. As some of these properties are internally exposed,
    //        we can start to eliminate getting them from the docSpec.

    BOOL showGutter;
    
    // get editor views
    NSScrollView *textScrollView = [self.fragaria.docSpec valueForKey:ro_MGSFOScrollView];
    MGSLineNumberView *ruler = [self.fragaria.docSpec valueForKey:ro_MGSFOGutterView];
    
    showGutter = [[self.fragaria.docSpec valueForKey:MGSFOShowLineNumberGutter] boolValue];

    if (showGutter) {
        [ruler setBackgroundColor:[NSColor colorWithCalibratedWhite:0.94f alpha:1.0f]];
        [ruler setTextColor:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsGutterTextColourWell]]];
        [ruler setFont:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]]];
        [ruler setMinimumWidth:[[SMLDefaults valueForKey:MGSFragariaPrefsGutterWidth] doubleValue]];
    }
    [textScrollView setRulersVisible:showGutter];
}


@end
