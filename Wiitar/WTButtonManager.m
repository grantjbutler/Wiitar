//
//  WTButtonManager.m
//  Wiitar
//
//  Created by Grant Butler on 12/7/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import "WTButtonManager.h"

@implementation WTButtonManager {
    NSMutableDictionary *buttonDictionary;
}

- (id)init {
    if((self = [super init])) {
        buttonDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setPacketList:(WTMIDIPacketList *)packetList forButtons:(NSInteger)buttons {
    [buttonDictionary setObject:packetList forKey:[NSNumber numberWithInteger:buttons]];
}

- (WTMIDIPacketList *)packetListForButtons:(NSInteger)buttons {
    return [buttonDictionary objectForKey:[NSNumber numberWithInteger:buttons]];
}

- (void)removePacketListForButtons:(NSInteger)buttons {
	[buttonDictionary removeObjectForKey:[NSNumber numberWithInteger:buttons]];
}

- (NSEnumerator *)buttonEnumerator {
	return [buttonDictionary keyEnumerator];
}

- (NSUInteger)buttonCount {
	return [[self buttons] count];
}

- (NSArray *)buttons {
	return [[buttonDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

@end
