//
//  TwitterClient.m
//  TwitThis
//
//  Created by Adrian on 9/11/09.
//  Copyright 2009 akosma software. All rights reserved.
//

#import "TwitterClient.h"

@implementation TwitterClient

@synthesize urlTemplate = _urlTemplate;
@synthesize name = _name;

#pragma mark -
#pragma mark Init and dealloc

- (id)init
{
    if (self = [super init])
    {
        _urlTemplate = nil;
        _name = nil;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [self init])
    {
        _urlTemplate = [[dict objectForKey:@"template"] copy];
        _name = [[dict objectForKey:@"name"] copy];
    }
    return self;
}

- (void)dealloc
{
    [_urlTemplate release];
    [_name release];
    [super dealloc];
}

#pragma mark -
#pragma mark Public methods

- (BOOL)isAvailable
{
    if (_name == nil)
    {
        return NO;
    }
    NSString *stringURL = [NSString stringWithFormat:_urlTemplate, @"test"];
    NSURL *url = [NSURL URLWithString:stringURL];
    return [[UIApplication sharedApplication] canOpenURL:url];
}

- (BOOL)canSendMessage
{
    return (_name != nil);
}

- (void)send:(NSString *)text
{
    if (_name != nil)
    {
        NSString *message = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                                (CFStringRef)text,
                                                                                NULL, 
                                                                                (CFStringRef)@";/?:@&=+$,", 
                                                                                kCFStringEncodingUTF8);
        
        NSString *stringURL = [NSString stringWithFormat:_urlTemplate, message];
        [message release];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];    
    }
}

@end
