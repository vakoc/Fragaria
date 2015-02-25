//
//  SMLTextView+MGSTextActions.m
//  Fragaria
//
//  Created by Daniele Cattaneo on 09/02/15.
//
//

#import "SMLTextView+MGSTextActions.h"
#import "MGSFragariaFramework.h"
#import "MGSFragariaPrivate.h"


@implementation SMLTextView (MGSTextActions)


/*
 
 - validateMenuItem:
 
 */
- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem
{
    BOOL enableItem = YES;
    SEL action = [anItem action];
    
    // All items who should only be active if something is selected
    if (action == @selector(removeNeedlessWhitespace:) ||
        action == @selector(removeLineEndings:) ||
        action == @selector(entab:) ||
        action == @selector(detab:) ||
        action == @selector(capitalizeWord:) ||
        action == @selector(uppercaseCharacters:) ||
        action == @selector(lowercaseCharacters:)
        ) {
        if ([self selectedRange].length < 1) {
            enableItem = NO;
        }
    } else if (action == @selector(commentOrUncomment:) ) {
        // Comment Or Uncomment
        if ([[[[self.fragaria objectForKey:ro_MGSFOSyntaxColouring] syntaxDefinition] firstSingleLineComment] isEqualToString:@""]) {
            enableItem = NO;
        }
    } else {
        enableItem = [super validateUserInterfaceItem:anItem];
    }
    
    return enableItem;
}


#pragma mark -
#pragma mark Text shifting

/*
 
 - shiftLeftAction:
 
 */
- (IBAction)shiftLeft:(id)sender
{
    NSString *completeString = [self string];
    if ([completeString length] < 1) {
        return;
    }
    NSRange selectedRange;
    
    NSArray *array = [self selectedRanges];
    NSInteger sumOfAllCharactersRemoved = 0;
    NSInteger updatedLocation;
    NSMutableArray *updatedSelectionsArray = [NSMutableArray array];
    for (id item in array) {
        selectedRange = NSMakeRange([item rangeValue].location - sumOfAllCharactersRemoved, [item rangeValue].length);
        NSUInteger temporaryLocation = selectedRange.location;
        NSUInteger maxSelectedRange = NSMaxRange(selectedRange);
        NSInteger numberOfLines = 0;
        NSInteger locationOfFirstLine = [completeString lineRangeForRange:NSMakeRange(temporaryLocation, 0)].location;
        
        do {
            temporaryLocation = NSMaxRange([completeString lineRangeForRange:NSMakeRange(temporaryLocation, 0)]);
            numberOfLines++;
        } while (temporaryLocation < maxSelectedRange);
        
        temporaryLocation = selectedRange.location;
        NSInteger idx;
        NSInteger charactersRemoved = 0;
        NSInteger charactersRemovedInSelection = 0;
        NSRange rangeOfLine;
        unichar characterToTest;
        NSInteger numberOfSpacesPerTab = [[SMLDefaults valueForKey:MGSFragariaPrefsIndentWidth] integerValue];
        NSInteger numberOfSpacesToDeleteOnFirstLine = -1;
        for (idx = 0; idx < numberOfLines; idx++) {
            rangeOfLine = [completeString lineRangeForRange:NSMakeRange(temporaryLocation, 0)];
            if ([[SMLDefaults valueForKey:MGSFragariaPrefsUseTabStops] boolValue] == YES && [[SMLDefaults valueForKey:MGSFragariaPrefsIndentWithSpaces] boolValue] == YES) {
                NSUInteger startOfLine = rangeOfLine.location;
                while (startOfLine < NSMaxRange(rangeOfLine) && [completeString characterAtIndex:startOfLine] == ' ' && rangeOfLine.length > 0) {
                    startOfLine++;
                }
                NSInteger numberOfSpacesToDelete = numberOfSpacesPerTab;
                if (numberOfSpacesPerTab != 0) {
                    numberOfSpacesToDelete = (startOfLine - rangeOfLine.location) % numberOfSpacesPerTab;
                    if (numberOfSpacesToDelete == 0) {
                        numberOfSpacesToDelete = numberOfSpacesPerTab;
                    }
                }
                if (numberOfSpacesToDeleteOnFirstLine != -1) {
                    numberOfSpacesToDeleteOnFirstLine = numberOfSpacesToDelete;
                }
                while (numberOfSpacesToDelete--) {
                    characterToTest = [completeString characterAtIndex:rangeOfLine.location];
                    if (characterToTest == ' ' || characterToTest == '\t') {
                        if ([self shouldChangeTextInRange:NSMakeRange(rangeOfLine.location, 1) replacementString:@""]) { // Do it this way to mark it as an Undo
                            [self replaceCharactersInRange:NSMakeRange(rangeOfLine.location, 1) withString:@""];
                        }
                        charactersRemoved++;
                        if (rangeOfLine.location >= selectedRange.location && rangeOfLine.location < maxSelectedRange) {
                            charactersRemovedInSelection++;
                        }
                        if (characterToTest == '\t') {
                            break;
                        }
                    }
                }
            } else {
                characterToTest = [completeString characterAtIndex:rangeOfLine.location];
                if ((characterToTest == ' ' || characterToTest == '\t') && rangeOfLine.length > 0) {
                    if ([self shouldChangeTextInRange:NSMakeRange(rangeOfLine.location, 1) replacementString:@""]) { // Do it this way to mark it as an Undo
                        [self replaceCharactersInRange:NSMakeRange(rangeOfLine.location, 1) withString:@""];
                    }
                    charactersRemoved++;
                    if (rangeOfLine.location >= selectedRange.location && rangeOfLine.location < maxSelectedRange) {
                        charactersRemovedInSelection++;
                    }
                }
            }
            if (temporaryLocation < [[self string] length]) {
                temporaryLocation = NSMaxRange([completeString lineRangeForRange:NSMakeRange(temporaryLocation, 0)]);
            }
        }
        
        if (selectedRange.length > 0) {
            NSInteger selectedRangeLocation = selectedRange.location; // Make the location into an NSInteger because otherwise the value gets all screwed up when subtracting from it
            NSInteger charactersToCountBackwards = 1;
            if (numberOfSpacesToDeleteOnFirstLine != -1) {
                charactersToCountBackwards = numberOfSpacesToDeleteOnFirstLine;
            }
            if (selectedRangeLocation - charactersToCountBackwards <= locationOfFirstLine) {
                updatedLocation = locationOfFirstLine;
            } else {
                updatedLocation = selectedRangeLocation - charactersToCountBackwards;
            }
            [updatedSelectionsArray addObject:[NSValue valueWithRange:NSMakeRange(updatedLocation, selectedRange.length - charactersRemovedInSelection)]];
        }
        sumOfAllCharactersRemoved = sumOfAllCharactersRemoved + charactersRemoved;
        [self didChangeText];
    }
    
    if (sumOfAllCharactersRemoved == 0) {
        NSBeep();
    }
    
    if ([updatedSelectionsArray count] > 0) {
        [self setSelectedRanges:updatedSelectionsArray];
    }
}

