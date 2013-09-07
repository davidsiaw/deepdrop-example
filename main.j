/*
 * AppController.j
 * Deep Drop Example
 *
 * Created by You on August 28, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

@import "AppController.j"

function main(args, namedArgs)
{
	window.setTimeout = window.setNativeTimeout;
    CPApplicationMain(args, namedArgs);
}
