//
//  StockListWindowController.m
//  StockList Demo for OS X
//
// Copyright 2013 Weswit Srl
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "StockListWindowController.h"
#import "Constants.h"

#define SERVER_URL     (@"http://push.lightstreamer.com")


@implementation StockListWindowController


#pragma mark -
#pragma mark Initialization

- (id) init {
    self = [super initWithWindowNibName:@"StockListWindow"];
    if (self) {

        // Initialization
		_itemNames= [[NSArray alloc] initWithObjects:ITEMS, nil];
		_fieldNames= [[NSArray alloc] initWithObjects:FIELDS, nil];
		
		_itemData= [[NSMutableDictionary alloc] initWithCapacity:NUMBER_OF_ITEMS];
		_itemUpdated= [[NSMutableDictionary alloc] initWithCapacity:NUMBER_OF_ITEMS];
		
		_rowsToBeReloaded= [[NSMutableSet alloc] initWithCapacity:NUMBER_OF_ITEMS];
		
		// Uncomment for detailed logging
//		[LSLog enableSourceType:LOG_SRC_CLIENT];
//		[LSLog enableSourceType:LOG_SRC_SESSION];
//		[LSLog enableSourceType:LOG_SRC_STATE_MACHINE];
//		[LSLog enableSourceType:LOG_SRC_URL_DISPATCHER];
    }
    
    return self;
}

- (void) dealloc {
	[_itemNames release];
	[_fieldNames release];
	
	[_itemData release];
	[_itemUpdated release];
	
	[_rowsToBeReloaded release];

	[super dealloc];
}


#pragma mark -
#pragma mark Window life cycle

- (void) windowDidLoad {
	
	// Disable close window button (setting on xib is not effective)
	NSButton *closeButton= [_stockListWindow standardWindowButton:NSWindowCloseButton];
	[closeButton setEnabled:NO];
	
	// Change aspect of +/- column (setting on xib is not effective)
    NSImageCell *imageCell= [[NSImageCell alloc] init];
	
	NSTableColumn *dirColumn = [_stockListTable tableColumnWithIdentifier:@"3"];
	[dirColumn setDataCell:imageCell];
	[imageCell release];
	
	// Change aspect of table (setting on xib is not effective)
	[_stockListTable setUsesAlternatingRowBackgroundColors:YES];
	
	// Compute height of title bar
	NSRect outerFrame= [[[_stockListWindow contentView] superview] frame];
	NSRect innerFrame= [[_stockListWindow contentView] frame];
	
	float heightOfTitleBar= outerFrame.size.height - innerFrame.size.height;
	
	// Add title bar button for info drawer
	NSButton *infoButton= [[NSButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 28.0, 28.0)];
	[infoButton setButtonType:NSOnOffButton];
	[infoButton setBezelStyle:NSRecessedBezelStyle];
	[infoButton setFont:[NSFont titleBarFontOfSize:13.0]];
	[infoButton setImage:[NSImage imageNamed:@"S-logo.png"]];
	[infoButton setTarget:self];
	[infoButton setAction:@selector(infoButtonClicked)];
	
	float x= 765.0;
	infoButton.frame= NSMakeRect(x, [[_stockListWindow contentView] frame].size.height, infoButton.frame.size.width, heightOfTitleBar);
	
	NSUInteger mask= 0;
	if (x > _stockListWindow.frame.size.width / 2.0)
		mask |= NSViewMinXMargin;
	else
		mask |= NSViewMaxXMargin;
	
	[infoButton setAutoresizingMask:mask | NSViewMinYMargin];
	[[[_stockListWindow contentView] superview] addSubview:infoButton];
	
	// Update status
	[self updateStatus];
	
	// Connect with Lightstreamer
	[self performSelector:@selector(connectToLightstreamer) withObject:nil afterDelay:1.0];
}


#pragma mark -
#pragma mark NSTableViewDataSource methods

- (NSInteger) numberOfRowsInTableView:(NSTableView *)aTableView {
	return NUMBER_OF_ITEMS;
}