/*
 
 - shiftRightAction:
 
 */
- (IBAction)shiftRight:(id)sender
{
    NSString *completeString = [self string];
    if ([completeString length] < 1) {
        return;
    }
    NSRange selectedRange;
    
    NSMutableString *replacementString;
    if ([[SMLDefaults valueForKey:MGSFragariaPrefsIndentWithSpaces] boolValue] == YES) {
        replacementString = [NSMutableString string];
        NSInteger numberOfSpacesPerTab = [[SMLDefaults valueForKey:MGSFragariaPrefsIndentWidth] integerValue];
        if ([[SMLDefaults valueForKey:MGSFragariaPrefsUseTabStops] boolValue] == YES) {
            NSInteger locationOnLine = [self selectedRange].location - [[self string] lineRangeForRange:NSMakeRange([self selectedRange].location, 0)].location;
            if (numberOfSpacesPerTab != 0) {
                NSInteger numberOfSpacesLess = locationOnLine % numberOfSpacesPerTab;
                numberOfSpacesPerTab = numberOfSpacesPerTab - numberOfSpacesLess;
            }
        }
        while (numberOfSpacesPerTab--) {
            [replacementString appendString:@" "];
        }
    } else {
        replacementString = [NSMutableString stringWithString:@"\t"];
    }
    NSInteger replacementStringLength = [replacementString length];
    
    NSArray *array = [self selectedRanges];
    NSInteger sumOfAllCharactersInserted = 0;
    NSInteger updatedLocation;
    NSMutableArray *updatedSelectionsArray = [NSMutableArray array];
    for (id item in array) {
        selectedRange = NSMakeRange([item rangeValue].location + sumOfAllCharactersInserted, [item rangeValue].length);
        NSUInteger temporaryLocation = selectedRange.location;
        NSUInteger maxSelectedRange = NSMaxRange(selectedRange);
        NSInteger numberOfLines = 0;
        NSInteger locationOfFirstLine = [completeString lineRangeForRange:NSMakeRange(temporaryLocation, 0)].location;
        
        do {
            temporaryLocation = NSMaxRange([completeString lineRangeForRange:NSMakeRange(temporaryLocation, 0)]);
            numberOfLines++;
        } while (temporaryLocation < maxSelectedRange);
        
        temporaryLocation = selectedRange.location;
        NSInteger idx;
        NSUInteger charactersInserted = 0;
        NSInteger charactersInsertedInSelection = 0;
        NSRange rangeOfLine;
        for (idx = 0; idx < numberOfLines; idx++) {
            rangeOfLine = [completeString lineRangeForRange:NSMakeRange(temporaryLocation, 0)];
            if ([self shouldChangeTextInRange:NSMakeRange(rangeOfLine.location, 0) replacementString:replacementString]) { // Do it this way to mark it as an Undo
                [self replaceCharactersInRange:NSMakeRange(rangeOfLine.location, 0) withString:replacementString];
            }
            charactersInserted = charactersInserted + replacementStringLength;
            if (rangeOfLine.location >= selectedRange.location && rangeOfLine.location < maxSelectedRange + charactersInserted) {
                charactersInsertedInSelection = charactersInsertedInSelection + replacementStringLength;
            }
            if (temporaryLocation < [[self string] length]) {
                temporaryLocation = NSMaxRange([completeString lineRangeForRange:NSMakeRange(temporaryLocation, 0)]);
            }
        }
        
        if (selectedRange.length > 0) {
            if (selectedRange.location + replacementStringLength >= [[self string] length]) {
                updatedLocation = locationOfFirstLine;
            } else {
                updatedLocation = selectedRange.location;
            }
            [updatedSelectionsArray addObject:[NSValue valueWithRange:NSMakeRange(updatedLocation, selectedRange.length + charactersInsertedInSelection)]];
        }
        sumOfAllCharactersInserted = sumOfAllCharactersInserted + charactersInserted;
        [self didChangeText];
    }
    
    if ([updatedSelectionsArray count] > 0) {
        [self setSelectedRanges:updatedSelectionsArray];
    }
}

