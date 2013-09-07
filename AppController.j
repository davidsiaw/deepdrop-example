/*
 * AppController.j
 * Deep Drop Example
 *
 * Created by You on August 28, 2013.
 * Copyright 2013, Your Company All rights reserved.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>
@import <DeepDrop/DCFileDropController.j>
@import <DeepDrop/DCFileUploadManager.j>
@import <DeepDrop/DCFileUploadsView.j>

@implementation AppController : CPObject
{
	var dropView;
	var uploadTable;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    var theWindow = [[CPWindow alloc]
                        initWithContentRect:CGRectMakeZero()
                        styleMask:CPBorderlessBridgeWindowMask | CPTexturedBackgroundWindowMask];
    var contentView = [theWindow contentView];

    [theWindow orderFront:self];

  	var bounds = [contentView bounds];

	// ==========================
	//  Drag Drop Upload
	// ==========================

	// drop view: This is where we can drop images
	dropView = [[CPImageView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
	[dropView setImage:[[CPImage alloc] initWithContentsOfFile:[[CPBundle mainBundle] pathForResource:@"upload.png"] size:CPSizeMake(200, 200)]];
	[contentView addSubview:dropView];

	// The upload manager helps us keep track of all the files uploaded so far
	var uploadManager = [[DCFileUploadManager alloc] init];

	// This controller will handle our uploads for us using the upload manager
	var fileDropUploadController = [[DCFileDropController alloc]
		initWithView:dropView
		dropDelegate:self
		uploadURL:[CPURL URLWithString:@"upload.php"]
		uploadManager:uploadManager];
	[fileDropUploadController setEnabled:YES];


	// ==========================
	//  Upload Information
	// ==========================

	// This panel will show us the uploads we have made and their status
	var uploadsPanel = [[CPPanel alloc] initWithContentRect:CGRectMake(400.0, 50.0, 250.0, 300.0)
										styleMask: CPClosableWindowMask | CPResizableWindowMask];

	[uploadsPanel setTitle:"Uploads"];

	// We have a very simple upload list that we add to the panel.
	var uploadsPanelContentView = [uploadsPanel contentView];

	uploadTable = [[DCFileUploadsView alloc] initWithFrame:[uploadsPanelContentView bounds]];

	// The upload manager has a list of file uploads that we can use to see
	[uploadTable setUploadList:[uploadManager fileUploads]]

	[[uploadsPanel contentView] addSubview: uploadTable];
	[uploadsPanel orderFront:self];

	// set up this class to receive the events
	[uploadManager setDelegate:self];


	// ==========================
	//  Cosmetic
	// ==========================

	// Explanation text box
	var descriptionLabel = [[CPTextField alloc] initWithFrame:CGRectMake(30, 300, 350, 50)];
	[descriptionLabel setStringValue:@"Drag any file(s) (less than 1 MB) to the square above.  This currently works in Safari and Chrome.  Firefox support is possible, but not implemented."];
	[descriptionLabel setFont:[CPFont systemFontOfSize:12.0]];
	[descriptionLabel setLineBreakMode:CPLineBreakByWordWrapping];
	[contentView addSubview:descriptionLabel];


	// link to github
	var button = [CPButton buttonWithTitle:"See code on GitHub"];
	[button setFrameOrigin:CGPointMake(50, 380)];
	[button setTarget:self];
	[button setAction:@selector(gitHubAction)];
	[contentView addSubview:button];
}

- (void)fileDropUploadController:(DCFileDropController)theController setState:(BOOL)visible
{
	if (visible) {
		[theController.view setBackgroundColor:[CPColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.2]];
	} else {
		[theController.view setBackgroundColor:[CPColor clearColor]];
	}
}

- (void)fileUploadManagerDidChange:(DCFileUploadManager)theManager
{
	[uploadTable reloadData];
}

// When the upload is complete we load the file out!
- (void)fileUploadManager:(DCFileUploadManager)theManager uploadDidFinish:(DCFileUpload)theFileUpload
{
	[dropView setImage:[[CPImage alloc]
	 initWithContentsOfFile:"Content/Uploads/" + [theFileUpload name] size:CPSizeMake(200, 200)]];
}

- (void)gitHubAction {
	window.location = "https://github.com/davidsiaw/deepdrop";
}


@end
