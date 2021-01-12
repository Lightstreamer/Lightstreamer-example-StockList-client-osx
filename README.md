# Lightstreamer - Basic Stock-List Demo - macOS Client

<!-- START DESCRIPTION lightstreamer-example-stocklist-client-macos -->

This project contains an example of an application for Mac that employs the [Lightstreamer macOS Client library](http://www.lightstreamer.com/api/ls-macos-client/latest/).

## Live Demo

[![screenshot](screen_large.png)](http://demos.lightstreamer.com/StockListDemo_OSX/StockList%20Demo%20for%20OS%20X-uni.app.zip)<br>
### [![](http://demos.lightstreamer.com/site/img/play.png) View live demo](http://demos.lightstreamer.com/StockListDemo_OSX/StockList%20Demo%20for%20OS%20X-uni.app.zip)<br>
(download "StockList Demo for OS X-uni.app.zip"; unzip it; launch "StockList Demo for macOS")

### Details

This app, compatible with macOS, is an Objective-C version of the [Stock-List Demos](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-client-javascript).<br>

This app uses the <b>macOS Client API for Lightstreamer</b> to handle the communications with Lightstreamer Server. A simple user interface is implemented to display the real-time data received from Lightstreamer Server.<br>

<!-- END DESCRIPTION lightstreamer-example-stocklist-client-macos -->

## Install

If you want to install a version of this demo pointing to your local Lightstreamer Server, follow these steps:

* Note that, as prerequisite, the [Lightstreamer - Stock- List Demo - Java Adapter](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-adapter-java) has to be deployed on your local Lightstreamer Server instance. Please check out that project and follow the installation instructions provided with it.
* Launch Lightstreamer Server.
* Download the `deploy.zip` file, which you can find in the [deploy release](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-macos/releases) of this project and extract the `StockList Demo for macOS.app` folder.
* Launch "StockList Demo for macOS". The Gatekeeper may signal the app is not signed. You can safely run the app or rebuild it with the included Xcode project.

## Build

To build your own version of the demo, instead of using the one provided in the `deploy.zip` file from the Install section above, open the project with Xcode and it should compile with no errors.

### Deploy

With the current settings, the demo tries to connect to the demo server currently running on Lightstreamer website.<br>
The demo can be reconfigured and recompiled to connect to the local installation of Lightstreamer Server. You just have to change SERVER_URL, as defined in `StockList Demo for macOS/StockListWindowController.m`; a ":port" part can also be added.
The example requires that the [QUOTE_ADAPTER](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-adapter-java) has to be deployed in your local Lightstreamer server instance;
the [LiteralBasedProvider](https://github.com/Lightstreamer/Lightstreamer-example-ReusableMetadata-adapter-java) is also needed, but it is already provided by Lightstreamer server.<br>

## See Also

### Lightstreamer Adapters Needed by This Demo Client

<!-- START RELATED_ENTRIES -->
* [Lightstreamer - Stock-List Demo - Java Adapter](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-adapter-java)
* [Lightstreamer - Reusable Metadata Adapters- Java Adapter](https://github.com/Lightstreamer/Lightstreamer-example-ReusableMetadata-adapter-java)

<!-- END RELATED_ENTRIES -->

### Related Projects

* [Lightstreamer - Stock-List Demos - HTML Clients](https://github.com/Lightstreamer/Lightstreamer-example-Stocklist-client-javascript)
* [Lightstreamer - Basic Stock-List Demo - iOS Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-ios)
* [Lightstreamer - Basic Stock-List Demo - jQuery (jqGrid) Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-jquery)
* [Lightstreamer - Stock-List Demo - Dojo Toolkit Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-dojo)
* [Lightstreamer - Basic Stock-List Demo - Java SE (Swing) Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-java)
* [Lightstreamer - Basic Stock-List Demo - .NET Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-dotnet)
* [Lightstreamer - Stock-List Demos - Flex Clients](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-flex)
* [Lightstreamer - Basic Stock-List Demo - Silverlight Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-silverlight)
* [Lightstreamer - Basic Stock-List Demo - Android Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-android)
* [Lightstreamer - Basic Stock-List Demo - Windows Phone Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-winphone)
* [Lightstreamer - Basic Stock-List and Round-Trip Demo - BlackBerry Client](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-blackberry)

## Lightstreamer Compatibility Notes

* Code compatible with Lightstreamer macOS Client Library version 4.0.0 or newer.
* For Lightstreamer Server version 7.0 or greater. Ensure that macOS Client API is supported by Lightstreamer Server license configuration.
* For a version of this example compatible with Lightstreamer macOS Client API version 2.x up to 4.2.1, please refer to [this tag](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-osx/tree/latest-for-cocoapods).
* For a version of this example compatible with Lightstreamer macOS Client API version 1.x, please refer to [this tag](https://github.com/Lightstreamer/Lightstreamer-example-StockList-client-osx/tree/latest-for-client-1.x).
