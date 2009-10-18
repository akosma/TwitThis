//
//  TwitterClientManager.m
//  TwitThis
//
//  Created by Adrian on 9/11/09.
//  Copyright 2009 akosma software. All rights reserved.
//

#import "TwitterClientManager.h"
#import "TwitterClient.h"
#import "Definitions.h"
#import "SynthesizeSingleton.h"

@interface TwitterClientManager (Private)
- (void)initializeClients;
@end


@implementation TwitterClientManager

@synthesize currentClient = _currentClient;

SYNTHESIZE_SINGLETON_FOR_CLASS(TwitterClientManager)

#pragma mark -
#pragma mark Init and dealloc

- (id)init
{
    if (self = [super init])
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *value = [defaults stringForKey:TWITTER_CLIENT_KEY];
        NSString *currentClientOption = TWITTER_CLIENT_CODE_NONE;
        if (value == nil)
        {
            [defaults setObject:TWITTER_CLIENT_CODE_NONE forKey:TWITTER_CLIENT_KEY];
        }
        else
        {
            currentClientOption = value;
        }

        [self initializeClients];
        _currentClient = [_supportedClients objectForKey:currentClientOption];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -
#pragma mark Public methods

- (NSArray *)supportedClients
{
    NSArray *clients = [_supportedClients allValues];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (TwitterClient *client in clients)
    {
        if (client.name != nil)
        {
            [returnArray addObject:client];
        }
    }
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *descriptors = [[NSArray alloc] initWithObjects:descriptor, nil];
    [returnArray sortUsingDescriptors:descriptors];
    [descriptors release];
    [descriptor release];
    return [returnArray autorelease];
}

- (NSArray *)availableClients
{
    NSMutableArray *availableClients = [[NSMutableArray alloc] init];
    for (NSString *clientName in _supportedClients)
    {
        TwitterClient *client = [_supportedClients objectForKey:clientName];
        if ([client isAvailable])
        {
            [availableClients addObject:client.name];
        }
    }
    return [availableClients autorelease];
}

- (BOOL)isAnyClientAvailable
{
    NSArray *clients = [self availableClients];
    return [clients count] > 0;
}

- (BOOL)canSendMessage
{
    return [_currentClient isAvailable] && [_currentClient canSendMessage];
}

- (void)send:(NSString *)text
{
    [_currentClient send:text];
}

- (void)setSelectedClientName:(NSString *)name
{
    _currentClient = [_supportedClients objectForKey:name];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:name forKey:TWITTER_CLIENT_KEY];
    [defaults synchronize];
}

#pragma mark -
#pragma mark Private methods

- (void)initializeClients
{
    // Load Twitter clients from the TwitterClients.plist file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TwitterClients" ofType:@"plist"];
    NSArray *clients = [NSArray arrayWithContentsOfFile:path];

    // Populate the array with the clients
    TwitterClient *none = [[TwitterClient alloc] init];
    _supportedClients = [[NSMutableDictionary alloc] init];
    [_supportedClients setObject:none forKey:TWITTER_CLIENT_CODE_NONE];
    [none release];
    
    for (NSDictionary *dict in clients)
    {
        NSString *name = [dict objectForKey:@"name"];
        TwitterClient *client = [[TwitterClient alloc] initWithDictionary:dict];
        [_supportedClients setObject:client forKey:name];
        [client release];
    }
}

@end
