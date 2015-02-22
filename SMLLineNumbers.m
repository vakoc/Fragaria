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


@interface SMLLineNumbers()

@property (strong) id document;

@end


@implementation SMLLineNumbers

@synthesize document;

#pragma mark -
#pragma mark Instance methods
/*
 
 - init
 
 */
- (id)init
{
	self = [self initWithDocument:nil];
	
	return self;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

/*
 
 - initWithDocument:
 
 */
- (id)initWithDocument:(id)theDocument
{
	if ((self = [super init])) {
		
		self.document = theDocument;
    
		NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];
		[defaultsController addObserver:self forKeyPath:@"values.FragariaTextFont" options:NSKeyValueObservingOptionNew context:@"TextFontChanged"];
	}
	
    return self;
}

#pragma mark -
#pragma mark KVO
/*
 
 - observeValueForKeyPath:ofObject:change:context
 
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([(__bridge NSString *)context isEqualToString:@"TextFontChanged"]) {
        [self updateGutterView];
	} else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark -
#pragma mark View updating


- (void) updateGutterView {
    BOOL showGutter;
    
    // get editor views
    NSScrollView *textScrollView = (NSScrollView *)[document valueForKey:ro_MGSFOScrollView];

    MGSLineNumberView *ruler;
    
    showGutter = [[document valueForKey:MGSFOShowLineNumberGutter] boolValue];
    ruler = [document valueForKey:ro_MGSFOGutterView];
    if (showGutter) {
        [ruler setBackgroundColor:[NSColor colorWithCalibratedWhite:0.94f alpha:1.0f]];
        [ruler setTextColor:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsGutterTextColourWell]]];
        [ruler setFont:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsTextFont]]];
        [ruler setMinimumWidth:[[SMLDefaults valueForKey:MGSFragariaPrefsGutterWidth] doubleValue]];
    }
    [textScrollView setRulersVisible:showGutter];
}


@end