- (id) tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	NSMutableDictionary *item= nil;
	NSMutableDictionary *itemUpdated= nil;
	
	@synchronized (_itemData) {
		item= [_itemData objectForKey:[NSNumber numberWithInteger:rowIndex]];
		itemUpdated= [_itemUpdated objectForKey:[NSNumber numberWithInteger:rowIndex]];
		
		if ((!item) || (!itemUpdated))
			return nil;
	}
	
	if (item) {
		switch ([aTableColumn.identifier intValue]) {
			case 0:
				return [item objectForKey:@"stock_name"];
				
			case 1:
				return [item objectForKey:@"last_price"];
				
			case 2:
				return [item objectForKey:@"time"];
				
			case 3: {
				double pctChange= [[item objectForKey:@"pct_change"] doubleValue];
				if (pctChange > 0.0)
					return [NSImage imageNamed:@"Arrow-up.png"];
				else if (pctChange < 0.0)
					return [NSImage imageNamed:@"Arrow-down.png"];
				else
					return nil;
			}
				
			case 4:
				return [NSString stringWithFormat:@"%@%%", [item objectForKey:@"pct_change"]];
				
			case 5:
				return [item objectForKey:@"bid"];
				
			case 6:
				return [item objectForKey:@"ask"];
				
			case 7:
				return [item objectForKey:@"min"];
			
			case 8:
				return [item objectForKey:@"max"];
				
			case 9:
				return [item objectForKey:@"ref_price"];
				
			case 10:
				return [item objectForKey:@"open_price"];
		}
	}
	
	return nil;
}


#pragma mark -
#pragma mark Info button action

- (void) infoButtonClicked {
	if (!_infoDrawer) {
		_infoDrawer= [[NSDrawer alloc] initWithContentSize:CGSizeMake(INFO_WIDTH, INFO_HEIGHT) preferredEdge:3];
		[_infoDrawer setParentWindow:_stockListWindow];

		NSArray *views= nil;
		[[NSBundle mainBundle] loadNibNamed:@"InfoDrawerView" owner:self topLevelObjects:&views];
		
		// Find the view (order of top level objects may be scrambled)
		id drawerView= [views objectAtIndex:0];
		if (![drawerView isKindOfClass:[NSView class]])
			drawerView= [views objectAtIndex:1];
		
		[_infoDrawer setContentView:drawerView];
		
		[self updateStatus];
	}
	
	[_infoDrawer toggle:self];
}


#pragma mark -
#pragma mark NSTableViewDelegate methods

- (void) tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	NSMutableDictionary *item= nil;
	NSMutableDictionary *itemUpdated= nil;
	
	@synchronized (_itemData) {
		item= [_itemData objectForKey:[NSNumber numberWithInteger:rowIndex]];
		itemUpdated= [_itemUpdated objectForKey:[NSNumber numberWithInteger:rowIndex]];
		
		if ((!item) || (!itemUpdated))
			return;
	}
	
	NSTextFieldCell *cell= (NSTextFieldCell *) aCell;
	switch ([aTableColumn.identifier intValue]) {
		case 3:
			
			// Cell is not a NSTextFieldCell, leave the color as it is
			break;
			
		case 4: {
			double value= [cell doubleValue];
			cell.textColor= ((value >= 0.0) ? DK_GREEN_COLOR : RED_COLOR);

			// No "break", continue with highlight code
		}
			
		default: {
			NSArray *fields= [NSArray arrayWithObjects:FIELDS, nil];
			NSString *field= [fields objectAtIndex:[aTableColumn.identifier intValue]];
			BOOL updated= [[itemUpdated objectForKey:field] boolValue];

			if (updated) {
				NSString *colorName= [item objectForKey:@"color"];
				NSColor *color= nil;
				if ([colorName isEqualToString:@"green"])
					color= GREEN_COLOR;
				else if ([colorName isEqualToString:@"orange"])
					color= ORANGE_COLOR;
				
				[cell setDrawsBackground:YES];
				[cell setBackgroundColor:color];

			} else
				[cell setDrawsBackground:NO];
			
			break;
		}
	}
}


#pragma mark -
#pragma mark Lighstreamer management

