# Lightstreamer StockList Demo Client for OS X #

This project contains an example of an application for Mac that employs the Lightstreamer OS X Client library.

The example demonstrates a simple stock list application fed through a Lightstreamer connection.
<br>

The example is comprised of the following files and folders:
- <b>"StockList Demo for OS X"</b>: sources to build the application, written in Objective-C.
- <b>"Lightstreamer client for OS X"</b> (/lib and /include): should contain Lightstreamer library, to be used for the build process.
- <b>"StockList Demo for OS X.xcodeproj"</b>: a full Xcode project specification, ready for a compilation of the demo sources.

# Build #

Binaries for the application are provided as a zip file in the [latest release](https://github.com/Weswit/Lightstreamer-example-StockList-client-osx/releases) of this project. Under OS X 10.8 or newer, the Gatekeeper may signal the app is not signed. You can safely run the app or rebuild it with the included Xcode project.
<br>
Before you can build this demo you should complete this project with the Lighstreamer iOS Client library. Please:
* drop into the "Lightstreamer client for OS X/lib" folder of this project the libLightstreamer_OSX_client.a file from the "/DOCS-SDKs/sdk_client_os_x/lib" of [latest Lightstreamer distribution](http://www.lightstreamer.com/download).
* drop into the "Lightstreamer client for OS X/include" folder of this project all the include files from the "/DOCS-SDKs/sdk_client_os_x/include" of [latest Lightstreamer distribution](http://www.lightstreamer.com/download).

# Deploy #

With the current settings, the demo tries to connect to the demo server currently running on Lightstreamer website.<br>
The demo can be reconfigured and recompiled in order to connect to the local installation of Lightstreamer Server. You just have to change SERVER_URL, as defined in "StockList Demo for OS X/StockListWindowController.m"; a ":port" part can also be added.
The example requires that the [QUOTE_ADAPTER](https://github.com/Weswit/Lightstreamer-example-Stocklist-adapter-java) and [LiteralBasedProvider](https://github.com/Weswit/Lightstreamer-example-ReusableMetadata-adapter-java) have to be deployed in your local Lightstreamer server instance. The factory configuration of Lightstreamer server already provides this adapter deployed.<br>

# See Also #

## Lightstreamer Adapters needed by this demo client ##

* [Lightstreamer StockList Demo Adapter](https://github.com/Weswit/Lightstreamer-example-Stocklist-adapter-java)
* [Lightstreamer Reusable Metadata Adapter in Java](https://github.com/Weswit/Lightstreamer-example-ReusableMetadata-adapter-java)

## Similar demo clients that may interest you ##

* [Lightstreamer StockList Demo Client for JavaScript](https://github.com/Weswit/Lightstreamer-example-Stocklist-client-javascript)
* [Lightstreamer StockList Demo Client for iOS](https://github.com/Weswit/Lightstreamer-example-StockList-client-ios)
* [Lightstreamer StockList Demo Client for Android](https://github.com/Weswit/Lightstreamer-example-StockList-client-android)
* [Lightstreamer StockList Demo Client for Microsoft Windows Phone](https://github.com/Weswit/Lightstreamer-example-StockList-client-winphone)
* [Lightstreamer StockList Demo Client for BlackBerry](https://github.com/Weswit/Lightstreamer-example-StockList-client-blackberry)
* [Lightstreamer StockList Demo Client for jQuery](https://github.com/Weswit/Lightstreamer-example-StockList-client-jquery)
* [Lightstreamer StockList Demo Client for Dojo](https://github.com/Weswit/Lightstreamer-example-StockList-client-dojo)
* [Lightstreamer StockList Demo Client for Java .NET](https://github.com/Weswit/Lightstreamer-example-StockList-client-dotnet)
* [Lightstreamer Portfolio Demo Client for Adobe Flex SDK](https://github.com/Weswit/Lightstreamer-example-Portfolio-client-flex)

# Lightstreamer Compatibility Notes #

- Compatible with Lightstreamer OS X Client Library version 1.0.0 or newer.
- For Lightstreamer Allegro+, Presto, Vivace.