#pragma mark -
#pragma mark Text manipulation

/*
 
 - removeNeedlessWhitespaceAction:
 
 */
- (IBAction)removeNeedlessWhitespace:(id)sender
{
    // First count the number of lines in which to perform the action, as the original range changes when you insert characters, and then perform the action line after line, by removing tabs and spaces after the last non-whitespace characters in every line
    
    NSString *completeString = [self string];
    if ([completeString length] < 1) {
        return;
    }
    NSRange selectedRange;
    
    NSArray *array = [self selectedRanges];
    NSInteger sumOfAllCharactersRemoved = 0;
    NSInteger updatedLocation;
    NSMutableArray *updatedSelectionsArray = [NSMutableArray array];
    for (id item in array) {
        selectedRange = NSMakeRange([item rangeValue].location - sumOfAllCharactersRemoved, [item rangeValue].length);
        NSUInteger tempLocation = selectedRange.location;
        NSUInteger maxSelectedRange = NSMaxRange(selectedRange);
        NSInteger numberOfLines = 0;
        NSInteger locationOfFirstLine = [completeString lineRangeForRange:NSMakeRange(tempLocation, 0)].location;
        
        do {
            tempLocation = NSMaxRange([completeString lineRangeForRange:NSMakeRange(tempLocation, 0)]);
            numberOfLines++;
        } while (tempLocation < maxSelectedRange);
        
        tempLocation = selectedRange.location;
        NSInteger idx;
        NSInteger charactersRemoved = 0;
        NSInteger charactersRemovedInSelection = 0;
        NSRange rangeOfLine;
        
        NSUInteger endOfContentsLocation;
        for (idx = 0; idx < numberOfLines; idx++) {
            rangeOfLine = [completeString lineRangeForRange:NSMakeRange(tempLocation, 0)];
            [completeString getLineStart:NULL end:NULL contentsEnd:&endOfContentsLocation forRange:rangeOfLine];
            
            while (endOfContentsLocation != 0 && ([completeString characterAtIndex:endOfContentsLocation - 1] == ' ' || [completeString characterAtIndex:endOfContentsLocation - 1] == '\t')) {
                if ([self shouldChangeTextInRange:NSMakeRange(endOfContentsLocation - 1, 1) replacementString:@""]) { // Do it this way to mark it as an Undo
                    [self replaceCharactersInRange:NSMakeRange(endOfContentsLocation - 1, 1) withString:@""];
                }
                endOfContentsLocation--;
                charactersRemoved++;
                if (rangeOfLine.location >= selectedRange.location && rangeOfLine.location < maxSelectedRange) {
                    charactersRemovedInSelection++;
                }
            }
            tempLocation = NSMaxRange([completeString lineRangeForRange:NSMakeRange(tempLocation, 0)]);
        }
        
        if (selectedRange.length > 0) {
            NSInteger selectedRangeLocation = selectedRange.location; // Make the location into an NSInteger because otherwise the value gets all screwed up when subtracting from it
            if (selectedRangeLocation - 1 <= locationOfFirstLine) {
                updatedLocation = locationOfFirstLine;
            } else {
                updatedLocation = selectedRangeLocation - 1;
            }
            [updatedSelectionsArray addObject:[NSValue valueWithRange:NSMakeRange(updatedLocation, selectedRange.length - charactersRemoved)]];
        }
        sumOfAllCharactersRemoved = sumOfAllCharactersRemoved + charactersRemoved;
        [self didChangeText];
    }
    
    if (sumOfAllCharactersRemoved == 0) {
        NSBeep();
    }
    
    if ([updatedSelectionsArray count] > 0) {
        [self setSelectedRanges:updatedSelectionsArray];
    }
}

