//  Converted to Swift 5.4 by Swiftify v5.4.25812 - https://swiftify.com/
//
//  AppDelegate.swift
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

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var window: StockListWindowController?

    // MARK: -
    // MARK: Initialization

    override init() {
        super.init()
            // Nothing to do
    }

    // MARK: -
    // MARK: NSApplicationDelegate methods

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // Open window
        window = StockListWindowController()
        window?.showWindow(nil)
    }
}