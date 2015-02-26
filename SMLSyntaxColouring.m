

/* This class syntax-colours and line-highlights. */

/*

 MGSFragaria
 Written by Jonathan Mitchell, jonathan@mugginsoft.com
 Find the latest version at https://github.com/mugginsoft/Fragaria
 
 Smultron version 3.6b1, 2009-09-12
 Written by Peter Borg, pgw3@mac.com
 Find the latest version at http://smultron.sourceforge.net

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
#import "MGSFragariaPrivate.h"
#import "MGSFragariaFramework.h"


// syntax colouring information dictionary keys
NSString *SMLSyntaxGroup = @"group";
NSString *SMLSyntaxGroupID = @"groupID";
NSString *SMLSyntaxWillColour = @"willColour";
NSString *SMLSyntaxAttributes = @"attributes";
NSString *SMLSyntaxInfo = @"syntaxInfo";

// syntax colouring group names
NSString *SMLSyntaxGroupNumber = @"number";
NSString *SMLSyntaxGroupCommand = @"command";
NSString *SMLSyntaxGroupInstruction = @"instruction";
NSString *SMLSyntaxGroupKeyword = @"keyword";
NSString *SMLSyntaxGroupAutoComplete = @"autocomplete";
NSString *SMLSyntaxGroupVariable = @"variable";
NSString *SMLSyntaxGroupFirstString = @"firstString";
NSString *SMLSyntaxGroupSecondString = @"secondString";
NSString *SMLSyntaxGroupAttribute = @"attribute";
NSString *SMLSyntaxGroupSingleLineComment = @"singleLineComment";
NSString *SMLSyntaxGroupMultiLineComment = @"multiLineComment";
NSString *SMLSyntaxGroupSecondStringPass2 = @"secondStringPass2";


// class extension
@interface SMLSyntaxColouring()

- (void)applySyntaxDefinition;
- (NSString *)assignSyntaxDefinition;
- (void)autocompleteWordsTimerSelector:(NSTimer *)theTimer;
- (NSString *)completeString;
- (void)applyColourDefaults;
- (void)removeAllColours;
- (void)removeColoursFromRange:(NSRange)range;
- (void)setColour:(NSDictionary *)colour range:(NSRange)range;
- (BOOL)isSyntaxColouringRequired;
- (NSDictionary *)syntaxDictionary;

@end


@implementation SMLSyntaxColouring {

    SMLLayoutManager *layoutManager;

    NSInteger lastCursorLocation;

    NSDictionary *commandsColour, *commentsColour, *instructionsColour, *keywordsColour, *autocompleteWordsColour,
    *stringsColour, *variablesColour, *attributesColour,  *numbersColour;

    NSTimer *autocompleteWordsTimer;
}

@synthesize syntaxDefinitionName = _syntaxDefinitionName;

#pragma mark - Instance methods

/*
  - init
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
    // @todo: We're still using the docSpec indirectly, but at least we're not longer dependent
    //        upon it for initialization. As some of these properties are internally exposed,
    //        we can start to eliminate getting them from the docSpec.

    if ((self = [super init])) {

        _fragaria = fragaria;

        // configure the document text view
        NSTextView *textView = self.fragaria.textView;
        NSAssert([textView isKindOfClass:[NSTextView class]], @"bad textview");
        self.undoManager = [textView undoManager];

        NSScrollView *scrollView = self.fragaria.scrollView;
        [[scrollView contentView] setPostsBoundsChangedNotifications:YES];

        // configure ivars
        lastCursorLocation = 0;

        // configure layout managers
        layoutManager = (SMLLayoutManager *)[textView layoutManager];

        // configure colouring
        [self applyColourDefaults];

        // configure syntax definition
        [self applySyntaxDefinition];

        // add text view notification observers
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:NSTextDidChangeNotification object:textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recolourExposedRange) name:NSViewBoundsDidChangeNotification object:[scrollView contentView]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recolourExposedRange) name:NSViewFrameDidChangeNotification object:textView];

        // add NSUserDefaultsController KVO observers
        NSUserDefaultsController *defaultsController = [NSUserDefaultsController sharedUserDefaultsController];

        [defaultsController addObserver:self forKeyPath:@"values.FragariaCommandsColourWell" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaCommentsColourWell" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaInstructionsColourWell" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaKeywordsColourWell" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaAutocompleteColourWell" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaVariablesColourWell" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaStringsColourWell" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaAttributesColourWell" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaNumbersColourWell" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];

        [defaultsController addObserver:self forKeyPath:@"values.FragariaColourCommands" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaColourComments" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaColourInstructions" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaColourKeywords" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaColourAutocomplete" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaColourVariables" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaColourStrings" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaColourAttributes" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaColourNumbers" options:NSKeyValueObservingOptionNew context:@"ColoursChanged"];

        [defaultsController addObserver:self forKeyPath:@"values.FragariaColourMultiLineStrings" options:NSKeyValueObservingOptionNew context:@"MultiLineChanged"];
        [defaultsController addObserver:self forKeyPath:@"values.FragariaOnlyColourTillTheEndOfLine" options:NSKeyValueObservingOptionNew context:@"MultiLineChanged"];
        
        [defaultsController addObserver:self forKeyPath:@"values.FragariaLineWrapNewDocuments" options:NSKeyValueObservingOptionNew context:@"LineWrapChanged"];
        
        [self setSyntaxColoured:[[NSUserDefaults standardUserDefaults] boolForKey:MGSFragariaPrefsSyntaxColourNewDocuments]];
    }
    
    return self;
}


/*
 * - setSyntaxColoured:
 */
- (void)setSyntaxColoured:(BOOL)syntaxColoured
{
    if (!_syntaxColoured && syntaxColoured) {
        _syntaxColoured = YES;
        [self recolourExposedRange];
    } else if (_syntaxColoured && !syntaxColoured) {
        _syntaxColoured = NO;
        [self removeAllColours];
    }
}


#pragma mark - KVO

/*
 * - observeValueForKeyPath:ofObject:change:context:
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([(__bridge NSString *)context isEqualToString:@"ColoursChanged"]) {
		[self applyColourDefaults];
		[self recolourExposedRange];
	} else if ([(__bridge NSString *)context isEqualToString:@"MultiLineChanged"]) {
        [self invalidateAllColouring];
	} else if ([(__bridge NSString*)context isEqualToString:@"LineWrapChanged"]) {
        [self recolourExposedRange];
    } else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}


/*
 * - dealloc
 */
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}


#pragma mark - Syntax definition handling

/*
 * - applySyntaxDefinition
 */
- (void)applySyntaxDefinition
{			
	// parse
    self.syntaxDefinition = [[MGSSyntaxDefinition alloc] initFromSyntaxDictionary:self.syntaxDictionary];
    [self removeAllColours];
}


/*
 * - syntaxDictionary
 */
- (NSDictionary *)syntaxDictionary
{
	// if document has no syntax definition name then assign one
    if (!self.syntaxDefinitionName || [self.syntaxDefinitionName length] == 0)
    {
        self.syntaxDefinitionName = [self assignSyntaxDefinition];
    }

	// get syntax dictionary
	NSDictionary *syntaxDictionary = [[MGSSyntaxController sharedInstance] syntaxDictionaryWithName:self.syntaxDefinitionName];
    
    return syntaxDictionary;
}


