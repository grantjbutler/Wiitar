//
//  WTMidiController.h
//  Wiitar
//
//  Created by Grant Butler on 12/3/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

@interface WTMIDIPacket : NSObject

@property (nonatomic, assign, getter = isOn) BOOL on;
@property (nonatomic, assign) UInt16 velocity;
@property (nonatomic, assign) UInt16 note;
@property (nonatomic, assign) BOOL enabled;

+ (WTMIDIPacket *)packetWithNote:(UInt16)note velocity:(UInt16)velocity isOn:(BOOL)on enabled:(BOOL)enabled;

+ (WTMIDIPacket *)packetWithNote:(UInt16)note velocity:(UInt16)velocity isOn:(BOOL)on;

@end

@interface WTMIDIPacketList : NSObject

- (NSUInteger)packetCount;

- (void)addPacket:(WTMIDIPacket *)packet;
- (WTMIDIPacket *)packetAtIndex:(NSUInteger)index;
- (void)removePacketAtIndex:(NSUInteger)index;

- (WTMIDIPacketList *)inverse;

@end

@interface WTMIDIController : NSObject

+ (WTMIDIController *)sharedController;

- (void)sendPacketList:(WTMIDIPacketList *)packetList;
- (void)sendPacketLists:(NSArray *)packetLists;

@end
