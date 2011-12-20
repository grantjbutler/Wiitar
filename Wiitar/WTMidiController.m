//
//  WTMidiController.m
//  Wiitar
//
//  Created by Grant Butler on 12/3/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import "WTMIDIController.h"

#define MIDIPACKETSIZE 3 
#define MIDIPACKETLISTSIZE 1024

@implementation WTMIDIPacket

@synthesize on;
@synthesize velocity;
@synthesize note;
@synthesize enabled;

+ (WTMIDIPacket *)packetWithNote:(UInt16)note velocity:(UInt16)velocity isOn:(BOOL)on {
    return [WTMIDIPacket packetWithNote:note velocity:velocity isOn:on enabled:YES];
}

+ (WTMIDIPacket *)packetWithNote:(UInt16)note velocity:(UInt16)velocity isOn:(BOOL)on enabled:(BOOL)enabled {
    WTMIDIPacket *packet = [[WTMIDIPacket alloc] init];
    
    packet.on = on;
    packet.note = note;
    packet.velocity = velocity;
	packet.enabled = enabled;
    
    return [packet autorelease];
}

@end

@interface WTMIDIPacketList ()

- (MIDIPacketList *)packetList;

@end

@implementation WTMIDIPacketList {
    NSMutableArray *packets;
}

- (id)init {
    if((self = [super init])) {
        packets = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addPacket:(WTMIDIPacket *)packet {
    [packets addObject:packet];
}

- (WTMIDIPacketList *)inverse {
    WTMIDIPacketList *inversePacketList = [[WTMIDIPacketList alloc] init];
    
    for(WTMIDIPacket *packet in packets) {
        WTMIDIPacket *newPacket = [WTMIDIPacket packetWithNote:packet.note velocity:packet.velocity isOn:!packet.isOn];
        
        [inversePacketList addPacket:newPacket];
    }
    
    return inversePacketList;
}

- (MIDIPacketList *)packetList {
	MIDIPacketList *packetList;
    MIDIPacket *currentPacket;
    Byte buffer[MIDIPACKETLISTSIZE];
	
	packetList = (MIDIPacketList *)buffer;
	currentPacket = MIDIPacketListInit(packetList);
	
	for(WTMIDIPacket *packet in packets) {
		if(!packet.enabled) {
			continue;
		}
		
		// 0x90 means ON in MIDI, while 0x80 means OFF.
		Byte noteOn[MIDIPACKETSIZE] = { packet.isOn ? 0x90 : 0x80, packet.note, packet.velocity };
		
		currentPacket = MIDIPacketListAdd(packetList, MIDIPACKETLISTSIZE, currentPacket, 0, MIDIPACKETSIZE, noteOn);
	}
	
    return packetList;
}

- (NSUInteger)packetCount {
	return [packets count];
}

- (WTMIDIPacket *)packetAtIndex:(NSUInteger)index {
	return [packets objectAtIndex:index];
}

- (void)removePacketAtIndex:(NSUInteger)index {
	[packets removeObjectAtIndex:index];
}

@end

@implementation WTMIDIController {
    MIDIClientRef client;
    MIDIEndpointRef outputSource;
}

+ (WTMIDIController *)sharedController {
    static WTMIDIController *sharedController = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[WTMIDIController alloc] init];
    });
    
    return sharedController;
}

- (id)init {
    if((self = [super init])) {
        OSStatus result = MIDIClientCreate((CFStringRef)@"Wiitar", NULL, NULL, &client);
        
        if(result != noErr) {
            NSLog(@"Could not create client!");
            [self release];
            return nil;
        }
        
        result = MIDISourceCreate(client, (CFStringRef)@"Wiitar Output", &outputSource);
        
        if(result != noErr) {
            NSLog(@"Could not create output port!");
            
            MIDIClientDispose(client);
            
            [self release];
            return nil;
        }
    }
    
    return self;
}

- (void)sendPacketList:(WTMIDIPacketList *)packetList {
    OSStatus result = MIDIReceived(outputSource, [packetList packetList]);
    
    if(result != noErr) {
        NSLog(@"DIDN'T SEND");
    }
}

- (void)sendPacketLists:(NSArray *)packetLists {
    for(WTMIDIPacketList *packetList in packetLists) {
        [self sendPacketList:packetList];
    }
}

@end