/*
 
 - toLowercaseAction:
 
 */
- (IBAction)lowercaseCharacters:(id)sender
{
    NSArray *array = [self selectedRanges];
    for (id item in array) {
        NSRange selectedRange = [item rangeValue];
        NSString *originalString = [[self string] substringWithRange:selectedRange];
        NSString *newString = [NSString stringWithString:[originalString lowercaseString]];
        [self setSelectedRange:selectedRange];
        [self insertText:newString];
    }
}

/*
 
 - toUppercaseAction:
 
 */
- (IBAction)uppercaseCharacters:(id)sender
{
    NSArray *array = [self selectedRanges];
    for (id item in array) {
        NSRange selectedRange = [item rangeValue];
        NSString *originalString = [[self string] substringWithRange:selectedRange];
        NSString *newString = [NSString stringWithString:[originalString uppercaseString]];
        [self setSelectedRange:selectedRange];
        [self insertText:newString];
    }
}


- (IBAction)capitalizeWord:(id)sender
{
    /* This is because NSResponder does not tag this action as an IBAction,
     * thus it does not appear in IB for linking. */
    [super capitalizeWord:sender];
}


/*
 
 - entabAction:
 
 */
- (IBAction)entab:(id)sender
{
    [[self.fragaria extraInterfaceController] setCompletionTarget:self];
    [[self.fragaria extraInterfaceController] displayEntab];
}

/*
 
 - detabAction
 
 */
- (IBAction)detab:(id)sender
{
    [[self.fragaria extraInterfaceController] setCompletionTarget:self];
    [[self.fragaria extraInterfaceController] displayDetab];
}


/*
 
 - performEntab
 
 */
- (void)performEntab
{
    NSRange selectedRange;
    NSRange savedRange = [self selectedRange];
    
    NSArray *array = [self selectedRanges];
    NSInteger numberOfSpaces = [[SMLDefaults valueForKey:MGSFragariaPrefsSpacesPerTabEntabDetab] integerValue];
    NSMutableString *completeString = [NSMutableString stringWithString:[self string]];
    NSInteger sumOfRemovedCharacters = 0;
    for (id item in array) {
        selectedRange = NSMakeRange([item rangeValue].location - sumOfRemovedCharacters, [item rangeValue].length);
        
        NSInteger removedCharsInLine = 0;
        NSRange thisSpace, prevSpaces, thisLine, range;
        prevSpaces = NSMakeRange(NSNotFound, 0);
        thisLine = NSMakeRange(NSNotFound, 0);
        range = selectedRange;
        thisSpace = [completeString rangeOfString:@" " options:NSLiteralSearch range:range];
        while (thisSpace.length) {
            NSInteger phase, temp;
            
            if (!NSLocationInRange(thisSpace.location, thisLine)) {
                thisLine = [completeString lineRangeForRange:thisSpace];
                removedCharsInLine = 0;
            }
            
            if (NSMaxRange(prevSpaces) == thisSpace.location)
                prevSpaces.length++;
            else
                prevSpaces = thisSpace;
            
            phase = (removedCharsInLine + NSMaxRange(prevSpaces) - thisLine.location) % numberOfSpaces;
            if (phase == 0) {
                if (prevSpaces.length > 1) {
                    [completeString replaceCharactersInRange:prevSpaces withString:@"\t"];
                    removedCharsInLine += prevSpaces.length - 1;
                    temp = NSMaxRange(range) - (prevSpaces.length - 1);
                    range.location = prevSpaces.location;
                    range.length = temp - range.location;
                    thisSpace.location = prevSpaces.location;
                    thisLine.length -= prevSpaces.length - 1;
                }
                prevSpaces = NSMakeRange(NSNotFound, 0);
            }
            
            range.length -= NSMaxRange(thisSpace) - range.location;
            range.location = NSMaxRange(thisSpace);
            
            thisSpace = [completeString rangeOfString:@" " options:NSLiteralSearch range:range];
        }
        
        if ([self shouldChangeTextInRange:NSMakeRange(0, [[self string] length]) replacementString:completeString]) { // Do it this way to mark it as an Undo
            [self replaceCharactersInRange:NSMakeRange(0, [[self string] length]) withString:completeString];
            [self didChangeText];
        }
        
    }
    
    [self setSelectedRange:NSMakeRange(savedRange.location, 0)];
}