/*
 * - assignSyntaxDefinition
 */
- (NSString *)assignSyntaxDefinition
{
	if (self.syntaxDefinitionName && [self.syntaxDefinitionName length] > 0) return self.syntaxDefinitionName;

	NSString *documentExtension = self.fragaria.documentName.pathExtension;
	
    NSString *lowercaseExtension = nil;
    
    // If there is no extension try to guess definition from first line
    if ([documentExtension isEqualToString:@""]) { 
        
        NSString *string = [self.fragaria.scrollView.documentView string];
        NSString *firstLine = [string substringWithRange:[string lineRangeForRange:NSMakeRange(0,0)]];
        if ([firstLine hasPrefix:@"#!"] || [firstLine hasPrefix:@"%"] || [firstLine hasPrefix:@"<?"]) {
            lowercaseExtension = [[MGSSyntaxController sharedInstance] guessSyntaxDefinitionExtensionFromFirstLine:firstLine];
        } 
    } else {
        lowercaseExtension = [documentExtension lowercaseString];
    }
    
    if (lowercaseExtension) {
        self.syntaxDefinitionName = [[MGSSyntaxController sharedInstance] syntaxDefinitionNameWithExtension:lowercaseExtension];
    }
	
	if (!self.syntaxDefinitionName || [self.syntaxDefinitionName length] == 0) {
		self.syntaxDefinitionName = [MGSSyntaxController standardSyntaxDefinitionName];
	}
	
	return self.syntaxDefinitionName;
}


#pragma mark - Accessors

/*
 * - completeString
 */
- (NSString *)completeString
{
	return self.fragaria.textView.string;
}


/*
 *  @property syntaxDefinitionName
 */
- (void)setSyntaxDefinitionName:(NSString *)syntaxDefinitionName
{
    _syntaxDefinitionName = syntaxDefinitionName;
    [self applySyntaxDefinition];
    [self invalidateAllColouring];
}

- (NSString *)syntaxDefinitionName
{
    return _syntaxDefinitionName;
}


#pragma mark - Colouring

/*
 * - removeAllColours
 */
- (void)removeAllColours
{
	NSRange wholeRange = NSMakeRange(0, [[self completeString] length]);
	[layoutManager removeTemporaryAttribute:NSForegroundColorAttributeName forCharacterRange:wholeRange];
    [[self.fragaria.textView inspectedCharacterIndexes] removeAllIndexes];
}


/*
 * - removeColoursFromRange
 */
- (void)removeColoursFromRange:(NSRange)range
{
	[layoutManager removeTemporaryAttribute:NSForegroundColorAttributeName forCharacterRange:range];
    [[self.fragaria.textView inspectedCharacterIndexes] removeIndexesInRange:range];
}


/*
 * - invalidateAllColouring
 */
- (void)invalidateAllColouring
{
    [self removeAllColours];
    [self recolourExposedRange];
}


/*
 * - invalidateVisibleRange
 */
- (void)invalidateVisibleRange
{
    NSMutableIndexSet *validRanges;
    SMLTextView *textView = self.fragaria.textView;

    validRanges = [textView inspectedCharacterIndexes];
    NSRect visibleRect = [[[textView enclosingScrollView] contentView] documentVisibleRect];
    NSRange visibleRange = [[textView layoutManager] glyphRangeForBoundingRect:visibleRect inTextContainer:[textView textContainer]];
    [validRanges removeIndexesInRange:visibleRange];
    [self recolourExposedRange];
}


/*
 * - recolourExposedRange
 */
- (void)recolourExposedRange
{
    NSMutableIndexSet __block *validRanges;
    NSMutableIndexSet *invalidRanges;
    
	if (!self.isSyntaxColouringRequired) {
		return;
	}
    validRanges = [self.fragaria.textView inspectedCharacterIndexes];
    
    NSRect visibleRect = [[[self.fragaria.textView enclosingScrollView] contentView] documentVisibleRect];
    NSRange visibleRange = [[self.fragaria.textView layoutManager] glyphRangeForBoundingRect:visibleRect inTextContainer:[self.fragaria.textView textContainer]];

    invalidRanges = [NSMutableIndexSet indexSetWithIndexesInRange:visibleRange];
    [invalidRanges removeIndexes:validRanges];
    [invalidRanges enumerateRangesUsingBlock:^(NSRange range, BOOL *stop){
        if (![validRanges containsIndexesInRange:range]) {
            NSRange nowValid = [self recolourChangedRange:range];
            [validRanges addIndexesInRange:nowValid];
        }
    }];
}


/*
 * - pageRecolourTextView:options:
 */
- (void)pageRecolourTextView:(SMLTextView *)textView options:(NSDictionary *)options
{
	if (!textView) {
		return;
	}

	if (!self.isSyntaxColouringRequired) {
		return;
	}
	
	// colourAll option
	NSNumber *colourAll = [options objectForKey:@"colourAll"];
	if (!colourAll || ![colourAll boolValue]) {
        [self recolourExposedRange];
    } else {
        [self removeAllColours];
        [self recolourExposedRange];
    }
}


/*
 * - recolourRange:
 */
