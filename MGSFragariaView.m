//
//  MGSFragariaView.h
//  Fragaria
//
//  File created by Jim Derry on 2015/02/07.
//
//  Implements an NSView subclass that abstracts several characteristics of Fragaria,
//  such as the use of Interface Builder to set delegates and assign key-value pairs.
//  Also provides property abstractions for Fragaria's settings and methods.
//

#import "MGSFragariaView.h"


#pragma mark - PRIVATE INTERFACE


@interface MGSFragariaView ()

@property (strong) MGSFragaria *fragaria;

@end


#pragma mark - IMPLEMENTATION


@implementation MGSFragariaView


#pragma mark - Initialization and Setup


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	initWithCoder:
        called when unarchived from the nib linking directly.
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (instancetype)initWithCoder:(NSCoder *)coder
{
	if ((self = [super initWithCoder:coder]))
	{
		/*
		   Don't initialize in awakeFromNib otherwise
		   IB User Defined Runtime Attributes won't
		   be honored.
		 */
		self.fragaria = [[MGSFragaria alloc] init];
	}
	return self;
}

/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	initWithFrame:
        called when used in a framework.
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (instancetype)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
		/*
		   Don't initialize in awakeFromNib otherwise
		   IB User Defined Runtime Attributes won't
		   be honored.
		 */
		self.fragaria = [[MGSFragaria alloc] init];
    }
    return self;
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	awakeFromNib
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)awakeFromNib
{
	[self.fragaria embedInView:self];
	self.textView = [self.fragaria objectForKey:ro_MGSFOTextView];
}


#pragma mark - Delegate Setters and Getters


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	delegate
		Expose the embedded NSTextView's delegate.
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setDelegate:(id<MGSFragariaTextViewDelegate>)delegate
{
	[self.fragaria setObject:delegate forKey:MGSFODelegate];
}

- (id<MGSFragariaTextViewDelegate>)delegate
{
	return [self.fragaria objectForKey:MGSFODelegate];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	breakPointDelegate
		Expose Fregaria's <MGSBreakpointDelegate> delegate.
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setBreakPointDelegate:(id<MGSBreakpointDelegate>)breakPointDelegate
{
	[self.fragaria setObject:breakPointDelegate forKey:MGSFOBreakpointDelegate];
}

- (id<MGSBreakpointDelegate>)breakPointDelegate
{
	return [self.fragaria objectForKey:MGSFODelegate];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	syntaxColoringDelegate
		Expose Fregaria's <SMLSyntaxColouringDelegate> delegate.
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setSyntaxColoringDelegate:(id<SMLSyntaxColouringDelegate>)syntaxColoringDelegate
{
	[self.fragaria setObject:syntaxColoringDelegate forKey:MGSFOSyntaxColouringDelegate];
}

- (id<SMLSyntaxColouringDelegate>)syntaxColoringDelegate
{
	return [self.fragaria objectForKey:MGSFODelegate];
}


#pragma mark - Key Method-to-Property Promotions


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	string
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setString:(NSString *)string
{
	[self.fragaria setString:string];
}

- (NSString *)string
{
	return [self.fragaria string];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	attributedString
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setAttributedString:(NSAttributedString *)attributedString
{
	[self.fragaria setAttributedString:attributedString];
}

- (NSAttributedString *)attributedString
{
	return [self.fragaria attributedString];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	syntaxColoured
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setSyntaxColoured:(BOOL)syntaxColoured
{
	[self.fragaria setIsSyntaxColoured:syntaxColoured];
}

- (BOOL)syntaxColoured
{
	return [self.fragaria isSyntaxColoured];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	showsLineNumbers
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setShowsLineNumbers:(BOOL)showsLineNumbers
{
	[self.fragaria setShowsLineNumbers:showsLineNumbers];
}

- (BOOL)showsLineNumbers
{
	return [self.fragaria showsLineNumbers];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	lineWrap
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setLineWrap:(BOOL)lineWrap
{
    [self.fragaria setLineWrap:lineWrap];
}

- (BOOL)lineWrap
{
    return [self.fragaria lineWrap];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	hasVerticalScroller
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setHasVerticalScroller:(BOOL)hasVerticalScroller
{
	[self.fragaria setHasVerticalScroller:hasVerticalScroller];
}

- (BOOL)hasVerticalScroller
{
	return [self.fragaria hasVerticalScroller];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	scrollElasticityDisabled
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setScrollElasticityDisabled:(BOOL)scrollElasticityDisabled
{
	[self.fragaria setScrollElasticityDisabled:scrollElasticityDisabled];
}

- (BOOL)scrollElasticityDisabled
{
	return [self.fragaria scrollElasticityDisabled];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	startingLineNumber
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setStartingLineNumber:(NSUInteger)startingLineNumber
{
	[self.fragaria setStartingLineNumber:startingLineNumber];
}

- (NSUInteger)startingLineNumber
{
	return [self.fragaria startingLineNumber];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	syntaxDefinitionName
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setSyntaxDefinitionName:(NSString *)syntaxDefinitionName
{
	[self.fragaria setSyntaxDefinitionName:syntaxDefinitionName];
}

- (NSString *)syntaxDefinitionName
{
	return [self.fragaria syntaxDefinitionName];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	documentName
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setDocumentName:(NSString *)documentName
{
	[self.fragaria setDocumentName:documentName];
}

- (NSString *)documentName
{
	return [self.fragaria documentName];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	syntaxErrors
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setSyntaxErrors:(NSArray *)syntaxErrors
{
	self.fragaria.syntaxErrors = syntaxErrors;
}

- (NSArray *)syntaxErrors
{
	return self.fragaria.syntaxErrors;
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	showsWarningsInGutter
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
- (void)setShowsWarningsInGutter:(BOOL)showsWarningsInGutter
{
    [self.fragaria setShowsWarningsInGutter:showsWarningsInGutter];
}

- (BOOL)showsWarningsInGutter
{
    return [self.fragaria showsWarningsInGutter];
}


/*–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*
	goToLine
 *–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––*/
#pragma mark - KEY FRAGARIA METHOD PROMOTIONS

- (void)goToLine:(NSInteger)lineToGoTo centered:(BOOL)centered highlight:(BOOL)highlight
{
	[self.fragaria goToLine:lineToGoTo centered:centered highlight:highlight];
}



@end
