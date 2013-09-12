//
//  StockListWindowController.h
//  StockList Demo for OS X
//
//  Created by Gianluca Bertani on 25/06/13.
//  Copyright 2013 Weswit Srl
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
// 
//  http://www.apache.org/licenses/LICENSE-2.0
// 
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Cocoa/Cocoa.h>


@interface StockListWindowController : NSWindowController <LSConnectionDelegate, LSTableDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate> {
	IBOutlet NSWindow *_stockListWindow;
	IBOutlet NSTableView *_stockListTable;
	IBOutlet NSTextField *_statusField;
	
	NSDrawer *_infoDrawer;
	
	NSArray *_itemNames;
	NSArray *_fieldNames;
	
	LSClient *_client;
	LSSubscribedTableKey *_tableKey;
	
	NSMutableDictionary *_itemUpdated;
	NSMutableDictionary *_itemData;
	
	NSMutableSet *_rowsToBeReloaded;
	
	BOOL _connected;
	BOOL _polling;
	BOOL _stalled;
	NSString *_status;
}


@end
