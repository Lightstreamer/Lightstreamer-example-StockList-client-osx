//
//  Utils.swift
//  StockList Demo for macOS
//
//  Created by acarioni on 14/09/21.
//  Copyright © 2021 Weswit. All rights reserved.
//

import Foundation
import Cocoa

let NUMBER_OF_ITEMS = 30
let NUMBER_OF_FIELDS = 11

let ITEMS = [ "item1", "item2", "item3", "item4", "item5", "item6", "item7", "item8", "item9", "item10",
    "item11", "item12", "item13", "item14", "item15", "item16", "item17", "item18", "item19", "item20",
    "item21", "item22", "item23", "item24", "item25", "item26", "item27", "item28", "item29", "item30" ]

let FIELDS = [ "stock_name", "last_price", "time", "item_status", "pct_change", "bid",
    "ask", "min", "max", "ref_price", "open_price" ]

let FLASH_DURATION = 0.1

let GREEN_COLOR = NSColor(deviceRed: 0.5647, green: 0.9294, blue: 0.5373, alpha: 1.0)
let ORANGE_COLOR = NSColor(deviceRed: 0.9843, green: 0.7216, blue: 0.4510, alpha: 1.0)

let DK_GREEN_COLOR = NSColor(deviceRed: 0.0000, green: 0.6000, blue: 0.2000, alpha: 1.0)
let RED_COLOR = NSColor(deviceRed: 1.0000, green: 0.0706, blue: 0.0000, alpha: 1.0)

let INFO_WIDTH = 413.0
let INFO_HEIGHT = 101.0