- (NSRange)recolourChangedRange:(NSRange)rangeToRecolour
{
    // establish behavior
	BOOL shouldColourMultiLineStrings = [[SMLDefaults valueForKey:MGSFragariaPrefsColourMultiLineStrings] boolValue];
    	
    // setup
    NSString *documentString = [self completeString];
	NSRange effectiveRange = [documentString lineRangeForRange:rangeToRecolour];

    // trace
    //NSLog(@"rangeToRecolor location %i length %i", rangeToRecolour.location, rangeToRecolour.length);

    // adjust effective range
    //
    // When multiline strings are coloured we need to scan backwards to
    // find where the string might have started if it's "above" the top of the screen,
    // or we need to scan forwards to find where a multiline string which wraps off
    // the range ends.
    //
    // This is not always correct but it's better than nothing.
    //
	if (shouldColourMultiLineStrings) {
		NSInteger beginFirstStringInMultiLine = [documentString rangeOfString:self.syntaxDefinition.firstString options:NSBackwardsSearch range:NSMakeRange(0, effectiveRange.location)].location;
        if (beginFirstStringInMultiLine != NSNotFound) {
            NSDictionary *ta = [layoutManager temporaryAttributesAtCharacterIndex:beginFirstStringInMultiLine effectiveRange:NULL];
            if ([[ta objectForKey:NSForegroundColorAttributeName] isEqual:[stringsColour objectForKey:NSForegroundColorAttributeName]]) {
                NSInteger startOfLine = [documentString lineRangeForRange:NSMakeRange(beginFirstStringInMultiLine, 0)].location;
                effectiveRange = NSMakeRange(startOfLine, rangeToRecolour.length + (rangeToRecolour.location - startOfLine));
            }
        }
        
        
        NSInteger lastStringBegin = [documentString rangeOfString:self.syntaxDefinition.firstString options:NSBackwardsSearch range:rangeToRecolour].location;
        if (lastStringBegin != NSNotFound) {
            NSRange restOfString = NSMakeRange(NSMaxRange(rangeToRecolour), 0);
            restOfString.length = [documentString length] - restOfString.location;
            NSInteger lastStringEnd = [documentString rangeOfString:self.syntaxDefinition.firstString options:0 range:restOfString].location;
            if (lastStringEnd != NSNotFound) {
                NSInteger endOfLine = NSMaxRange([documentString lineRangeForRange:NSMakeRange(lastStringEnd, 0)]);
                effectiveRange = NSUnionRange(effectiveRange, NSMakeRange(lastStringBegin, endOfLine-lastStringBegin));
            }
        }
	}
    
    // assign range string
	NSString *rangeString = [documentString substringWithRange:effectiveRange];
	NSUInteger rangeStringLength = [rangeString length];
	if (rangeStringLength == 0) {
		return effectiveRange;
	}
    
    // allocate the range scanner
	NSScanner *rangeScanner = [[NSScanner alloc] initWithString:rangeString];
	[rangeScanner setCharactersToBeSkipped:nil];
    
    // allocate the document scanner
	NSScanner *documentScanner = [[NSScanner alloc] initWithString:documentString];
	[documentScanner setCharactersToBeSkipped:nil];
	
    // uncolour the range
	[self removeColoursFromRange:effectiveRange];
	
    // colouring delegate
    NSDictionary *delegateInfo =  nil;
	
    // define a block that the colour delegate can use to effect colouring
    BOOL (^colourRangeBlock)(NSDictionary *, NSRange) = ^(NSDictionary *colourInfo, NSRange range) {
        [self setColour:colourInfo range:range];
        
        // at the moment we always succeed
        return YES;
    };
    
    @try {
		
        BOOL doColouring = YES;
        
        //
        // query delegate about colouring the document
        //
        if ([self.syntaxColouringDelegate respondsToSelector:@selector(fragariaDocument:shouldColourWithBlock:string:range:info:)]) {
            
            // build minimal delegate info dictionary
            delegateInfo = @{SMLSyntaxInfo : self.syntaxDictionary, SMLSyntaxWillColour : @(self.isSyntaxColouringRequired)};
            
            // query delegate about colouring
            doColouring = [self.syntaxColouringDelegate fragariaDocument:self.fragaria shouldColourWithBlock:colourRangeBlock string:documentString range:rangeToRecolour info:delegateInfo ];
            
        }
        
        if (doColouring) {
            
            for (NSInteger i = 0; i < kSMLCountOfSyntaxGroups; i++) {
                /* Colour all syntax groups */
                [self colourGroupWithIdentifier:i inRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner queryingDelegate:self.syntaxColouringDelegate colouringBlock:colourRangeBlock];
            }

            //
            // tell delegate we are did colour the document
            //
            if ([self.syntaxColouringDelegate respondsToSelector:@selector(fragariaDocument:didColourWithBlock:string:range:info:)]) {
                
                // build minimal delegate info dictionary
                delegateInfo = @{@"syntaxInfo" : self.syntaxDictionary};
                
                [self.syntaxColouringDelegate fragariaDocument:self.fragaria didColourWithBlock:colourRangeBlock string:documentString range:rangeToRecolour info:delegateInfo ];
            }

        }

    }
	@catch (NSException *exception) {
		NSLog(@"Syntax colouring exception: %@", exception);
	}

    @try {
        //
        // highlight errors
        //
        [self highlightErrors];
	}
	@catch (NSException *exception) {
		NSLog(@"Error highlighting exception: %@", exception);
	}
    return effectiveRange;
}


