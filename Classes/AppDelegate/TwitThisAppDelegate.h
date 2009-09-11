//
//  TwitThisAppDelegate.h
//  TwitThis
//
//  Created by Adrian on 9/11/09.
//  Copyright akosma software 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwitThisViewController;

@interface TwitThisAppDelegate : NSObject <UIApplicationDelegate> 
{
@private
    IBOutlet UIWindow *_window;
    IBOutlet TwitThisViewController *_viewController;
}

@end

