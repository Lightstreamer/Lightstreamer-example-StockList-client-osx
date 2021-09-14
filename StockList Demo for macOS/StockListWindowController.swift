//  Converted to Swift 5.4 by Swiftify v5.4.25812 - https://swiftify.com/
//
//  StockListWindowController.swift
//  StockList Demo for macOS
//
// Copyright (c) Lightstreamer Srl
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

import Cocoa

class StockListWindowController: NSWindowController, LSClientDelegate, LSSubscriptionDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet var stockListWindow: NSWindow!
    @IBOutlet var stockListTable: NSTableView!
    @IBOutlet var statusField: NSTextField!
    private var infoDrawer: NSDrawer?
    private var itemNames: [AnyHashable]?
    private var fieldNames: [AnyHashable]?
    private var client: LSLightstreamerClient?
    private var subscription: LSSubscription?
    private var itemUpdated: [AnyHashable : Any]?
    private var itemData: [AnyHashable : Any]?
    private var rowsToBeReloaded: Set<AnyHashable>?

    // MARK: -
    // MARK: Initialization

    override init() {
        super.init(windowNibName: "StockListWindow")
        // Initialization
        itemNames = [ITEMS]
        fieldNames = [FIELDS]

        itemData = [AnyHashable : Any](minimumCapacity: NUMBER_OF_ITEMS)
        itemUpdated = [AnyHashable : Any](minimumCapacity: NUMBER_OF_ITEMS)

        rowsToBeReloaded = Set<AnyHashable>() // capacity: NUMBER_OF_ITEMS
    }

    // MARK: -
    // MARK: Window life cycle

    override func windowDidLoad() {

        // Disable close window button (setting on xib is not effective)
        let closeButton = stockListWindow.standardWindowButton(.closeButton)
        closeButton?.isEnabled = false

        // Change aspect of +/- column (setting on xib is not effective)
        let imageCell = NSImageCell()

        let dirColumn = stockListTable.tableColumn(withIdentifier: NSUserInterfaceItemIdentifier("3"))
        dirColumn?.dataCell = imageCell

        // Change aspect of table (setting on xib is not effective)
        stockListTable.usesAlternatingRowBackgroundColors = true

        // Compute height of title bar
        let outerFrame = stockListWindow.contentView?.superview?.frame
        let innerFrame = stockListWindow.contentView?.frame

        let heightOfTitleBar = Float((outerFrame?.size.height ?? 0.0) - (innerFrame?.size.height ?? 0.0))

        // Add title bar button for info drawer
        let infoButton = NSButton(frame: CGRect(x: 0.0, y: 0.0, width: 28.0, height: 28.0))
        infoButton.setButtonType(NSOnOffButton)
        infoButton.bezelStyle = .recessed
        infoButton.font = NSFont.titleBarFont(ofSize: 13.0)
        infoButton.image = NSImage(named: "S-logo")
        infoButton.target = self
        infoButton.action = #selector(infoButtonClicked)

        let x: Float = 765.0
        infoButton.frame = NSRect(x: CGFloat(x), y: stockListWindow.contentView?.frame.size.height ?? 0.0, width: infoButton.frame.size.width, height: CGFloat(heightOfTitleBar))

        var mask = 0
        if CGFloat(x) > stockListWindow.frame.size.width / 2.0 {
            mask |= NSView.AutoresizingMask.minXMargin.rawValue
        } else {
            mask |= NSView.AutoresizingMask.maxXMargin.rawValue
        }

        if let margin = NSView.AutoresizingMask(rawValue: mask | NSView.AutoresizingMask.minYMargin.rawValue) {
            infoButton.autoresizingMask = margin
        }

        let accessoryController = NSTitlebarAccessoryViewController()
        accessoryController.layoutAttribute = .right
        accessoryController.view = infoButton

        stockListWindow.addTitlebarAccessoryViewController(accessoryController)

        // Update status text
        updateStatus()

        // Connect with Lightstreamer
        perform(#selector(connectToLightstreamer), with: nil, afterDelay: 1.0)
    }

    // MARK: -
    // MARK: NSTableViewDataSource methods

    func numberOfRows(in aTableView: NSTableView) -> Int {
        return NUMBER_OF_ITEMS
    }

    func tableView(_ aTableView: NSTableView, objectValueFor aTableColumn: NSTableColumn?, row rowIndex: Int) -> Any? {
        var item: [AnyHashable : Any]? = nil
        var itemUpdated: [AnyHashable : Any]? = nil

        let lockQueue = DispatchQueue(label: "itemData")
        lockQueue.sync {
            item = itemData?[NSNumber(value: rowIndex)] as? [AnyHashable : Any]
            itemUpdated = self.itemUpdated?[NSNumber(value: rowIndex)] as? [AnyHashable : Any]

            if item == nil || itemUpdated == nil {
                return nil
            }
        }

        if let item = item {
            switch (aTableColumn?.identifier as? NSNumber).intValue ?? 0 {
            case 0:
                return item["stock_name"]
            case 1:
                return item["last_price"]
            case 2:
                return item["time"]
            case 3:
                let pctChange = (item["pct_change"] as? NSNumber)?.doubleValue ?? 0.0
                if pctChange > 0.0 {
                    return NSImage(named: "Arrow-up")
                } else if pctChange < 0.0 {
                    return NSImage(named: "Arrow-down")
                } else {
                    return nil
                }
            case 4:
                if let object = item["pct_change"] {
                    return String(format: "%@%%", object)
                }
                return nil
            case 5:
                return item["bid"]
            case 6:
                return item["ask"]
            case 7:
                return item["min"]
            case 8:
                return item["max"]
            case 9:
                return item["ref_price"]
            case 10:
                return item["open_price"]
            default:
                break
            }
        }

        return nil
    }

    // MARK: -
    // MARK: Info button action

    @objc func infoButtonClicked() {
        if infoDrawer == nil {

            // Yes, I know drawers are deprecated, but this is a Lightstreamer demo, not an AppKit demo,
            // and here this UI control comes in very handy. So, please bear with us.
            if let edge = NSRectEdge(rawValue: 3) {
                infoDrawer = NSDrawer(contentSize: CGSize(width: INFO_WIDTH, height: INFO_HEIGHT), preferredEdge: edge)
            }
            infoDrawer?.parentWindow = stockListWindow

            var views: [AnyHashable]? = nil
            Bundle.main.loadNibNamed("InfoDrawerView", owner: self, topLevelObjects: &views)

            // Find the view (order of top level objects may be scrambled)
            var drawerView = views?[0]
            if !(drawerView is NSView) {
                drawerView = views?[1]
            }

            infoDrawer?.contentView = drawerView as? NSView

            // Ensure status text is up to date
            updateStatus()
        }

        infoDrawer?.toggle(self)
    }

    // MARK: -
    // MARK: NSTableViewDelegate methods

    func tableView(_ aTableView: NSTableView, willDisplayCell aCell: Any, for aTableColumn: NSTableColumn?, row rowIndex: Int) {
        var item: [AnyHashable : Any]? = nil
        var itemUpdated: [AnyHashable : Any]? = nil

        let lockQueue = DispatchQueue(label: "itemData")
        lockQueue.sync {
            item = itemData?[NSNumber(value: rowIndex)] as? [AnyHashable : Any]
            itemUpdated = self.itemUpdated?[NSNumber(value: rowIndex)] as? [AnyHashable : Any]

            if item == nil || itemUpdated == nil {
                return
            }
        }

        let cell = aCell as? NSTextFieldCell
        switch (aTableColumn?.identifier as? NSNumber).intValue ?? 0 {
        case 3:
            // Cell is not a NSTextFieldCell, leave the color as it is
            break
        case 4:
            let value = cell?.doubleValue ?? 0.0
            cell?.textColor = (value >= 0.0) ? DK_GREEN_COLOR : RED_COLOR

            // No "break", continue with highlight code
        default:
            let fields = [FIELDS]
            let field = fields[(aTableColumn?.identifier as? NSNumber).intValue ?? 0] as? String
            let updated = (itemUpdated?[field ?? ""] as? NSNumber)?.boolValue ?? false

            if updated {
                let colorName = item?["color"] as? String
                var color: NSColor? = nil
                if colorName == "green" {
                    color = GREEN_COLOR
                } else if colorName == "orange" {
                    color = ORANGE_COLOR
                }

                cell?.drawsBackground = true
                cell?.backgroundColor = color
            } else {
                cell?.drawsBackground = false
            }
        }
    }

    // MARK: -
    // MARK: Lighstreamer management

    @objc func connectToLightstreamer() {
        client = LSLightstreamerClient(serverAddress: PUSH_SERVER_URL, adapterSet: ADAPTER_SET)

        print("StockListViewController: Connecting to Lightstreamer...")

        client?.addDelegate(self)
        client?.connect()
    }

    func subscribeItems() {
        print("StockListWindowController: Subscribing table...")

        subscription = LSSubscription(subscriptionMode: "MERGE", items: itemNames, fields: fieldNames)
        subscription?.dataAdapter = DATA_ADAPTER
        subscription?.requestedSnapshot = "yes"
        subscription?.requestedMaxFrequency = "1.0"

        subscription?.addDelegate(self)
        client?.subscribe(subscription)

        print("StockListWindowController: Table subscribed")
    }

    // MARK: -
    // MARK: Methods of LSClientDelegate

    func client(_ client: LSLightstreamerClient, didChangeProperty property: String) {
        print("StockListWindowController: Client property changed: \(property)")
    }

    func client(_ client: LSLightstreamerClient, didChangeStatus status: String) {
        print("StockListWindowController: Client status changed: \(status)")

        // Update status text on main thread
        performSelector(onMainThread: #selector(updateStatus), with: nil, waitUntilDone: false)

        if status.hasPrefix("CONNECTED:") {

            // We subscribe, if not already subscribed. The LSClient will reconnect automatically
            // in most of the cases, so we don't need to resubscribe each time.
            if subscription == nil {
                subscribeItems()
            }
        } else if status == "DISCONNECTED" {

            // In this case the session has been closed by the server, the client
            // will not automatically reconnect. Let's prepare for a new connection.
            subscription = nil

            perform(#selector(connectToLightstreamer), with: nil, afterDelay: 1.0)
        }
    }

    func client(_ client: LSLightstreamerClient, didReceiveServerError errorCode: Int, withMessage errorMessage: String) {
        print(String(format: "StockListWindowController: Client received server error: %ld - %@", errorCode, errorMessage))

        // Update status text on main thread
        performSelector(onMainThread: #selector(updateStatus), with: nil, waitUntilDone: false)
    }

    // MARK: -
    // MARK: Methods of LSSubscriptionDelegate

    func subscription(_ subscription: LSSubscription, didUpdateItem itemUpdate: LSItemUpdate) {
        let itemPosition = itemUpdate.itemPos
        var item: [AnyHashable : Any]? = nil
        var itemUpdated: [AnyHashable : Any]? = nil

        let lockQueue = DispatchQueue(label: "itemData")
        lockQueue.sync {
            item = itemData?[NSNumber(value: UInt((itemPosition - 1)))] as? [AnyHashable : Any]
            if item == nil {
                item = [AnyHashable : Any](minimumCapacity: NUMBER_OF_FIELDS)
                itemData?[NSNumber(value: UInt((itemPosition - 1)))] = item
            }

            itemUpdated = self.itemUpdated?[NSNumber(value: UInt((itemPosition - 1)))] as? [AnyHashable : Any]
            if itemUpdated == nil {
                itemUpdated = [AnyHashable : Any](minimumCapacity: NUMBER_OF_FIELDS)
                self.itemUpdated?[NSNumber(value: UInt((itemPosition - 1)))] = itemUpdated
            }
        }

        var previousLastPrice = 0.0
        for fieldName in fieldNames ?? [] {
            guard let fieldName = fieldName as? String else {
                continue
            }
            let value = itemUpdate.value(withFieldName: fieldName)

            // Save previous last price to choose blick color later
            if fieldName == "last_price" {
                previousLastPrice = (item?[fieldName] as? NSNumber)?.doubleValue ?? 0.0
            }

            if value != "" {
                item?[fieldName] = value
            } else {
                item?[fieldName] = NSNull()
            }

            if itemUpdate.isValueChanged(withFieldName: fieldName) {
                itemUpdated?[fieldName] = NSNumber(value: true)
            }
        }

        // Check variation and store appropriate color
        let currentLastPrice = itemUpdate.value(withFieldName: "last_price").doubleValue
        if currentLastPrice >= previousLastPrice {
            item?["color"] = "green"
        } else {
            item?["color"] = "orange"
        }

        let lockQueue = DispatchQueue(label: "rowsToBeReloaded")
        lockQueue.sync {
            rowsToBeReloaded?.insert(NSNumber(value: UInt((itemPosition - 1))))
        }

        performSelector(onMainThread: #selector(reloadTableRows), with: nil, waitUntilDone: false)
    }

    // MARK: -
    // MARK: Internals

    @objc func reloadTableRows() {
        var rowsToBeReloaded: Set<AnyHashable>? = nil

        let lockQueue = DispatchQueue(label: "self.rowsToBeReloaded")
        lockQueue.sync {
            rowsToBeReloaded = Set<AnyHashable>() + self.rowsToBeReloaded
            self.rowsToBeReloaded?.removeAll()
        }

        let indexSet = NSMutableIndexSet()
        for index in rowsToBeReloaded ?? [] {
            guard let index = index as? NSNumber else {
                continue
            }
            indexSet.add(index.intValue)
        }

        // Reload related table cells, willDisplayCell event will do highlighting
        stockListTable.reloadData(forRowIndexes: indexSet as IndexSet, columnIndexes: NSIndexSet(indexesIn: NSRange(location: 0, length: NUMBER_OF_FIELDS)) as IndexSet)

        perform(Selector("unhighlight:"), with: rowsToBeReloaded, afterDelay: FLASH_DURATION)
    }

    @objc func unhighlight(_ rowsToBeUnhighlighted: Set<AnyHashable>?) {
        let fields = [FIELDS]

        for index in rowsToBeUnhighlighted ?? [] {
            guard let index = index as? NSNumber else {
                continue
            }
            var itemUpdated: [AnyHashable : Any]? = nil

            let lockQueue = DispatchQueue(label: "itemData")
            lockQueue.sync {
                itemUpdated = self.itemUpdated?[index] as? [AnyHashable : Any]
                if itemUpdated == nil {
                    continue
                }
            }

            for i in 0..<NUMBER_OF_FIELDS {
                itemUpdated?[fields[i]] = NSNumber(value: false)
            }
        }

        let indexSet = NSMutableIndexSet()
        for index in rowsToBeUnhighlighted ?? [] {
            guard let index = index as? NSNumber else {
                continue
            }
            indexSet.add(index.intValue)
        }

        // Reload related table cells, willDisplayCell event will do unhighlighting
        stockListTable.reloadData(forRowIndexes: indexSet as IndexSet, columnIndexes: NSIndexSet(indexesIn: NSRange(location: 0, length: NUMBER_OF_FIELDS)) as IndexSet)
    }

    @objc func updateStatus() {

        // Update connection status text
        if client?.status.hasPrefix("DISCONNECTED") ?? false {
            statusField.stringValue = "Not connected"
        } else if client?.status.hasPrefix("CONNECTING") ?? false {
            statusField.stringValue = "Connecting..."
        } else if client?.status.hasPrefix("STALLED") ?? false {
            statusField.stringValue = "Stalled"
        } else if client?.status.hasPrefix("CONNECTED") ?? false && client?.status.hasSuffix("POLLING") ?? false {
            statusField.stringValue = "Connected\nin HTTP polling mode"
        } else if client?.status.hasPrefix("CONNECTED") ?? false && client?.status.hasSuffix("WS-STREAMING") ?? false {
            statusField.stringValue = "Connected\nin WS streaming mode"
        } else if client?.status.hasPrefix("CONNECTED") ?? false && client?.status.hasSuffix("HTTP-STREAMING") ?? false {
            statusField.stringValue = "Connected\nin HTTP streaming mode"
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

#if USE_LOCALHOST

// Configuration for local installation
let PUSH_SERVER_URL = "http://localhost:8080/"
let ADAPTER_SET = "STOCKLISTDEMO"
let DATA_ADAPTER = "STOCKLIST_ADAPTER"

#else

// Configuration for online demo server
let PUSH_SERVER_URL = "https://push.lightstreamer.com"
let ADAPTER_SET = "DEMO"
let DATA_ADAPTER = "QUOTE_ADAPTER"

#endif


// MARK: -
// MARK: StockListWindowController extension
// MARK: -
// MARK: StockListWindowController implementation