- (void) connectToLightstreamer {
	_client= [[LSClient alloc] init];
	
	NSLog(@"StockListViewController: Connecting to Lightstreamer...");
	
	LSConnectionInfo *connectionInfo= [LSConnectionInfo connectionInfoWithPushServerURL:SERVER_URL pushServerControlURL:nil user:nil password:nil adapter:@"DEMO"];
	[_client openConnectionWithInfo:connectionInfo delegate:self];
}

- (void) subscribeItems {
	NSLog(@"StockListWindowController: Subscribing table...");
	
	@try {
		LSExtendedTableInfo *tableInfo= [LSExtendedTableInfo extendedTableInfoWithItems:_itemNames mode:LSModeMerge fields:_fieldNames dataAdapter:@"QUOTE_ADAPTER" snapshot:YES];
		tableInfo.requestedMaxFrequency= 1.0;
		
		_tableKey= [[_client subscribeTableWithExtendedInfo:tableInfo delegate:self useCommandLogic:NO] retain];
		
		NSLog(@"StockListWindowController: Table subscribed");
		
	} @catch (NSException *e) {
		NSLog(@"StockListWindowController: Table subscription failed due to exception: %@", e);
	}
}


#pragma mark -
#pragma mark Methods of LSConnectionDelegate

- (void) clientConnection:(LSClient *)client didStartSessionWithPolling:(BOOL)polling {
	NSLog(@"StockListWindowController: Session started with polling: %@", (polling ? @"YES" : @"NO"));
	
	_connected= YES;
	_polling= polling;
	_stalled= NO;
	
	[self updateStatus];
	
	// We subscribe, if not already subscribed. The LSClient will reconnect automatically
	// in most of the cases, so we don't need to resubscribe each time.
	if (!_tableKey)
        [self subscribeItems];
}

- (void) clientConnection:(LSClient *)client didChangeActivityWarningStatus:(BOOL)warningStatus {
	NSLog(@"StockListWindowController: Activity warning status changed: %@", (warningStatus ? @"ON" : @"OFF"));
	
	_stalled= warningStatus;
	
	[self updateStatus];
}

- (void) clientConnectionDidEstablish:(LSClient *)client {
	NSLog(@"StockListWindowController: Connection established");
}

- (void) clientConnectionDidClose:(LSClient *)client {
	NSLog(@"StockListWindowController: Connection closed");

	_connected= NO;
	
	[self updateStatus];
	
	// This event is called just by manually closing the connection,
	// never happens in this example.
}

- (void) clientConnection:(LSClient *)client didEndWithCause:(int)cause {
	NSLog(@"StockListWindowController: Connection ended, cause: %d", cause);

	_connected= NO;
	
	[self updateStatus];
	
	// In this case the session has been closed by the server, the LSClient
	// will not automatically reconnect. Let's prepare for a new connection.
	[_tableKey release];
	_tableKey= nil;
	
	[self performSelector:@selector(connectToLightstreamer) withObject:nil afterDelay:1.0];
}

- (void) clientConnection:(LSClient *)client didReceiveDataError:(LSPushServerException *)error {
	NSLog(@"StockListWindowController: Data error: %@", error);
}

- (void) clientConnection:(LSClient *)client didReceiveServerFailure:(LSPushServerException *)failure {
	NSLog(@"StockListWindowController: Server failure: %@", failure);

	_connected= NO;
	
	[self updateStatus];
	
	// The LSClient will reconnect automatically in this case.
}

- (void) clientConnection:(LSClient *)client didReceiveConnectionFailure:(LSPushConnectionException *)failure {
	NSLog(@"StockListWindowController: Connection failure: %@", failure);
	
	_connected= NO;
	
	[self updateStatus];
	
	// The LSClient will reconnect automatically in this case.
}

- (void) clientConnection:(LSClient *)client isAboutToSendURLRequest:(NSMutableURLRequest *)urlRequest {}


#pragma mark -
#pragma mark Methods of LSTableDelegate

