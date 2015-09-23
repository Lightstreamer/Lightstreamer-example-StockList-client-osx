# Lightstreamer - Basic Stock-List Demo - OS X Client

<!-- START DESCRIPTION lightstreamer-example-stocklist-client-osx -->

This project contains an example of an application for Mac that employs the [Lightstreamer OS X Client library](http://www.lightstreamer.com/docs/client_os_x_api/index.html).

## Live Demo

[![screenshot](screen_large.png)](http://demos.lightstreamer.com/StockListDemo_OSX/StockList Demo for OS X-uni.app.zip)<br>
###[![](http://demos.lightstreamer.com/site/img/play.png) View live demo](http://demos.lightstreamer.com/StockListDemo_OSX/StockList Demo for OS X-uni.app.zip)<br>
(download "StockList Demo for OS X-uni.app.zip"; unzip it; launch "StockList Demo for OS X")

### Details

The example demonstrates a simple stock list application fed through a Lightstreamer connection.<br>
The example is comprised of the following files and folders:
- <b>"StockList Demo for OS X"</b>: sources to build the application, written in Objective-C.
- <b>"Lightstreamer client for OS X"</b> (/lib and /include): should contain Lightstreamer library, to be used for the build process.
- <b>"StockList Demo for OS X.xcodeproj"</b>: a full Xcode project specification, ready for a compilation of the demo sources.

<!-- END DESCRIPTION lightstreamer-example-stocklist-client-osx -->

## Install

If you want to install a version of this demo pointing to your local Lightstreamer Server, follow these steps:

* Note that, as prerequisite, the [Lightstreamer - Stock- List Demo - Java Adapter](https://github.com/Weswit/Lightstreamer-example-Stocklist-adapter-java) has to be deployed on your local Lightstreamer Server instance. Please check out that project and follow the installation instructions provided with it.
* Launch Lightstreamer Server.
* Download the `deploy.zip` file, which you can find in the [deploy release](https://github.com/Weswit/Lightstreamer-example-StockList-client-osx/releases) of this project and extract the `StockList Demo for OS X.app` folder.
* Launch "StockList Demo for OS X". Under OS X 10.8 or newer, the Gatekeeper may signal the app is not signed. You can safely run the app or rebuild it with the included Xcode project.

## Build

To build your own version of the demo, instead of using the one provided in the `deploy.zip` file from the Install section above, you need to install CocoaPods to handle the project dependency on the Lightstreamer OS X client library. Follow these steps:

* open a terminal and run the following command:

```sh
$ sudo gem install cocoapods
```

* `cd` into the directory where you downloaded this project and run the following command:

```sh
$ pod install
```

* CocoaPods should now resolve the dependency on the Lightstreamer OS X client library and prepare a workspace for you.

Done this, open the workspace with Xcode and it should compile with no errors. In case of errors during dependency resolution, you can find more information on [CocoaPods official website](https://cocoapods.org).

### Deploy

With the current settings, the demo tries to connect to the demo server currently running on Lightstreamer website.<br>
The demo can be reconfigured and recompiled to connect to the local installation of Lightstreamer Server. You just have to change SERVER_URL, as defined in `StockList Demo for OS X/StockListWindowController.m`; a ":port" part can also be added.
The example requires that the [QUOTE_ADAPTER](https://github.com/Weswit/Lightstreamer-example-Stocklist-adapter-java) has to be deployed in your local Lightstreamer server instance;
the [LiteralBasedProvider](https://github.com/Weswit/Lightstreamer-example-ReusableMetadata-adapter-java) is also needed, but it is already provided by Lightstreamer server.<br>

## See Also

### Lightstreamer Adapters Needed by This Demo Client

<!-- START RELATED_ENTRIES -->
* [Lightstreamer - Stock-List Demo - Java Adapter](https://github.com/Weswit/Lightstreamer-example-Stocklist-adapter-java)
* [Lightstreamer - Reusable Metadata Adapters- Java Adapter](https://github.com/Weswit/Lightstreamer-example-ReusableMetadata-adapter-java)

<!-- END RELATED_ENTRIES -->

### Related Projects

* [Lightstreamer - Stock-List Demos - HTML Clients](https://github.com/Weswit/Lightstreamer-example-Stocklist-client-javascript)
* [Lightstreamer - Basic Stock-List Demo - iOS Client](https://github.com/Weswit/Lightstreamer-example-StockList-client-ios)
* [Lightstreamer - Basic Stock-List Demo - jQuery (jqGrid) Client](https://github.com/Weswit/Lightstreamer-example-StockList-client-jquery)
* [Lightstreamer - Stock-List Demo - Dojo Toolkit Client](https://github.com/Weswit/Lightstreamer-example-StockList-client-dojo)
* [Lightstreamer - Basic Stock-List Demo - Java SE (Swing) Client](https://github.com/Weswit/Lightstreamer-example-StockList-client-java)
* [Lightstreamer - Basic Stock-List Demo - .NET Client](https://github.com/Weswit/Lightstreamer-example-StockList-client-dotnet)
* [Lightstreamer - Stock-List Demos - Flex Clients](https://github.com/Weswit/Lightstreamer-example-StockList-client-flex)
* [Lightstreamer - Basic Stock-List Demo - Silverlight Client](https://github.com/Weswit/Lightstreamer-example-StockList-client-silverlight)
* [Lightstreamer - Basic Stock-List Demo - Android Client](https://github.com/Weswit/Lightstreamer-example-StockList-client-android)
* [Lightstreamer - Basic Stock-List Demo - Windows Phone Client](https://github.com/Weswit/Lightstreamer-example-StockList-client-winphone)
* [Lightstreamer - Basic Stock-List and Round-Trip Demo - BlackBerry Client](https://github.com/Weswit/Lightstreamer-example-StockList-client-blackberry)

## Lightstreamer Compatibility Notes

* Compatible with Lightstreamer OS X Client Library version 2.0.0-a1 or newer.
* For Lightstreamer Allegro (+ OS X Client API support), Presto, Vivace.
* For a version of this example compatible with Lightstreamer OS X Client API version 1.x, please refer to [this tag](https://github.com/Weswit/Lightstreamer-example-StockList-client-osx/tree/latest-for-client-1.x).
