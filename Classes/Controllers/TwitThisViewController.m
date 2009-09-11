//
//  TwitThisViewController.m
//  TwitThis
//
//  Created by Adrian on 9/11/09.
//  Copyright 2009 akosma software. All rights reserved.
//

#import "TwitThisViewController.h"
#import "TwitterClientManager.h"
#import "TwitterClient.h"

@implementation TwitThisViewController

- (void)dealloc 
{
    [_clients release];
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    _clientManager = [TwitterClientManager sharedTwitterClientManager];
    _clients = [[_clientManager supportedClients] retain];
    self.tableView.scrollEnabled = NO;
}

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0)
    {
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        [_clientManager setSelectedClientName:buttonTitle];

        TwitterClient *client = _clientManager.currentClient;
        NSString *message = [NSString stringWithFormat:@"This message was sent from TwitThis by akosma software using %@", client.name];
        [_clientManager send:message];
    }
}

#pragma mark -
#pragma mark UITableViewDelegate and UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 60.0;
    }
    return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    if (section == 0)
    {
        return [_clients count];
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Supported Twitter Clients";
    }
    return @"Current Twitter Client";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 1)
    {
        return @"You can also change the value of your current Twitter client in the Settings application.";
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0)
    {
        TwitterClient *client = [_clients objectAtIndex:indexPath.row];
        static NSString *cellIdentifier = @"TwitterClientCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                           reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.textLabel.text = client.name;
        if ([client isAvailable])
        {
            cell.detailTextLabel.text = @"Available";
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else 
        {
            cell.detailTextLabel.text = @"Not available";
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", client.name]];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *anotherIdentifier = @"AnotherIdentifier";
        cell = [tableView dequeueReusableCellWithIdentifier:anotherIdentifier];
        if (cell == nil) 
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:anotherIdentifier] autorelease];
        }
        if (_clientManager.currentClient.name == nil)
        {
            cell.textLabel.text = @"None (prompt)";
        }
        else 
        {
            cell.textLabel.text = _clientManager.currentClient.name;
        }

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        TwitterClient *client = [_clients objectAtIndex:indexPath.row];
        [_clientManager setSelectedClientName:client.name];
        [self.tableView reloadData];

        if ([client isAvailable])
        {
            NSString *message = [NSString stringWithFormat:@"This message was sent from TwitThis by akosma software using %@", client.name];
            [client send:message];
        }
        else 
        {
            NSString *warning = [NSString stringWithFormat:@"%@ is not installed in this device", client.name];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"TwitThis"
                                                            message:warning
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
    }
    else if (indexPath.section == 1)
    {
        if ([_clientManager isAnyClientAvailable])
        {
            if ([_clientManager canSendMessage])
            {
                // A client is installed and ready to be used!
                // Let's send a message using it. We don't care which client this is!
                TwitterClient *client = _clientManager.currentClient;
                NSString *message = [NSString stringWithFormat:@"This message was sent from TwitThis by akosma software using %@", client.name];
                [_clientManager send:message];
            }
            else 
            {
                // This path means that a client has been installed in the device,
                // but the current value in the preferences is "None" or other device not installed.
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose a Twitter Client"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:nil];
                NSArray *availableClients = [_clientManager availableClients];
                for (NSString *client in availableClients)
                {
                    [sheet addButtonWithTitle:client];
                }
                [sheet showInView:self.tableView];
                [sheet release];
            }
        }
        else 
        {
            // No clients are installed in the device!
            NSString *warning = @"You must install a Twitter client in your device to be able to send messages via Twitter";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
                                                            message:warning
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
    }
}

@end