/*
 
 - performDetab
 
 */
- (void)performDetab
{
    NSInteger i;
    NSRange selectedRange;
    NSRange savedRange = [self selectedRange];
    
    NSArray *array = [self selectedRanges];
    NSMutableString *spaces = [NSMutableString string];
    NSInteger numberOfSpaces = [[SMLDefaults valueForKey:MGSFragariaPrefsSpacesPerTabEntabDetab] integerValue];
    for (i=0; i<numberOfSpaces; i++) {
        [spaces appendString:@" "];
    }
    NSMutableString *completeString = [NSMutableString stringWithString:[self string]];
    NSInteger sumOfInsertedCharacters = 0;
    for (id item in array) {
        selectedRange = NSMakeRange([item rangeValue].location + sumOfInsertedCharacters, [item rangeValue].length);
        
        NSRange tempRange;
        tempRange = [completeString rangeOfString:@"\t" options:NSLiteralSearch range:selectedRange];
        while (tempRange.length) {
            NSRange lineRange;
            NSInteger phase;
            NSString *replStr;
            
            lineRange = [completeString lineRangeForRange:tempRange];
            phase = (tempRange.location - lineRange.location) % numberOfSpaces;
            replStr = [spaces substringFromIndex:phase];
            [completeString replaceCharactersInRange:tempRange withString:replStr];
            
            selectedRange.length += [replStr length] - 1;
            selectedRange.length -= NSMaxRange(tempRange) - selectedRange.location;
            selectedRange.location = NSMaxRange(tempRange);
            
            tempRange = [completeString rangeOfString:@"\t" options:NSLiteralSearch range:selectedRange];
        }
        
        if ([self shouldChangeTextInRange:NSMakeRange(0, [[self string] length]) replacementString:completeString]) { // Do it this way to mark it as an Undo
            [self replaceCharactersInRange:NSMakeRange(0, [[self string] length]) withString:completeString];
            [self didChangeText];
        }
        
    }
    
    [self setSelectedRange:NSMakeRange(savedRange.location, 0)];
}


- (IBAction)transpose:(id)sender
{
    /* This is because NSResponder does not tag this action as an IBAction,
     * thus it does not appear in IB for linking. */
    [super transpose:sender];
}


#pragma mark -
#pragma mark Goto

/*
 
 - goToLineAction:
 
 */
- (IBAction)goToLine:(id)sender
{
    [[self.fragaria extraInterfaceController] setCompletionTarget:self];
    [[self.fragaria extraInterfaceController] displayGoToLine];
}


/*
 
 - performGoToLine:
 
 */
- (void)performGoToLine:(NSInteger)lineToGoTo setSelected:(BOOL)highlight
{
    NSInteger lineNumber;
    NSInteger idx;
    NSString *completeString = self.string;
    NSInteger completeStringLength = [completeString length];
    NSInteger numberOfLinesInDocument;
    for (idx = 0, numberOfLinesInDocument = 1; idx < completeStringLength; numberOfLinesInDocument++) {
        idx = NSMaxRange([completeString lineRangeForRange:NSMakeRange(idx, 0)]);
    }
    if (lineToGoTo > numberOfLinesInDocument) {
        NSBeep();
        return;
    }
    
    for (idx = 0, lineNumber = 1; lineNumber < lineToGoTo; lineNumber++) {
        idx = NSMaxRange([completeString lineRangeForRange:NSMakeRange(idx, 0)]);
    }
    
    if (highlight) {
        [self setSelectedRange:[completeString lineRangeForRange:NSMakeRange(idx, 0)]];
    }
    [self scrollRangeToVisible:[completeString lineRangeForRange:NSMakeRange(idx, 0)]];
}


