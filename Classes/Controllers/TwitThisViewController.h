//
//  TwitThisViewController.h
//  TwitThis
//
//  Created by Adrian on 9/11/09.
//  Copyright 2009 akosma software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwitterClientManager;

@interface TwitThisViewController : UITableViewController <UIActionSheetDelegate>
{
@private
    NSArray *_clients;
    TwitterClientManager *_clientManager;
}

@end