- (void)colourGroupWithIdentifier:(NSInteger)group inRange:(NSRange)effectiveRange withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner queryingDelegate:(id)colouringDelegate colouringBlock:(BOOL(^)(NSDictionary *, NSRange))colourRangeBlock
{
    NSString *prefKey;
    NSString *groupName;
    BOOL doColouring = YES;
    NSDictionary *delegateInfo;
    NSString *documentString = [documentScanner string];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *attributes;
    
    switch (group) {
        case kSMLSyntaxGroupNumber:
            groupName = SMLSyntaxGroupNumber;
            prefKey = MGSFragariaPrefsColourNumbers;
            attributes = numbersColour;
            break;
        case kSMLSyntaxGroupCommand:
            groupName = SMLSyntaxGroupCommand;
            prefKey = MGSFragariaPrefsColourCommands;
            doColouring = ![self.syntaxDefinition.beginCommand isEqual:@""];
            attributes = commandsColour;
            break;
        case kSMLSyntaxGroupInstruction:
            groupName = SMLSyntaxGroupInstruction;
            prefKey = MGSFragariaPrefsColourInstructions;
            doColouring = ![self.syntaxDefinition.beginInstruction isEqual:@""];
            attributes = instructionsColour;
            break;
        case kSMLSyntaxGroupKeyword:
            groupName = SMLSyntaxGroupKeyword;
            prefKey = MGSFragariaPrefsColourKeywords;
            doColouring = [self.syntaxDefinition.keywords count] > 0;
            attributes = keywordsColour;
            break;
        case kSMLSyntaxGroupAutoComplete:
            groupName = SMLSyntaxGroupAutoComplete;
            prefKey = MGSFragariaPrefsColourAutocomplete;
            doColouring = [self.syntaxDefinition.autocompleteWords count] > 0;
            attributes = autocompleteWordsColour;
            break;
        case kSMLSyntaxGroupVariable:
            groupName = SMLSyntaxGroupVariable;
            prefKey = MGSFragariaPrefsColourVariables;
            doColouring = (self.syntaxDefinition.beginVariableCharacterSet != nil);
            attributes = variablesColour;
            break;
        case kSMLSyntaxGroupSecondString:
            groupName = SMLSyntaxGroupSecondString;
            prefKey = MGSFragariaPrefsColourStrings;
            doColouring = ![self.syntaxDefinition.secondString isEqual:@""];
            attributes = stringsColour;
            break;
        case kSMLSyntaxGroupFirstString:
            groupName = SMLSyntaxGroupFirstString;
            prefKey = MGSFragariaPrefsColourStrings;
            doColouring = ![self.syntaxDefinition.firstString isEqual:@""];
            attributes = stringsColour;
            break;
        case kSMLSyntaxGroupAttribute:
            groupName = SMLSyntaxGroupAttribute;
            prefKey = MGSFragariaPrefsColourAttributes;
            attributes = attributesColour;
            break;
        case kSMLSyntaxGroupSingleLineComment:
            groupName = SMLSyntaxGroupSingleLineComment;
            prefKey = MGSFragariaPrefsColourComments;
            attributes = commentsColour;
            break;
        case kSMLSyntaxGroupMultiLineComment:
            groupName = SMLSyntaxGroupMultiLineComment;
            prefKey = MGSFragariaPrefsColourComments;
            attributes = commentsColour;
            break;
        case kSMLSyntaxGroupSecondStringPass2:
            groupName = SMLSyntaxGroupSecondStringPass2;
            prefKey = MGSFragariaPrefsColourStrings;
            doColouring = ![self.syntaxDefinition.secondString isEqual:@""];
            attributes = stringsColour;
    }
    
    doColouring = doColouring && [ud boolForKey:prefKey];
    
    if ([colouringDelegate respondsToSelector:@selector(fragariaDocument:shouldColourGroupWithBlock:string:range:info:)]) {
        // build delegate info dictionary
        delegateInfo = @{SMLSyntaxGroup : groupName, SMLSyntaxGroupID : @(group), SMLSyntaxWillColour : @(doColouring), SMLSyntaxAttributes : attributes, SMLSyntaxInfo : self.syntaxDictionary};
        
        // call the delegate
        doColouring = [colouringDelegate fragariaDocument:self.fragaria shouldColourGroupWithBlock:colourRangeBlock string:documentString range:effectiveRange info:delegateInfo];
    }
    
    if (!doColouring) return;
        
    // reset scanner
    [rangeScanner mgs_setScanLocation:0];
    [documentScanner mgs_setScanLocation:0];
    
    switch (group) {
        case kSMLSyntaxGroupNumber:
            [self colourNumbersInRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
            break;
        case kSMLSyntaxGroupCommand:
            [self colourCommandsInRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
            break;
        case kSMLSyntaxGroupInstruction:
            [self colourInstructionsInRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
            break;
        case kSMLSyntaxGroupKeyword:
            [self colourKeywordsInRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
            break;
        case kSMLSyntaxGroupAutoComplete:
            [self colourAutocompleteInRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
            break;
        case kSMLSyntaxGroupVariable:
            [self colourVariablesInRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
            break;
        case kSMLSyntaxGroupSecondString:
            [self colourSecondStrings1InRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
            break;
        case kSMLSyntaxGroupFirstString:
            [self colourFirstStringsInRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
            break;
        case kSMLSyntaxGroupAttribute:
            [self colourAttributesInRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
            break;
        case kSMLSyntaxGroupSingleLineComment:
            [self colourSingleLineCommentsInRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
            break;
        case kSMLSyntaxGroupMultiLineComment:
            [self colourMultiLineCommentsInRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
            break;
        case kSMLSyntaxGroupSecondStringPass2:
            [self colourSecondStrings2InRange:effectiveRange withRangeScanner:rangeScanner documentScanner:documentScanner];
    }
    
    // inform delegate that colouring is done
    if ([colouringDelegate respondsToSelector:@selector(fragariaDocument:didColourGroupWithBlock:string:range:info:)]) {
        [colouringDelegate fragariaDocument:self.fragaria didColourGroupWithBlock:colourRangeBlock string:documentString range:effectiveRange info:delegateInfo];
    }
}


- (void)colourNumbersInRange:(NSRange)colouringRange withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    NSInteger colourStartLocation, colourEndLocation, queryLocation;
    NSInteger rangeLocation = colouringRange.location;
    unichar testCharacter;
    NSString *documentString = [documentScanner string];
    NSString *rangeString = [rangeScanner string];
    
    // scan range to end
    while (![rangeScanner isAtEnd]) {
        
        // scan up to a number character
        [rangeScanner scanUpToCharactersFromSet:self.syntaxDefinition.numberCharacterSet intoString:NULL];
        colourStartLocation = [rangeScanner scanLocation];
        
        // scan to number end
        [rangeScanner scanCharactersFromSet:self.syntaxDefinition.numberCharacterSet intoString:NULL];
        colourEndLocation = [rangeScanner scanLocation];
        
        if (colourStartLocation == colourEndLocation) {
            break;
        }
        
        // don't colour if preceding character is a letter.
        // this prevents us from colouring numbers in variable names,
        queryLocation = colourStartLocation + rangeLocation;
        if (queryLocation > 0) {
            testCharacter = [documentString characterAtIndex:queryLocation - 1];
            
            // numbers can occur in variable, class and function names
            // eg: var_1 should not be coloured as a number
            if ([self.syntaxDefinition.nameCharacterSet characterIsMember:testCharacter]) {
                continue;
            }
        }
        
        // @todo: handle constructs such as 1..5 which may occur within some loop constructs
        
        // don't colour a trailing decimal point as some languages may use it as a line terminator
        if (colourEndLocation > 0) {
            queryLocation = colourEndLocation - 1;
            testCharacter = [rangeString characterAtIndex:queryLocation];
            if (testCharacter == self.syntaxDefinition.decimalPointCharacter) {
                colourEndLocation--;
            }
        }
        
        [self setColour:numbersColour range:NSMakeRange(colourStartLocation + rangeLocation, colourEndLocation - colourStartLocation)];
    }
}


- (void)colourCommandsInRange:(NSRange)colouringRange withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    NSInteger colourStartLocation;
    NSInteger rangeLocation = colouringRange.location;
    NSUInteger endOfLine;
    NSInteger searchSyntaxLength = [self.syntaxDefinition.endCommand length];
    unichar beginCommandCharacter = [self.syntaxDefinition.beginCommand characterAtIndex:0];
    unichar endCommandCharacter = [self.syntaxDefinition.endCommand characterAtIndex:0];
    NSString *rangeString = [rangeScanner string];
    
    // reset scanner
    [rangeScanner mgs_setScanLocation:0];
    
    // scan range to end
    while (![rangeScanner isAtEnd]) {
        [rangeScanner scanUpToString:self.syntaxDefinition.beginCommand intoString:nil];
        colourStartLocation = [rangeScanner scanLocation];
        endOfLine = NSMaxRange([rangeString lineRangeForRange:NSMakeRange(colourStartLocation, 0)]);
        if (![rangeScanner scanUpToString:self.syntaxDefinition.endCommand intoString:nil] || [rangeScanner scanLocation] >= endOfLine) {
            [rangeScanner mgs_setScanLocation:endOfLine];
            continue; // Don't colour it if it hasn't got a closing tag
        } else {
            // To avoid problems with strings like <yada <%=yada%> yada> we need to balance the number of begin- and end-tags
            // If ever there's a beginCommand or endCommand with more than one character then do a check first
            NSUInteger commandLocation = colourStartLocation + 1;
            NSUInteger skipEndCommand = 0;
            
            while (commandLocation < endOfLine) {
                unichar commandCharacterTest = [rangeString characterAtIndex:commandLocation];
                if (commandCharacterTest == endCommandCharacter) {
                    if (!skipEndCommand) {
                        break;
                    } else {
                        skipEndCommand--;
                    }
                }
                if (commandCharacterTest == beginCommandCharacter) {
                    skipEndCommand++;
                }
                commandLocation++;
            }
            if (commandLocation < endOfLine) {
                [rangeScanner mgs_setScanLocation:commandLocation + searchSyntaxLength];
            } else {
                [rangeScanner mgs_setScanLocation:endOfLine];
            }
        }
        
        [self setColour:commandsColour range:NSMakeRange(colourStartLocation + rangeLocation, [rangeScanner scanLocation] - colourStartLocation)];
    }
}


- (void)colourInstructionsInRange:(NSRange)rangeToRecolour withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    NSInteger colourStartLocation, beginLocationInMultiLine, endLocationInMultiLine;
    NSInteger rangeLocation = rangeToRecolour.location;
    NSRange searchRange;
    NSString *documentString = [documentScanner string];
    NSUInteger documentStringLength = [documentString length];
    NSUInteger maxRangeLocation = NSMaxRange(rangeToRecolour);
    
    BOOL shouldOnlyColourTillTheEndOfLine = [[SMLDefaults valueForKey:MGSFragariaPrefsOnlyColourTillTheEndOfLine] boolValue];
    
    // It takes too long to scan the whole document if it's large, so for instructions, first multi-line comment and second multi-line comment search backwards and begin at the start of the first beginInstruction etc. that it finds from the present position and, below, break the loop if it has passed the scanned range (i.e. after the end instruction)
    
    beginLocationInMultiLine = [documentString rangeOfString:self.syntaxDefinition.beginInstruction options:NSBackwardsSearch range:NSMakeRange(0, rangeLocation)].location;
    endLocationInMultiLine = [documentString rangeOfString:self.syntaxDefinition.endInstruction options:NSBackwardsSearch range:NSMakeRange(0, rangeLocation)].location;
    if (beginLocationInMultiLine == NSNotFound || (endLocationInMultiLine != NSNotFound && beginLocationInMultiLine < endLocationInMultiLine)) {
        beginLocationInMultiLine = rangeLocation;
    }
    
    NSInteger searchSyntaxLength = [self.syntaxDefinition.endInstruction length];
    
    // scan document to end
    while (![documentScanner isAtEnd]) {
        searchRange = NSMakeRange(beginLocationInMultiLine, rangeToRecolour.length);
        if (NSMaxRange(searchRange) > documentStringLength) {
            searchRange = NSMakeRange(beginLocationInMultiLine, documentStringLength - beginLocationInMultiLine);
        }
        
        colourStartLocation = [documentString rangeOfString:self.syntaxDefinition.beginInstruction options:NSLiteralSearch range:searchRange].location;
        if (colourStartLocation == NSNotFound) {
            break;
        }
        [documentScanner mgs_setScanLocation:colourStartLocation];
        if (![documentScanner scanUpToString:self.syntaxDefinition.endInstruction intoString:nil] || [documentScanner scanLocation] >= documentStringLength) {
            if (shouldOnlyColourTillTheEndOfLine) {
                [documentScanner mgs_setScanLocation:NSMaxRange([documentString lineRangeForRange:NSMakeRange(colourStartLocation, 0)])];
            } else {
                [documentScanner mgs_setScanLocation:documentStringLength];
            }
        } else {
            if ([documentScanner scanLocation] + searchSyntaxLength <= documentStringLength) {
                [documentScanner mgs_setScanLocation:[documentScanner scanLocation] + searchSyntaxLength];
            }
        }
        
        [self setColour:instructionsColour range:NSMakeRange(colourStartLocation, [documentScanner scanLocation] - colourStartLocation)];
        if ([documentScanner scanLocation] > maxRangeLocation) {
            break;
        }
        beginLocationInMultiLine = [documentScanner scanLocation];
    }
}


- (void)colourKeywordsInRange:(NSRange)rangeToRecolour withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    [self colourKeywordsFromSet:self.syntaxDefinition.keywords withAttributes:keywordsColour inRange:rangeToRecolour withRangeScanner:rangeScanner documentScanner:documentScanner];
}


- (void)colourAutocompleteInRange:(NSRange)rangeToRecolour withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    [self colourKeywordsFromSet:self.syntaxDefinition.autocompleteWords withAttributes:autocompleteWordsColour inRange:rangeToRecolour withRangeScanner:rangeScanner documentScanner:documentScanner];
}


- (void)colourKeywordsFromSet:(NSSet*)keywords withAttributes:(NSDictionary*)attributes inRange:(NSRange)rangeToRecolour withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    NSUInteger colourStartLocation, colourEndLocation;
    NSInteger rangeLocation = rangeToRecolour.location;
    NSString *documentString = [documentScanner string];
    NSString *rangeString = [rangeScanner string];
    NSUInteger rangeStringLength = [rangeString length];
    
    // scan range to end
    while (![rangeScanner isAtEnd]) {
        [rangeScanner scanUpToCharactersFromSet:self.syntaxDefinition.keywordStartCharacterSet intoString:nil];
        colourStartLocation = [rangeScanner scanLocation];
        if ((colourStartLocation + 1) < rangeStringLength) {
            [rangeScanner mgs_setScanLocation:(colourStartLocation + 1)];
        }
        [rangeScanner scanUpToCharactersFromSet:self.syntaxDefinition.keywordEndCharacterSet intoString:nil];
        
        colourEndLocation = [rangeScanner scanLocation];
        if (colourEndLocation > rangeStringLength || colourStartLocation == colourEndLocation) {
            break;
        }
        
        NSString *keywordTestString = nil;
        if (!self.syntaxDefinition.keywordsCaseSensitive) {
            keywordTestString = [[documentString substringWithRange:NSMakeRange(colourStartLocation + rangeLocation, colourEndLocation - colourStartLocation)] lowercaseString];
        } else {
            keywordTestString = [documentString substringWithRange:NSMakeRange(colourStartLocation + rangeLocation, colourEndLocation - colourStartLocation)];
        }
        if ([keywords containsObject:keywordTestString]) {
            if (!self.syntaxDefinition.recolourKeywordIfAlreadyColoured) {
                if ([[layoutManager temporaryAttributesAtCharacterIndex:colourStartLocation + rangeLocation effectiveRange:NULL] isEqualToDictionary:commandsColour]) {
                    continue;
                }
            }
            [self setColour:attributes range:NSMakeRange(colourStartLocation + rangeLocation, [rangeScanner scanLocation] - colourStartLocation)];
        }
    }
}


- (void)colourVariablesInRange:(NSRange)rangeToRecolour withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    NSUInteger colourStartLocation;
    NSInteger rangeLocation = rangeToRecolour.location;
    NSUInteger endOfLine, colourLength;
    NSString *rangeString = [rangeScanner string];
    NSUInteger rangeStringLength = [rangeString length];
    
    // scan range to end
    while (![rangeScanner isAtEnd]) {
        [rangeScanner scanUpToCharactersFromSet:self.syntaxDefinition.beginVariableCharacterSet intoString:nil];
        colourStartLocation = [rangeScanner scanLocation];
        if (colourStartLocation + 1 < rangeStringLength) {
            if ([self.syntaxDefinition.firstSingleLineComment isEqualToString:@"%"] && [rangeString characterAtIndex:colourStartLocation + 1] == '%') { // To avoid a problem in LaTex with \%
                if ([rangeScanner scanLocation] < rangeStringLength) {
                    [rangeScanner mgs_setScanLocation:colourStartLocation + 1];
                }
                continue;
            }
        }
        endOfLine = NSMaxRange([rangeString lineRangeForRange:NSMakeRange(colourStartLocation, 0)]);
        if (![rangeScanner scanUpToCharactersFromSet:self.syntaxDefinition.endVariableCharacterSet intoString:nil] || [rangeScanner scanLocation] >= endOfLine) {
            [rangeScanner mgs_setScanLocation:endOfLine];
            colourLength = [rangeScanner scanLocation] - colourStartLocation;
        } else {
            colourLength = [rangeScanner scanLocation] - colourStartLocation;
            if ([rangeScanner scanLocation] < rangeStringLength) {
                [rangeScanner mgs_setScanLocation:[rangeScanner scanLocation] + 1];
            }
        }
        
        [self setColour:variablesColour range:NSMakeRange(colourStartLocation + rangeLocation, colourLength)];
    }
}


- (void)colourSecondStrings1InRange:(NSRange)rangeToRecolour withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    NSString *stringPattern;
    NSRegularExpression *regex;
    NSError *error;
    NSString *rangeString = [rangeScanner string];
    NSInteger rangeLocation = rangeToRecolour.location;
    
    BOOL shouldColourMultiLineStrings = [[SMLDefaults valueForKey:MGSFragariaPrefsColourMultiLineStrings] boolValue];
    
    if (!shouldColourMultiLineStrings)
        stringPattern = [self.syntaxDefinition secondStringPattern];
    else
        stringPattern = [self.syntaxDefinition secondMultilineStringPattern];
    
    regex = [NSRegularExpression regularExpressionWithPattern:stringPattern options:0 error:&error];
    if (error) return;
    
    [regex enumerateMatchesInString:rangeString options:0 range:NSMakeRange(0, [rangeString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        // While we should only receive one match with the original regex, let's
        // protect for the possibility that the regex changes in the future,
        // and handle all matches.
        for (NSUInteger i = 0; i < [match numberOfRanges]; i++) {
            NSRange foundRange = [match rangeAtIndex:i];
            [self setColour:stringsColour range:NSMakeRange(foundRange.location + rangeLocation + 1, foundRange.length - 1)];
        }
    }];
}


- (void)colourFirstStringsInRange:(NSRange)rangeToRecolour withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    NSString *stringPattern;
    NSRegularExpression *regex;
    NSError *error;
    NSString *rangeString = [rangeScanner string];
    NSInteger rangeLocation = rangeToRecolour.location;
    
    BOOL shouldColourMultiLineStrings = [[SMLDefaults valueForKey:MGSFragariaPrefsColourMultiLineStrings] boolValue];
    
    if (!shouldColourMultiLineStrings)
        stringPattern = [self.syntaxDefinition firstStringPattern];
    else
        stringPattern = [self.syntaxDefinition firstMultilineStringPattern];
    
    regex = [NSRegularExpression regularExpressionWithPattern:stringPattern options:0 error:&error];
    if (error) return;
    
    [regex enumerateMatchesInString:rangeString options:0 range:NSMakeRange(0, [rangeString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        for (NSUInteger i = 0; i < [match numberOfRanges]; i++) {
            NSRange foundRange = [match rangeAtIndex:i];
            if ([[layoutManager temporaryAttributesAtCharacterIndex:foundRange.location + rangeLocation effectiveRange:NULL] isEqualToDictionary:stringsColour]) continue;
            [self setColour:stringsColour range:NSMakeRange(foundRange.location + rangeLocation + 1, foundRange.length - 1)];
        }
    }];
}


- (void)colourAttributesInRange:(NSRange)rangeToRecolour withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    NSUInteger colourStartLocation, colourEndLocation;
    NSInteger rangeLocation = rangeToRecolour.location;
    NSString *documentString = [documentScanner string];
    NSString *rangeString = [rangeScanner string];
    NSUInteger rangeStringLength = [rangeString length];
    
    // scan range to end
    while (![rangeScanner isAtEnd]) {
        [rangeScanner scanUpToString:@" " intoString:nil];
        colourStartLocation = [rangeScanner scanLocation];
        if (colourStartLocation + 1 < rangeStringLength) {
            [rangeScanner mgs_setScanLocation:colourStartLocation + 1];
        } else {
            break;
        }
        if (![[layoutManager temporaryAttributesAtCharacterIndex:(colourStartLocation + rangeLocation) effectiveRange:NULL] isEqualToDictionary:commandsColour]) {
            continue;
        }
        
        [rangeScanner scanCharactersFromSet:self.syntaxDefinition.attributesCharacterSet intoString:nil];
        colourEndLocation = [rangeScanner scanLocation];
        
        if (colourEndLocation + 1 < rangeStringLength) {
            [rangeScanner mgs_setScanLocation:[rangeScanner scanLocation] + 1];
        }
        
        if ([documentString characterAtIndex:colourEndLocation + rangeLocation] == '=') {
            [self setColour:attributesColour range:NSMakeRange(colourStartLocation + rangeLocation, colourEndLocation - colourStartLocation)];
        }
    }
}


- (void)colourSingleLineCommentsInRange:(NSRange)rangeToRecolour withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    NSUInteger colourStartLocation, endOfLine;
    NSRange rangeOfLine;
    NSInteger rangeLocation = rangeToRecolour.location;
    NSString *documentString = [documentScanner string];
    NSString *rangeString = [rangeScanner string];
    NSUInteger rangeStringLength = [rangeString length];
    NSUInteger documentStringLength = [documentString length];
    NSUInteger searchSyntaxLength;
    
    for (NSString *singleLineComment in self.syntaxDefinition.singleLineComments) {
        if (![singleLineComment isEqualToString:@""]) {
            
            // reset scanner
            [rangeScanner mgs_setScanLocation:0];
            searchSyntaxLength = [singleLineComment length];
            
            // scan range to end
            while (![rangeScanner isAtEnd]) {
                
                // scan for comment
                [rangeScanner scanUpToString:singleLineComment intoString:nil];
                colourStartLocation = [rangeScanner scanLocation];
                
                // common case handling
                if ([singleLineComment isEqualToString:@"//"]) {
                    if (colourStartLocation > 0 && [rangeString characterAtIndex:colourStartLocation - 1] == ':') {
                        [rangeScanner mgs_setScanLocation:colourStartLocation + 1];
                        continue; // To avoid http:// ftp:// file:// etc.
                    }
                } else if ([singleLineComment isEqualToString:@"#"]) {
                    if (rangeStringLength > 1) {
                        rangeOfLine = [rangeString lineRangeForRange:NSMakeRange(colourStartLocation, 0)];
                        if ([rangeString rangeOfString:@"#!" options:NSLiteralSearch range:rangeOfLine].location != NSNotFound) {
                            [rangeScanner mgs_setScanLocation:NSMaxRange(rangeOfLine)];
                            continue; // Don't treat the line as a comment if it begins with #!
                        } else if (colourStartLocation > 0 && [rangeString characterAtIndex:colourStartLocation - 1] == '$') {
                            [rangeScanner mgs_setScanLocation:colourStartLocation + 1];
                            continue; // To avoid $#
                        } else if (colourStartLocation > 0 && [rangeString characterAtIndex:colourStartLocation - 1] == '&') {
                            [rangeScanner mgs_setScanLocation:colourStartLocation + 1];
                            continue; // To avoid &#
                        }
                    }
                } else if ([singleLineComment isEqualToString:@"%"]) {
                    if (rangeStringLength > 1) {
                        if (colourStartLocation > 0 && [rangeString characterAtIndex:colourStartLocation - 1] == '\\') {
                            [rangeScanner mgs_setScanLocation:colourStartLocation + 1];
                            continue; // To avoid \% in LaTex
                        }
                    }
                }
                
                // If the comment is within an already coloured string then disregard it
                if (colourStartLocation + rangeLocation + searchSyntaxLength < documentStringLength) {
                    if ([[layoutManager temporaryAttributesAtCharacterIndex:colourStartLocation + rangeLocation effectiveRange:NULL] isEqualToDictionary:stringsColour]) {
                        [rangeScanner mgs_setScanLocation:colourStartLocation + 1];
                        continue;
                    }
                }
                
                // this is a single line comment so we can scan to the end of the line
                endOfLine = NSMaxRange([rangeString lineRangeForRange:NSMakeRange(colourStartLocation, 0)]);
                [rangeScanner mgs_setScanLocation:endOfLine];
                
                // colour the comment
                [self setColour:commentsColour range:NSMakeRange(colourStartLocation + rangeLocation, [rangeScanner scanLocation] - colourStartLocation)];
            }
        }
    } // end for
}


- (void)colourMultiLineCommentsInRange:(NSRange)rangeToRecolour withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    NSUInteger colourStartLocation, beginLocationInMultiLine, endLocationInMultiLine, colourLength;
    NSRange searchRange;
    NSInteger rangeLocation = rangeToRecolour.location;
    NSString *documentString = [documentScanner string];
    NSUInteger documentStringLength = [documentString length];
    NSUInteger searchSyntaxLength;
    NSUInteger maxRangeLocation = NSMaxRange(rangeToRecolour);
    
    BOOL shouldOnlyColourTillTheEndOfLine = [[SMLDefaults valueForKey:MGSFragariaPrefsOnlyColourTillTheEndOfLine] boolValue];
    
    for (NSArray *multiLineComment in self.syntaxDefinition.multiLineComments) {
        
        // Get strings
        NSString *beginMultiLineComment = [multiLineComment objectAtIndex:0];
        NSString *endMultiLineComment = [multiLineComment objectAtIndex:1];
        
        if (![beginMultiLineComment isEqualToString:@""]) {
            
            // Default to start of document
            beginLocationInMultiLine = 0;
            
            // If start and end comment markers are the the same we
            // always start searching at the beginning of the document.
            // Otherwise we must consider that our start location may be mid way through
            // a multiline comment.
            if (![beginMultiLineComment isEqualToString:endMultiLineComment]) {
                
                // Search backwards from range location looking for comment start
                beginLocationInMultiLine = [documentString rangeOfString:beginMultiLineComment options:NSBackwardsSearch range:NSMakeRange(0, rangeLocation)].location;
                endLocationInMultiLine = [documentString rangeOfString:endMultiLineComment options:NSBackwardsSearch range:NSMakeRange(0, rangeLocation)].location;
                
                // If comments not found then begin at range location
                if (beginLocationInMultiLine == NSNotFound || (endLocationInMultiLine != NSNotFound && beginLocationInMultiLine < endLocationInMultiLine)) {
                    beginLocationInMultiLine = rangeLocation;
                }
            }
            
            [documentScanner mgs_setScanLocation:beginLocationInMultiLine];
            searchSyntaxLength = [endMultiLineComment length];
            
            // Iterate over the document until we exceed our work range
            while (![documentScanner isAtEnd]) {
                
                // Search up to document end
                searchRange = NSMakeRange(beginLocationInMultiLine, documentStringLength - beginLocationInMultiLine);
                
                // Look for comment start in document
                colourStartLocation = [documentString rangeOfString:beginMultiLineComment options:NSLiteralSearch range:searchRange].location;
                if (colourStartLocation == NSNotFound) {
                    break;
                }
                
                // Increment our location.
                // This is necessary to cover situations, such as F-Script, where the start and end comment strings are identical
                if (colourStartLocation + 1 < documentStringLength) {
                    [documentScanner mgs_setScanLocation:colourStartLocation + 1];
                    
                    // If the comment is within a string disregard it
                    if ([[layoutManager temporaryAttributesAtCharacterIndex:colourStartLocation effectiveRange:NULL] isEqualToDictionary:stringsColour]) {
                        beginLocationInMultiLine++;
                        continue;
                    }
                } else {
                    [documentScanner mgs_setScanLocation:colourStartLocation];
                }
                
                // Scan up to comment end
                if (![documentScanner scanUpToString:endMultiLineComment intoString:nil] || [documentScanner scanLocation] >= documentStringLength) {
                    
                    // Comment end not found
                    if (shouldOnlyColourTillTheEndOfLine) {
                        [documentScanner mgs_setScanLocation:NSMaxRange([documentString lineRangeForRange:NSMakeRange(colourStartLocation, 0)])];
                    } else {
                        [documentScanner mgs_setScanLocation:documentStringLength];
                    }
                    colourLength = [documentScanner scanLocation] - colourStartLocation;
                } else {
                    
                    // Comment end found
                    if ([documentScanner scanLocation] < documentStringLength) {
                        
                        // Safely advance scanner
                        [documentScanner mgs_setScanLocation:[documentScanner scanLocation] + searchSyntaxLength];
                    }
                    colourLength = [documentScanner scanLocation] - colourStartLocation;
                    
                    // HTML specific
                    if ([endMultiLineComment isEqualToString:@"-->"]) {
                        [documentScanner scanUpToCharactersFromSet:self.syntaxDefinition.letterCharacterSet intoString:nil]; // Search for the first letter after -->
                        if ([documentScanner scanLocation] + 6 < documentStringLength) {// Check if there's actually room for a </script>
                            if ([documentString rangeOfString:@"</script>" options:NSCaseInsensitiveSearch range:NSMakeRange([documentScanner scanLocation] - 2, 9)].location != NSNotFound || [documentString rangeOfString:@"</style>" options:NSCaseInsensitiveSearch range:NSMakeRange([documentScanner scanLocation] - 2, 8)].location != NSNotFound) {
                                beginLocationInMultiLine = [documentScanner scanLocation];
                                continue; // If the comment --> is followed by </script> or </style> it is probably not a real comment
                            }
                        }
                        [documentScanner mgs_setScanLocation:colourStartLocation + colourLength]; // Reset the scanner position
                    }
                }
                
                // Colour the range
                [self setColour:commentsColour range:NSMakeRange(colourStartLocation, colourLength)];
                
                // We may be done
                if ([documentScanner scanLocation] > maxRangeLocation) {
                    break;
                }
                
                // set start location for next search
                beginLocationInMultiLine = [documentScanner scanLocation];
            }
        }
    } // end for
}


- (void)colourSecondStrings2InRange:(NSRange)rangeToRecolour withRangeScanner:(NSScanner*)rangeScanner documentScanner:(NSScanner*)documentScanner
{
    NSString *stringPattern;
    NSRegularExpression *regex;
    NSError *error;
    NSString *rangeString = [rangeScanner string];
    NSInteger rangeLocation = rangeToRecolour.location;
    
    BOOL shouldColourMultiLineStrings = [[SMLDefaults valueForKey:MGSFragariaPrefsColourMultiLineStrings] boolValue];
    
    if (!shouldColourMultiLineStrings)
        stringPattern = [self.syntaxDefinition secondStringPattern];
    else
        stringPattern = [self.syntaxDefinition secondMultilineStringPattern];
    
    regex = [NSRegularExpression regularExpressionWithPattern:stringPattern options:0 error:&error];
    if (error) return;
    
    [regex enumerateMatchesInString:rangeString options:0 range:NSMakeRange(0, [rangeString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
        for (NSUInteger i = 0; i < [match numberOfRanges]; i++) {
            NSRange foundRange = [match rangeAtIndex:i];
            if ([[layoutManager temporaryAttributesAtCharacterIndex:foundRange.location + rangeLocation effectiveRange:NULL] isEqualToDictionary:stringsColour] || [[layoutManager temporaryAttributesAtCharacterIndex:foundRange.location + rangeLocation effectiveRange:NULL] isEqualToDictionary:commentsColour]) continue;
            [self setColour:stringsColour range:NSMakeRange(foundRange.location + rangeLocation + 1, foundRange.length - 1)];
        }
    }];
}


/*
 * - setColour:range:

 */
- (void)setColour:(NSDictionary *)colourDictionary range:(NSRange)range
{
	[layoutManager setTemporaryAttributes:colourDictionary forCharacterRange:range];
}


/*
 * - applyColourDefaults
 */
- (void)applyColourDefaults
{
	commandsColour = [[NSDictionary alloc] initWithObjectsAndKeys:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsCommandsColourWell]], NSForegroundColorAttributeName, nil];
	
	commentsColour = [[NSDictionary alloc] initWithObjectsAndKeys:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsCommentsColourWell]], NSForegroundColorAttributeName, nil];
	
	instructionsColour = [[NSDictionary alloc] initWithObjectsAndKeys:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsInstructionsColourWell]], NSForegroundColorAttributeName, nil];
	
	keywordsColour = [[NSDictionary alloc] initWithObjectsAndKeys:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsKeywordsColourWell]], NSForegroundColorAttributeName, nil];
	
	autocompleteWordsColour = [[NSDictionary alloc] initWithObjectsAndKeys:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsAutocompleteColourWell]], NSForegroundColorAttributeName, nil];
	
	stringsColour = [[NSDictionary alloc] initWithObjectsAndKeys:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsStringsColourWell]], NSForegroundColorAttributeName, nil];
	
	variablesColour = [[NSDictionary alloc] initWithObjectsAndKeys:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsVariablesColourWell]], NSForegroundColorAttributeName, nil];
	
	attributesColour = [[NSDictionary alloc] initWithObjectsAndKeys:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsAttributesColourWell]], NSForegroundColorAttributeName, nil];

	numbersColour = [[NSDictionary alloc] initWithObjectsAndKeys:[NSUnarchiver unarchiveObjectWithData:[SMLDefaults valueForKey:MGSFragariaPrefsNumbersColourWell]], NSForegroundColorAttributeName, nil];

    [self removeAllColours];
}