#pragma mark -
#pragma mark Tag manipulation


/*
 
 - closeTagAction:
 
 */
- (IBAction)closeTag:(id)sender
{
    NSRange selectedRange = [self selectedRange];
    if (selectedRange.length > 0) {
        NSBeep();
        return;
    }
    
    NSUInteger location = selectedRange.location;
    NSString *completeString = [self string];
    BOOL foundClosingBrace = NO;
    BOOL foundOpeningBrace = NO;
    
    while (location--) { // First check that there is a closing c i.e. >
        if ([completeString characterAtIndex:location] == '>') {
            foundClosingBrace = YES;
            break;
        }
    }
    
    if (!foundClosingBrace) {
        NSBeep();
        return;
    }
    
    NSInteger locationOfClosingBrace = location;
    NSInteger numberOfClosingTags = 0;
    
    while (location--) { // Then check for the opening brace i.e. <
        if ([completeString characterAtIndex:location] == '<') {
            // Divide into four checks as otherwise it will miss to skip the tag if it comes absolutely last in the document
            if (location + 4 <= [completeString length]) { // Check that the tag is not one of the tags that aren't closed e.g. <br> or any of their variants
                NSString *checkString = [completeString substringWithRange:NSMakeRange(location, 4)];
                NSRange searchRange = NSMakeRange(0, [checkString length]);
                if ([checkString rangeOfString:@"<br>" options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<hr>" options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<!--" options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<?" options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<%" options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                }
            }
            
            if (location + 5 <= [completeString length]) { // Check that the tag is not one of the tags that aren't closed e.g. <br> or any of their variants
                NSString *checkString = [completeString substringWithRange:NSMakeRange(location, 5)];
                NSRange searchRange = NSMakeRange(0, [checkString length]);
                if ([checkString rangeOfString:@"<img " options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<br/>" options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                }
            }
            
            if (location + 6 <= [completeString length]) { // Check that the tag is not one of the tags that aren't closed e.g. <br> or any of their variants
                NSString *checkString = [completeString substringWithRange:NSMakeRange(location, 6)];
                NSRange searchRange = NSMakeRange(0, [checkString length]);
                if ([checkString rangeOfString:@"<br />" options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<hr />" options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<area " options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<base " options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<link " options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<meta " options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                }
            }
            
            if (location + 7 < [completeString length]) { // check that the tag is not one of the tags that aren't closed e.g. <br> and their variants
                NSString *checkString = [completeString substringWithRange:NSMakeRange(location, 7)];
                NSRange searchRange = NSMakeRange(0, [checkString length]);
                if ([checkString rangeOfString:@"<frame " options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<input " options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                } else if ([checkString rangeOfString:@"<param " options:NSCaseInsensitiveSearch range:searchRange].location != NSNotFound) {
                    continue;
                }
            }
            
            NSScanner *selfClosingScanner = [NSScanner scannerWithString:[completeString substringWithRange:NSMakeRange(location, locationOfClosingBrace - location)]];
            [selfClosingScanner setCharactersToBeSkipped:nil];
            NSString *selfClosingScanString = [NSString string];
            [selfClosingScanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@">"] intoString:&selfClosingScanString];
            
            if ([selfClosingScanString length] != 0) {
                if ([selfClosingScanString characterAtIndex:([selfClosingScanString length] - 1)] == '/') {
                    continue;
                }
            }
            
            if ([completeString characterAtIndex:location + 1] == '/') { // If it's a closing tag (e.g. </a>) continue the search
                numberOfClosingTags++;
                continue;
            } else {
                if (numberOfClosingTags) { // Try to find the "correct" tag to close by counting the number of closing tags and when they match up insert the created closing tag; if they don't write balanced code - well, tough luck...
                    numberOfClosingTags--;
                } else {
                    foundOpeningBrace = YES;
                    break;
                }
            }
        }
    }
    
    if (foundOpeningBrace == NO) {
        NSBeep();
        return;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:[completeString substringWithRange:NSMakeRange(location, locationOfClosingBrace - location)]];
    [scanner setCharactersToBeSkipped:nil];
    NSString *scanString = [NSString string];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@" >/"] intoString:&scanString]; // Set the string to everything up to any of the characters (space),> or / so that it will catch things like <a href... as well as <br>
    
    NSMutableString *tagString = [NSMutableString stringWithString:scanString];
    NSInteger tagStringLength = [tagString length];
    if (tagStringLength == 0) {
        NSBeep();
        return;
    }
    
    [tagString insertString:@"/" atIndex:1];
    [tagString insertString:@">" atIndex:tagStringLength + 1];
    
    if ([self shouldChangeTextInRange:selectedRange replacementString:tagString]) { // Do it this way to mark it as an Undo
        [self replaceCharactersInRange:selectedRange withString:tagString];
        [self didChangeText];
    }
}

/*
 
 - prepareForXMLAction:
 
 */
- (IBAction)prepareForXML:(id)sender
{
    NSRange selectedRange = [self selectedRange];
    NSMutableString *stringToConvert = [NSMutableString stringWithString:[[self string] substringWithRange:selectedRange]];
    [stringToConvert replaceOccurrencesOfString:@"&amp;" withString:@"&" options:NSLiteralSearch range:NSMakeRange(0, [stringToConvert length])];
    [stringToConvert replaceOccurrencesOfString:@"&" withString:@"&amp;" options:NSLiteralSearch range:NSMakeRange(0, [stringToConvert length])];
    [stringToConvert replaceOccurrencesOfString:@"<" withString:@"&lt;" options:NSLiteralSearch range:NSMakeRange(0, [stringToConvert length])];
    [stringToConvert replaceOccurrencesOfString:@">" withString:@"&gt;" options:NSLiteralSearch range:NSMakeRange(0, [stringToConvert length])];
    if ([self shouldChangeTextInRange:selectedRange replacementString:stringToConvert]) { // Do it this way to mark it as an Undo
        [self replaceCharactersInRange:selectedRange withString:stringToConvert];
        [self didChangeText];
    }
}

#pragma mark -
#pragma mark Comment handling

/*
 
 - commentOrUncommentAction:
 
 */
- (IBAction)commentOrUncomment:(id)sender
{
    NSString *completeString = [self string];
    NSString *commentString = [[[self.fragaria objectForKey:ro_MGSFOSyntaxColouring] syntaxDefinition] firstSingleLineComment];
    NSUInteger commentStringLength = [commentString length];
    if ([commentString isEqualToString:@""] || [completeString length] < commentStringLength) {
        NSBeep();
        return;
    }
    
    NSArray *array = [self selectedRanges];
    NSRange selectedRange = NSMakeRange(0, 0);
    NSInteger sumOfChangedCharacters = 0;
    NSMutableArray *updatedSelectionsArray = [NSMutableArray array];
    for (id item in array) {
        selectedRange = NSMakeRange([item rangeValue].location + sumOfChangedCharacters, [item rangeValue].length);
        
        NSUInteger tempLocation = selectedRange.location;
        NSUInteger maxSelectedRange = NSMaxRange(selectedRange);
        NSInteger numberOfLines = 0;
        NSInteger locationOfFirstLine = [completeString lineRangeForRange:NSMakeRange(tempLocation, 0)].location;
        
        BOOL shouldUncomment = NO;
        NSInteger searchLength = commentStringLength;
        if ((tempLocation + commentStringLength) > [completeString length]) {
            searchLength = 0;
        }
        
        if ([completeString rangeOfString:commentString options:NSCaseInsensitiveSearch range:NSMakeRange(tempLocation, searchLength)].location != NSNotFound) {
            shouldUncomment = YES; // The first line of the selection is already commented and thus we should uncomment
        } else if ([completeString rangeOfString:commentString options:NSCaseInsensitiveSearch range:NSMakeRange(locationOfFirstLine, searchLength)].location != NSNotFound) {
            shouldUncomment = YES; // Check the beginning of the line too
        } else { // Also check the first character after the whitespace
            NSInteger firstCharacterOfFirstLine = locationOfFirstLine;
            while ([completeString characterAtIndex:firstCharacterOfFirstLine] == ' ' || [completeString characterAtIndex:firstCharacterOfFirstLine] == '\t') {
                firstCharacterOfFirstLine++;
            }
            if ([completeString rangeOfString:commentString options:NSCaseInsensitiveSearch range:NSMakeRange(firstCharacterOfFirstLine, searchLength)].location != NSNotFound) {
                shouldUncomment = YES;
            }
        }
        
        do {
            tempLocation = NSMaxRange([completeString lineRangeForRange:NSMakeRange(tempLocation, 0)]);
            numberOfLines++;
        } while (tempLocation < maxSelectedRange);
        NSInteger locationOfLastLine = tempLocation;
        
        tempLocation = selectedRange.location;
        NSInteger idx;
        NSInteger charactersInserted = 0;
        NSRange rangeOfLine;
        NSInteger firstCharacterOfLine;
        
        for (idx = 0; idx < numberOfLines; idx++) {
            rangeOfLine = [completeString lineRangeForRange:NSMakeRange(tempLocation, 0)];
            if (shouldUncomment == NO) {
                if ([self shouldChangeTextInRange:NSMakeRange(rangeOfLine.location, 0) replacementString:commentString]) { // Do it this way to mark it as an Undo
                    [self replaceCharactersInRange:NSMakeRange(rangeOfLine.location, 0) withString:commentString];
                }
                charactersInserted = charactersInserted + commentStringLength;
            } else {
                firstCharacterOfLine = rangeOfLine.location;
                while ([completeString characterAtIndex:firstCharacterOfLine] == ' ' || [completeString characterAtIndex:firstCharacterOfLine] == '\t') {
                    firstCharacterOfLine++;
                }
                if ([completeString rangeOfString:commentString options:NSCaseInsensitiveSearch range:NSMakeRange(firstCharacterOfLine, [commentString length])].location != NSNotFound) {
                    if ([self shouldChangeTextInRange:NSMakeRange(firstCharacterOfLine, commentStringLength) replacementString:@""]) { // Do it this way to mark it as an Undo
                        [self replaceCharactersInRange:NSMakeRange(firstCharacterOfLine, commentStringLength) withString:@""];
                    }		
                    charactersInserted = charactersInserted - commentStringLength;
                }
            }
            tempLocation = NSMaxRange([completeString lineRangeForRange:NSMakeRange(tempLocation, 0)]);
        }
        sumOfChangedCharacters = sumOfChangedCharacters + charactersInserted;
        [updatedSelectionsArray addObject:[NSValue valueWithRange:NSMakeRange(locationOfFirstLine, locationOfLastLine - locationOfFirstLine + charactersInserted)]];
        [self didChangeText];
    }
    
    if (selectedRange.length > 0) {
        [self setSelectedRanges:updatedSelectionsArray];
    }
    
}

#pragma mark -
#pragma mark Line endings

/*
 
 - removeLineEndingsAction:
 
 */
- (IBAction)removeLineEndings:(id)sender
{
    NSString *text = [self string];
    NSArray *array = [self selectedRanges];
    NSInteger sumOfDeletedLineEndings = 0;
    NSMutableArray *updatedSelectionsArray = [NSMutableArray array];
    for (id item in array) {
        NSRange selectedRange = NSMakeRange([item rangeValue].location - sumOfDeletedLineEndings, [item rangeValue].length);
        NSString *stringToRemoveLineEndingsFrom = [text substringWithRange:selectedRange];
        NSInteger originalLength = [stringToRemoveLineEndingsFrom length];
        NSString *stringWithNoLineEndings = [self removeAllLineEndingsFromString:stringToRemoveLineEndingsFrom];
        NSInteger newLength = [stringWithNoLineEndings length];
        if ([self shouldChangeTextInRange:NSMakeRange(selectedRange.location, originalLength) replacementString:stringWithNoLineEndings]) { // Do it this way to mark it as an Undo
            [self replaceCharactersInRange:NSMakeRange(selectedRange.location, originalLength) withString:stringWithNoLineEndings];
            [self didChangeText];
        }			
        sumOfDeletedLineEndings = sumOfDeletedLineEndings + (originalLength - newLength);
        
        [updatedSelectionsArray addObject:[NSValue valueWithRange:NSMakeRange(selectedRange.location, newLength)]];
    }
    
    if ([updatedSelectionsArray count] > 0) {
        [self setSelectedRanges:updatedSelectionsArray];
    }
}


- (NSString *)removeAllLineEndingsFromString:(NSString*)orig
{
    NSMutableString *string = [orig mutableCopy];
    NSCharacterSet *newlines = [NSCharacterSet newlineCharacterSet];
    NSRange range;
    
    range = [string rangeOfCharacterFromSet:newlines];
    while (range.length) {
        [string replaceCharactersInRange:range withString:@""];
        range.length = [string length] - range.location;
        range = [string rangeOfCharacterFromSet:newlines options:0 range:range];
    }
    return string;
}


@end
