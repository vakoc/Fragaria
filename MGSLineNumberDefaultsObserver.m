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
 * - initWithFragaria
 */
- (instancetype)initWithLineNumberView:(MGSLineNumberView *)lnv
{
    if ((self = [super init]))
    {
        _lineNumberView = lnv;

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
    [_lineNumberView setBackgroundColor:[NSColor colorWithCalibratedWhite:0.94f alpha:1.0f]];
    [_lineNumberView setTextColor:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsGutterTextColourWell]]];
    [_lineNumberView setFont:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]]];
    [_lineNumberView setMinimumWidth:[[SMLDefaults valueForKey:MGSFragariaPrefsGutterWidth] doubleValue]];
}


@end