/*
 * - isSyntaxColouringRequired
 */
- (BOOL)isSyntaxColouringRequired
{
    return (self.isSyntaxColoured && self.syntaxDefinition.syntaxDefinitionAllowsColouring ? YES : NO);
}


/*
 * - characterIndexFromLine:character:inString:
 */
- (NSInteger) characterIndexFromLine:(int)line character:(int)character inString:(NSString*) str
{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
    
    int currentLine = 1;
    while (![scanner isAtEnd])
    {
        if (currentLine == line)
        {
            // Found the right line
            NSInteger location = [scanner scanLocation] + character-1;
            if (location >= (NSInteger)str.length) location = str.length - 1;
            return location;
        }
        
        // Scan to a new line
        [scanner scanUpToString:@"\n" intoString:NULL];
        
        if (![scanner isAtEnd])
        {
            scanner.scanLocation += 1;
        }
        currentLine++;
    }
    
    return -1;
}


/*
 * - highlightErrors
 */
- (void)highlightErrors
{
    SMLTextView* textView = self.fragaria.textView;
    NSString* text = [self completeString];
    
    // Clear all highlights
    [layoutManager removeTemporaryAttribute:NSBackgroundColorAttributeName forCharacterRange:NSMakeRange(0, text.length)];

    // Clear all buttons
    NSMutableArray* buttons = [NSMutableArray array];
    for (NSView* subview in [textView subviews])
    {
        if ([subview isKindOfClass:[NSButton class]])
        {
            [buttons addObject:subview];
        }
    }
    for (NSButton* button in buttons)
    {
        [button removeFromSuperview];
    }
    
    if (!self.fragaria.syntaxErrors) return;
    
    // Highlight all errors and add buttons
    NSMutableSet* highlightedRows = [NSMutableSet set];

    for (SMLSyntaxError* err in self.fragaria.syntaxErrors)
    {
        // Highlight an erroneous line
        NSInteger location = [self characterIndexFromLine:err.line character:err.character inString:text];
        
        // Skip lines we cannot identify in the text
        if (location == -1) continue;
        
        NSRange lineRange = [text lineRangeForRange:NSMakeRange(location, 0)];
     
        // Highlight row if it is not already highlighted
        if (![highlightedRows containsObject:[NSNumber numberWithInt:err.line]])
        {
            // Remember that we are highlighting this row
            [highlightedRows addObject:[NSNumber numberWithInt:err.line]];
            
            // Add highlight for background
            [layoutManager addTemporaryAttribute:NSBackgroundColorAttributeName value:err.errorLineHighlightColor forCharacterRange:lineRange];
            
            if ([err.description length] > 0)
                [layoutManager addTemporaryAttribute:NSToolTipAttributeName value:err.description forCharacterRange:lineRange];
        }
    }
}


