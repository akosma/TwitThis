//
//  TwitterClientManager.h
//  TwitThis
//
//  Created by Adrian on 9/11/09.
//  Copyright 2009 akosma software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TwitterClient;

@interface TwitterClientManager : NSObject
{
@private
    TwitterClient *_currentClient;
    NSMutableDictionary *_supportedClients;
}

@property (nonatomic, readonly) TwitterClient *currentClient;

+ (TwitterClientManager *)sharedTwitterClientManager;
- (void)send:(NSString *)text;
- (NSArray *)availableClients;
- (NSArray *)supportedClients;
- (BOOL)isAnyClientAvailable;
- (BOOL)canSendMessage;
- (void)setSelectedClientName:(NSString *)name;

@end
