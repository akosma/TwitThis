//
//  TwitThisAppDelegate.m
//  TwitThis
//
//  Created by Adrian on 9/11/09.
//  Copyright akosma software 2009. All rights reserved.
//

#import "TwitThisAppDelegate.h"
#import "TwitThisViewController.h"

@implementation TwitThisAppDelegate

- (void)applicationDidFinishLaunching:(UIApplication *)application 
{
    [_window addSubview:_viewController.view];
    [_window makeKeyAndVisible];
}

- (void)dealloc 
{
    [_viewController release];
    [_window release];
    [super dealloc];
}

@end
