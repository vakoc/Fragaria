//
//  MGSDragOperationDelegate.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 08/02/15.
//
//  - Defines the <MGSDragOperationDelegate> that delegates may conform to.
//

#import <AppKit/AppKit.h>


@protocol MGSDragOperationDelegate <NSDraggingDestination>

@optional

/*
 These mirror the <NSDraggingDestination>. We can't simply tell Fragaria's
 delegate to implement that protocol because it's a required protocol, and
 the delegate may not want to implement all of these.
 */

- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender;
- (BOOL)wantsPeriodicDraggingUpdates;
- (NSDragOperation)draggingUpdated:(id<NSDraggingInfo>)sender;
- (void)draggingEnded:(id<NSDraggingInfo>)sender;
- (void)draggingExited:(id<NSDraggingInfo>)sender;
- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender;
- (BOOL)performDragOperation:(id<NSDraggingInfo>)sender;
- (void)concludeDragOperation:(id <NSDraggingInfo>)sender;
- (void)updateDraggingItemsForDrag:(id<NSDraggingInfo>)sender;

@end
