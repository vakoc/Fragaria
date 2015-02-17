//
//  MGSSyntaxErrorController.m
//  Fragaria
//
//  Created by Jim Derry on 2/15/15.
//
//

#import "MGSSyntaxErrorController.h"


#define kSMLErrorPopOverMargin       8
#define kSMLErrorPopOverErrorSpacing 4.0


@implementation MGSSyntaxErrorController

@synthesize syntaxErrors = _syntaxErrors;


#pragma mark - Property Accessors

- (void)setSyntaxErrors:(NSArray *)syntaxErrors
{
    NSPredicate *filter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[SMLSyntaxError class]];
    }];
    _syntaxErrors = [syntaxErrors filteredArrayUsingPredicate:filter];;

}

- (NSArray*)syntaxErrors
{
    return _syntaxErrors;
}


#pragma mark - Instance Methods

- (instancetype)initWithArray:(NSArray *)array
{
    if ((self = [super init]))
    {
        [self setSyntaxErrors:array];
    }

    return self;
}


- (NSArray *)linesWithErrors
{
    return [[self.syntaxErrors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden == %@", @(NO)]] valueForKeyPath:@"@distinctUnionOfObjects.line"];
}


- (NSUInteger)errorCountForLine:(NSInteger)line
{
    return [[[self.syntaxErrors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(line == %@) AND (hidden == %@)", @(line), @(NO)]] valueForKeyPath:@"@count"] integerValue];
}


- (SMLSyntaxError *)errorForLine:(NSInteger)line
{
    float highestErrorLevel = [[[self errorsForLine:line] valueForKeyPath:@"@max.warningStyle"] floatValue];
    NSArray* errors = [[self errorsForLine:line] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"warningStyle = %@", @(highestErrorLevel)]];

    return errors.firstObject;
}


- (NSArray*)errorsForLine:(NSInteger)line
{
    return [self.syntaxErrors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(line == %@) AND (hidden == %@)", @(line), @(NO)]];
}


- (NSArray *)nonHiddenErrors
{
    return [self.syntaxErrors filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"hidden == %@", @(NO)]];
}


- (NSDictionary *)errorDecorations
{
    return [self errorDecorationsHavingSize:NSMakeSize(0.0, 0.0)];
}


- (NSDictionary *)errorDecorationsHavingSize:(NSSize)size
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];

    for (NSNumber *line in [self linesWithErrors])
    {
        NSImage *image = [[self errorForLine:[line integerValue]] warningImage];
        if (size.height > 0.0 && size.width > 0)
        {
            [image setSize:size];
        }
        [result setObject:image forKey:line];
    }

    return result;
}


- (void)showErrorsForLine:(NSUInteger)line relativeToRect:(NSRect)rect ofView:(NSView*)view
{
    /// @todo: (jsd) add images.
    NSArray *errors = [[self errorsForLine:line] valueForKeyPath:@"@distinctUnionOfObjects.description"];
    if (!errors.count) return;

    NSFont* font = [NSFont systemFontOfSize:10];
    NSMutableAttributedString *errorsString;
    NSMutableParagraphStyle *parStyle;
    NSTextField *textField;
    NSSize balloonSize;
    int i;

    // Create view controller
    NSViewController *vc = [[NSViewController alloc] init];
    [vc setView:[[NSView alloc] init]];

    errorsString = [[NSMutableAttributedString alloc] init];
    i = 0;
    for (NSString* err in errors) {
        NSMutableString *muts;

        muts = [err mutableCopy];
        [muts replaceOccurrencesOfString:@"\n" withString:@"\u2028" options:0 range:NSMakeRange(0, [muts length])];
        if (i != 0)
            [[errorsString mutableString] appendString:@"\n"];
        [[errorsString mutableString] appendString:muts];
        i++;
    }

    parStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [parStyle setParagraphSpacing:kSMLErrorPopOverErrorSpacing];
    [errorsString setAttributes:
     @{NSParagraphStyleAttributeName: parStyle, NSFontAttributeName: font}
                          range:NSMakeRange(0, [errorsString length])];

    textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [textField setAttributedStringValue:errorsString];
    [textField setBezeled:NO];
    [textField setDrawsBackground:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];
    [textField sizeToFit];
    [textField setFrameOrigin:NSMakePoint(kSMLErrorPopOverMargin, kSMLErrorPopOverMargin)];

    [vc.view addSubview:textField];
    balloonSize = [textField frame].size;
    balloonSize.width += 2 * kSMLErrorPopOverMargin;
    balloonSize.height += 2 * kSMLErrorPopOverMargin;
    [vc.view setFrameSize:balloonSize];

    // Open the popover
    NSPopover* popover = [[NSPopover alloc] init];
    popover.behavior = NSPopoverBehaviorTransient;
    popover.contentSize = vc.view.bounds.size;
    popover.contentViewController = vc;
    popover.animates = YES;

    [popover showRelativeToRect:rect ofView:view preferredEdge:NSMinYEdge];
}



@end
