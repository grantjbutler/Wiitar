//
//  WTButtonManager.h
//  Wiitar
//
//  Created by Grant Butler on 12/7/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WTMIDIController.h"

@interface WTButtonManager : NSObject

- (void)setPacketList:(WTMIDIPacketList *)packetList forButtons:(NSInteger)buttons;
- (WTMIDIPacketList *)packetListForButtons:(NSInteger)buttons;
- (void)removePacketListForButtons:(NSInteger)buttons;

- (NSEnumerator *)buttonEnumerator;
- (NSUInteger)buttonCount;
- (NSArray *)buttons;

@end
