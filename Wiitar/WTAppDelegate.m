//
//  WTAppDelegate.m
//  Wiitar
//
//  Created by Grant Butler on 11/29/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import "WTAppDelegate.h"
#import "WTMIDIController.h"

@implementation WTAppDelegate

@synthesize window = _window;

- (void)dealloc {
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [WTMIDIController sharedController];
}

@end