- (void) table:(LSSubscribedTableKey *)tableKey itemPosition:(int)itemPosition itemName:(NSString *)itemName didUpdateWithInfo:(LSUpdateInfo *)updateInfo {
	NSMutableDictionary *item= nil;
	NSMutableDictionary *itemUpdated= nil;
	
	@synchronized (_itemData) {
		item= [_itemData objectForKey:[NSNumber numberWithInt:(itemPosition -1)]];
		if (!item) {
			item= [[[NSMutableDictionary alloc] initWithCapacity:NUMBER_OF_FIELDS] autorelease];
			[_itemData setObject:item forKey:[NSNumber numberWithInt:(itemPosition -1)]];
		}
		
		itemUpdated= [_itemUpdated objectForKey:[NSNumber numberWithInt:(itemPosition -1)]];
		if (!itemUpdated) {
			itemUpdated= [[[NSMutableDictionary alloc] initWithCapacity:NUMBER_OF_FIELDS] autorelease];
			[_itemUpdated setObject:itemUpdated forKey:[NSNumber numberWithInt:(itemPosition -1)]];
		}
	}
	
	for (NSString *fieldName in _fieldNames) {
		NSString *value= [updateInfo currentValueOfFieldName:fieldName];
		
		if (value)
			[item setObject:value forKey:fieldName];
		else
			[item setObject:[NSNull null] forKey:fieldName];
		
		if ([updateInfo isChangedValueOfFieldName:fieldName])
			[itemUpdated setObject:[NSNumber numberWithBool:YES] forKey:fieldName];
	}
	
	// Check variation and store appropriate color
	double currentLastPrice= [[updateInfo currentValueOfFieldName:@"last_price"] doubleValue];
	double previousLastPrice= [[updateInfo previousValueOfFieldName:@"last_price"] doubleValue];
	if (currentLastPrice >= previousLastPrice)
		[item setObject:@"green" forKey:@"color"];
	else
		[item setObject:@"orange" forKey:@"color"];

	@synchronized (_rowsToBeReloaded) {
		[_rowsToBeReloaded addObject:[NSNumber numberWithInt:(itemPosition -1)]];
	}
	
	[self performSelectorOnMainThread:@selector(reloadTableRows) withObject:nil waitUntilDone:NO];
}


#pragma mark -
#pragma mark Internals

- (void) reloadTableRows {
	NSSet *rowsToBeReloaded= nil;

	@synchronized (_rowsToBeReloaded) {
		rowsToBeReloaded= [NSSet setWithSet:_rowsToBeReloaded];
		[_rowsToBeReloaded removeAllObjects];
	}

	NSMutableIndexSet *indexSet= [NSMutableIndexSet indexSet];
	for (NSNumber *index in rowsToBeReloaded)
		[indexSet addIndex:[index intValue]];
	
	// Reload related table cells, willDisplayCell event will do highlighting
	[_stockListTable reloadDataForRowIndexes:indexSet columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, NUMBER_OF_FIELDS)]];
	
	[self performSelector:@selector(unhighlight:) withObject:rowsToBeReloaded afterDelay:FLASH_DURATION];
}

- (void) unhighlight:(NSSet *)rowsToBeUnhighlighted {
	NSArray *fields= [NSArray arrayWithObjects:FIELDS, nil];
	
	for (NSNumber *index in rowsToBeUnhighlighted) {
		NSMutableDictionary *itemUpdated= nil;
		
		@synchronized (_itemData) {
			itemUpdated= [_itemUpdated objectForKey:index];
			if (!itemUpdated)
				continue;
		}
		
		for (int i= 0; i < NUMBER_OF_FIELDS; i++)
			[itemUpdated setObject:[NSNumber numberWithBool:NO] forKey:[fields objectAtIndex:i]];
	}
	
	NSMutableIndexSet *indexSet= [NSMutableIndexSet indexSet];
	for (NSNumber *index in rowsToBeUnhighlighted)
		[indexSet addIndex:[index intValue]];
	
	// Reload related table cells, willDisplayCell event will do unhighlighting
	[_stockListTable reloadDataForRowIndexes:indexSet columnIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, NUMBER_OF_FIELDS)]];
}

- (void) updateStatus {
	if (!_connected) {
		_status= @"Not connected";
		
	} else if (_stalled) {
		_status= @"Stalled";
	
	} else {
		_status= [NSString stringWithFormat:@"Connected\nin %@ mode", _polling ? @"Polling" : @"Streaming"];
	}

	if (_statusField)
		[_statusField setStringValue:_status];
}


@end
