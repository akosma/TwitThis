//
//  TwitterClient.h
//  TwitThis
//
//  Created by Adrian on 9/11/09.
//  Copyright 2009 akosma software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterClient : NSObject 
{
@private
    NSString *_urlTemplate;
    NSString *_name;
}

@property (nonatomic, readonly) NSString *urlTemplate;
@property (nonatomic, readonly) NSString *name;

- (id)initWithDictionary:(NSDictionary *)dict;
- (BOOL)isAvailable;
- (BOOL)canSendMessage;
- (void)send:(NSString *)text;

@end
