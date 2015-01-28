//
//  SMLErrorPopOver.m
//  Fragaria
//
//  Created by Viktor Lidholt on 4/11/13.
//
//

#import "SMLErrorPopOver.h"

#define kSMLErrorPopOverMargin       4
#define kSMLErrorPopOverErrorSpacing 2.0

@implementation SMLErrorPopOver


+ (void) showErrorDescriptions:(NSArray*)errors relativeToView:(NSView*) view
{
    NSFont* font = [NSFont systemFontOfSize:10];
    NSMutableAttributedString *errorsString;
    NSMutableParagraphStyle *parStyle;
    NSTextField *textField;
    NSSize balloonSize;
    int i;
    
    if (!errors.count) return;
    
    // Create view controller
    NSViewController* vc = [[NSViewController alloc] initWithNibName:@"ErrorPopoverView" bundle:[NSBundle bundleForClass:[self class]]];
    
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
    
    [popover showRelativeToRect:[view bounds] ofView:view preferredEdge:NSMinYEdge];
}

@end