#pragma mark - Text change observation

/*
 * - textDidChange:
 */
- (void)textDidChange:(NSNotification *)notification
{
	SMLTextView *textView = (SMLTextView *)[notification object];
	
    if ([self isSyntaxColouringRequired]) {
        /* We could call pageRecolour, but invalidating the entire page makes 
         * our bugs less visible */
		[self invalidateVisibleRange];
	}
	
	if (autocompleteWordsTimer != nil) {
		[autocompleteWordsTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:[[SMLDefaults valueForKey:MGSFragariaPrefsAutocompleteAfterDelay] floatValue]]];
	} else if ([[SMLDefaults valueForKey:MGSFragariaPrefsAutocompleteSuggestAutomatically] boolValue] == YES) {
		autocompleteWordsTimer = [NSTimer scheduledTimerWithTimeInterval:[[SMLDefaults valueForKey:MGSFragariaPrefsAutocompleteAfterDelay] floatValue] target:self selector:@selector(autocompleteWordsTimerSelector:) userInfo:textView repeats:NO];
	}
}


#pragma mark - NSTimer callbacks

/*
 * - autocompleteWordsTimerSelector:
 */
- (void)autocompleteWordsTimerSelector:(NSTimer *)theTimer
{
	SMLTextView *textView = [theTimer userInfo];
	NSRange selectedRange = [textView selectedRange];
	NSString *completeString = [self completeString];
	NSUInteger stringLength = [completeString length];
    
	if (selectedRange.location <= stringLength && selectedRange.length == 0 && stringLength != 0) {
		if (selectedRange.location == stringLength) { // If we're at the very end of the document
			[textView complete:nil];
		} else {
			unichar characterAfterSelection = [completeString characterAtIndex:selectedRange.location];
			if ([[NSCharacterSet symbolCharacterSet] characterIsMember:characterAfterSelection] || [[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:characterAfterSelection] || [[NSCharacterSet punctuationCharacterSet] characterIsMember:characterAfterSelection] || selectedRange.location == stringLength) { // Don't autocomplete if we're in the middle of a word
				[textView complete:nil];
			}
		}
	}
	
	if (autocompleteWordsTimer) {
		[autocompleteWordsTimer invalidate];
		autocompleteWordsTimer = nil;
	}
}


#pragma mark - SMLAutoCompleteDelegate

/*
 * - completions
 */
- (NSArray*) completions
{
    return self.syntaxDefinition.keywordsAndAutocompleteWords;
}


@end
