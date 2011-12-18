//
//  WTWindowController.h
//  Wiitar
//
//  Created by Grant Butler on 11/29/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WiiRemote;
@class WiiRemoteDiscovery;

@interface WTWindowController : NSObject <NSTableViewDelegate, NSTableViewDataSource>

- (IBAction)connect:(id)sender;

@end
