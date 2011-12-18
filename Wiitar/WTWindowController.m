//
//  WTWindowController.m
//  Wiitar
//
//  Created by Grant Butler on 11/29/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import "WTWindowController.h"

#import "WiiRemote.h"
#import "WiiRemoteDiscovery.h"

#import "WTMIDIController.h"
#import "WTButtonManager.h"

#import "WTFretboardView.h"

#import "WTAppDelegate.h"

#import "WTMIDINoteView.h"

@implementation WTWindowController {
    WiiRemoteDiscovery *discovery;
	WiiRemote* wii;
	
	IBOutlet NSButton *addButton;
	IBOutlet NSButton *removeButton;
	
	IBOutlet NSWindow *addSheet;
	
	IBOutlet NSTableView *tableView_;
	
	IBOutlet WTFretboardView *fretboardView;
	
	WTFretButton active;
	
	NSMutableArray *buttonManagers;
	NSUInteger currentManagerIndex;
	
	NSUInteger selectedButton;
	
	IBOutlet WTMIDINoteView *noteView1;
	IBOutlet WTMIDINoteView *noteView2;
	IBOutlet WTMIDINoteView *noteView3;
	IBOutlet WTMIDINoteView *noteView4;
	IBOutlet WTMIDINoteView *noteView5;
}

-(void)awakeFromNib{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(expansionPortChanged:)
												 name:@"WiiRemoteExpansionPortChangedNotification"
											   object:nil];
	
	discovery = [[WiiRemoteDiscovery alloc] init];
	[discovery setDelegate:self];
	
	[removeButton setEnabled:NO];
	
    buttonManagers = [[NSMutableArray alloc] init];
    
    WTButtonManager *firstManager = [[WTButtonManager alloc] init];
    
//    WTMIDIPacketList *packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTGreenFretButton];
//    
//    packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:45 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTRedFretButton];
//    
//    packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:47 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTYellowFretButton];
//    
//    packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:48 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTBlueFretButton];
//    
//    packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:50 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTOrangeFretButton];
//    
//    packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:52 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTBlueFretButton | WTOrangeFretButton];
//    
//    packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES]];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:47 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTGreenFretButton | WTRedFretButton];
//    
//    packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:50 - 5 velocity:100 isOn:YES]];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:53 - 5 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTGreenFretButton | WTYellowFretButton];
//    
//    packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:47 velocity:100 isOn:YES]];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:50 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTGreenFretButton | WTBlueFretButton];
//    
//    packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:48 velocity:100 isOn:YES]];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:52 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTGreenFretButton | WTOrangeFretButton];
//    
//    packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:50 velocity:100 isOn:YES]];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:55 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTRedFretButton | WTOrangeFretButton];
//    
//    packetList = [[WTMIDIPacketList alloc] init];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:52 velocity:100 isOn:YES]];
//    [packetList addPacket:[WTMIDIPacket packetWithNote:55 velocity:100 isOn:YES]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//	[packetList addPacket:[WTMIDIPacket packetWithNote:43 velocity:100 isOn:YES enabled:NO]];
//    
//    [firstManager setPacketList:packetList forButtons:WTYellowFretButton | WTOrangeFretButton];
    
    [buttonManagers addObject:firstManager];
    
    currentManagerIndex = 0;
    selectedButton = 0;
	
	[noteView1 setTarget:self];
	[noteView1 setAction:@selector(midiNoteViewAction:)];
	
	[noteView2 setTarget:self];
	[noteView2 setAction:@selector(midiNoteViewAction:)];
	
	[noteView3 setTarget:self];
	[noteView3 setAction:@selector(midiNoteViewAction:)];
	
	[noteView4 setTarget:self];
	[noteView4 setAction:@selector(midiNoteViewAction:)];
	
	[noteView5 setTarget:self];
	[noteView5 setAction:@selector(midiNoteViewAction:)];
	
	[self connect:nil];
	
	[tableView_ selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

#pragma mark - IBActions

- (IBAction)connect:(id)sender {
	[discovery stop];
	[discovery start];
	NSLog(@"To connect, please press the 1 and 2 buttons simultaneously.");
}

- (IBAction)addButton:(id)sender {
	[[NSApplication sharedApplication] beginSheet:addSheet modalForWindow:[(WTAppDelegate *)[NSApp delegate] window] modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	if(returnCode == 1) {
		WTMIDIPacketList *packetList = [[WTMIDIPacketList alloc] init];
		
		[packetList addPacket:[WTMIDIPacket packetWithNote:60 velocity:100 isOn:YES enabled:NO]];
		[packetList addPacket:[WTMIDIPacket packetWithNote:60 velocity:100 isOn:YES enabled:NO]];
		[packetList addPacket:[WTMIDIPacket packetWithNote:60 velocity:100 isOn:YES enabled:NO]];
		[packetList addPacket:[WTMIDIPacket packetWithNote:60 velocity:100 isOn:YES enabled:NO]];
		[packetList addPacket:[WTMIDIPacket packetWithNote:60 velocity:100 isOn:YES enabled:NO]];
		
		[[buttonManagers objectAtIndex:currentManagerIndex] setPacketList:packetList forButtons:fretboardView.buttons];
		
		NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[[(WTButtonManager *)[buttonManagers objectAtIndex:currentManagerIndex] buttons] indexOfObject:[NSNumber numberWithInteger:fretboardView.buttons]]];
		
		[tableView_ insertRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectNone];
		[tableView_ selectRowIndexes:indexSet byExtendingSelection:NO];
	}
	
	[sheet orderOut:self];
}

- (IBAction)cancelSheet:(id)sender {
	[[NSApplication sharedApplication] endSheet:addSheet];
}

- (IBAction)addSheet:(id)sender {
	if([[(WTButtonManager *)[buttonManagers objectAtIndex:currentManagerIndex] buttons] indexOfObject:[NSNumber numberWithInteger:fretboardView.buttons]] != NSNotFound) {
		// Throw up an alert telling the user that this one is already taken.
		
		return;
	}
	
	[[NSApplication sharedApplication] endSheet:addSheet returnCode:1];
}

- (IBAction)removeButton:(id)sender {
	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"Delete"];
	[alert addButtonWithTitle:@"Cancel"];
	[alert setMessageText:@"Remove Buttons?"];
	[alert setInformativeText:@"Are you sure you want to delete these buttons? This action cannot be undone."];
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert beginSheetModalForWindow:[(WTAppDelegate *)[NSApp delegate] window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:NULL];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	[[alert window] orderOut:self];
	
	if(returnCode == NSAlertFirstButtonReturn) {
		// DELETE. DELETE. DELETE.
		NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[[(WTButtonManager *)[buttonManagers objectAtIndex:currentManagerIndex] buttons] indexOfObject:[NSNumber numberWithInteger:selectedButton]]];
		
		[[buttonManagers objectAtIndex:currentManagerIndex] removePacketListForButtons:selectedButton];
		
		[tableView_ removeRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectFade];
		[tableView_ selectRowIndexes:[NSIndexSet indexSetWithIndex:[indexSet firstIndex] - 1] byExtendingSelection:NO];
	}
}

- (void)midiNoteViewAction:(WTMIDINoteView *)noteView {
	NSInteger index = -1;
	
	if(noteView == noteView1) {
		index = 0;
	} else if(noteView == noteView2) {
		index = 1;
	} else if(noteView == noteView3) {
		index = 2;
	} else if(noteView == noteView4) {
		index = 3;
	} else if(noteView == noteView5) {
		index = 4;
	}
	
	WTMIDIPacketList *packetList = [[buttonManagers objectAtIndex:currentManagerIndex] packetListForButtons:selectedButton];
	
	if(index == -1) {
		return;
	}
	
	WTMIDIPacket *packet = [packetList packetAtIndex:index];
	
	[packet setNote:[noteView note]];
	[packet setEnabled:[noteView isEnabled]];
}

#pragma mark - Wiimote Callbacks

- (void)expansionPortChanged:(NSNotification *)nc{
	WiiRemote* tmpWii = (WiiRemote*)[nc object];
	
	if ([tmpWii isExpansionPortAttached]){
		[tmpWii setExpansionPortEnabled:YES];
	}else{
		[tmpWii setExpansionPortEnabled:NO];
		
	}
	
}

- (void) willStartWiimoteConnections {
	NSLog(@"===== Wiimote found. Connecting... =====");
}

- (void) WiiRemoteDiscovered:(WiiRemote*)wiimote {
	[discovery stop];
	wii = wiimote;
	[wiimote setDelegate:self];
    if ([wiimote isExpansionPortAttached]){
		[wiimote setExpansionPortEnabled:YES];
	}else{
		[wiimote setExpansionPortEnabled:NO];
		
	}
	NSLog(@"===== Connected to WiiRemote =====");
	[wiimote setLEDEnabled1:YES enabled2:NO enabled3:NO enabled4:YES];
}

- (void) WiiRemoteDiscoveryError:(int)code {
	NSLog(@"%@", [NSString stringWithFormat:@"===== Wiimote connection error (%d) =====", code]);
}

- (void) wiiRemoteDisconnected:(IOBluetoothDevice*)device {
	NSLog(@"===== Lost connection with Wiimote =====");
}

- (void) accelerationChanged:(WiiAccelerationSensorType)type accX:(unsigned char)accX accY:(unsigned char)accY accZ:(unsigned char)accZ {
    
}

- (void) buttonChanged:(WiiButtonType)type isPressed:(BOOL)isPressed {
//    NSLog(@"BUTTON %d - %d", type, isPressed);
    
	switch (type) {
		case WiiGuitarHeroWorldTourStrumDownButton:
		case WiiGuitarHeroWorldTourStrumUpButton:
			if(isPressed) {
				// Alright, first, go through the current buttons, and send a MIDI off signal.
				WTButtonManager *currentManager = [buttonManagers objectAtIndex:currentManagerIndex];
                
				WTMIDIPacketList *packetList = [currentManager packetListForButtons:active];
				
				if(packetList != nil) {
					packetList = [packetList inverse];
					
					[[WTMIDIController sharedController] sendPacketList:packetList];
				}
                
				// Get the pressed buttons and send the MIDI data.
				WTFretButton new = 0;
				
				if([wii isButtonPressed:WiiGuitarHeroWorldTourGreenButton]) {
					new |= WTGreenFretButton;
				}
                
                if([wii isButtonPressed:WiiGuitarHeroWorldTourRedButton]) {
					new |= WTRedFretButton;
				}
                
                if([wii isButtonPressed:WiiGuitarHeroWorldTourYellowButton]) {
					new |= WTYellowFretButton;
				}
                
                if([wii isButtonPressed:WiiGuitarHeroWorldTourBlueButton]) {
					new |= WTBlueFretButton;
				}
                
                if([wii isButtonPressed:WiiGuitarHeroWorldTourOrangeButton]) {
					new |= WTOrangeFretButton;
				}
				
				packetList = [currentManager packetListForButtons:new];
				
				if(packetList != nil) {
					[[WTMIDIController sharedController] sendPacketList:packetList];
				}
				
				active = new;
			}
			
			break;
		
		case WiiGuitarHeroWorldTourBlueButton:
		case WiiGuitarHeroWorldTourRedButton:
		case WiiGuitarHeroWorldTourYellowButton:
		case WiiGuitarHeroWorldTourGreenButton:
		case WiiGuitarHeroWorldTourOrangeButton:
			if(!isPressed) {
				// Check to see the button was in the list of buttons that are sending MIDI data. If so, cut off all MIDI data.
				
				WTFretButton new;
				
				if(type == WiiGuitarHeroWorldTourGreenButton) {
					new |= WTGreenFretButton;
				} else if(type == WiiGuitarHeroWorldTourRedButton) {
					new |= WTRedFretButton;
				} else if(type == WiiGuitarHeroWorldTourYellowButton) {
					new |= WTYellowFretButton;
				} else if(type == WiiGuitarHeroWorldTourBlueButton) {
					new |= WTBlueFretButton;
				} else if(type == WiiGuitarHeroWorldTourOrangeButton) {
					new |= WTOrangeFretButton;
				}
                
				if(new & active) {
					WTButtonManager *currentManager = [buttonManagers objectAtIndex:currentManagerIndex];
					
					WTMIDIPacketList *packetList = [currentManager packetListForButtons:active];
					
					if(packetList != nil) {
						packetList = [packetList inverse];
						
						[[WTMIDIController sharedController] sendPacketList:packetList];
					}
				}
			} else if(isPressed) {
				// Alright, check to see if we're already sending data for a single button. If so, and there exists a note for this button, treat it as a hammer-on.
			}
			
			break;
        
		case WiiGuitarHeroWorldTourPlusButton:
			currentManagerIndex++;
            
			if(currentManagerIndex >= [buttonManagers count]) {
				currentManagerIndex = 0;
			}
			
			break;
        
		case WiiGuitarHeroWorldTourMinusButton:
			currentManagerIndex--;
			
			if(currentManagerIndex <= -1) {
				currentManagerIndex = [buttonManagers count] - 1;
			}
			
		default:
			break;
	}
	
}

- (void) joyStickChanged:(WiiJoyStickType)type tiltX:(unsigned char)tiltX tiltY:(unsigned char)tiltY {
    
}

- (void) analogButtonChanged:(WiiButtonType)type amount:(unsigned char)pressure {
//	char pressure_offset = 15; // neutral value of whammy bar
//	if(type == B_WHAMMY) {
//		[whammyIndicator setIntValue:(pressure - pressure_offset)];
//		if(pressure > pressure_offset + [whammySlider floatValue] && !doing_whammy) {
//			if([[whammyKeyPopUp selectedItem] tag]) // special keys have keycode as tag; otherwise it's 0 and use the field.
//				[self sendKeyboardEvent:[[whammyKeyPopUp selectedItem] tag] keyDown:YES];
//			else
//				[self sendKey:[whammyKeyField stringValue] keyDown:YES];
//			doing_whammy = YES;
//		} else if(pressure <= pressure_offset + [whammySlider floatValue] && doing_whammy) {
//			if([[whammyKeyPopUp selectedItem] tag]) // special keys have keycode as tag; otherwise it's 0 and use the field.
//				[self sendKeyboardEvent:[[whammyKeyPopUp selectedItem] tag] keyDown:NO];
//			else
//				[self sendKey:[whammyKeyField stringValue] keyDown:NO];
//			doing_whammy = NO;
//		}
//	}
    
    NSLog(@"ANALOG %d - %c", type, pressure);
	
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
	WTFretboardView *result = [tableView makeViewWithIdentifier:@"WTFretboardView" owner:self];
	
	if(result == nil) {
		result = [[[WTFretboardView alloc] initWithFrame:NSZeroRect] autorelease];
		result.identifier = @"WTFretboardView";
		result.editable = NO;
	}
	
	result.buttons = [[[(WTButtonManager *)[buttonManagers objectAtIndex:currentManagerIndex] buttons] objectAtIndex:row] integerValue];
	
	return result;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
	NSTableView *tableView = [aNotification object];
	
	[removeButton setEnabled:[[tableView selectedRowIndexes] count] > 0];
	
	NSIndexSet *indexSet = [tableView selectedRowIndexes];
	NSUInteger aIndex = [indexSet firstIndex];
	
	if([[(WTButtonManager *)[buttonManagers objectAtIndex:currentManagerIndex] buttons] count] <= aIndex) {
		return;
	}
	
	WTFretboardView *view = [tableView viewAtColumn:0 row:aIndex makeIfNecessary:NO];
	
	if(!view) {
		return;
	}
	
	if(![view isKindOfClass:[WTFretboardView class]]) {
		return;
	}
	
	selectedButton = view.buttons;
	
	WTMIDIPacketList *packetList = [(WTButtonManager *)[buttonManagers objectAtIndex:currentManagerIndex] packetListForButtons:selectedButton];
	
	for(int i = 0; i < 5; i++) {
		WTMIDIPacket *packet = [packetList packetAtIndex:i];
		
		if(i == 0) {
			[noteView1 setNote:packet.note];
			[noteView1 setEnabled:packet.enabled];
		} else if(i == 1) {
			[noteView2 setNote:packet.note];
			[noteView2 setEnabled:packet.enabled];
		} else if(i == 2) {
			[noteView3 setNote:packet.note];
			[noteView3 setEnabled:packet.enabled];
		} else if(i == 3) {
			[noteView4 setNote:packet.note];
			[noteView4 setEnabled:packet.enabled];
		} else if(i == 4) {
			[noteView5 setNote:packet.note];
			[noteView5 setEnabled:packet.enabled];
		}
	}
}

#pragma mark - NSTableViewDataSoure

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
	return [[buttonManagers objectAtIndex:currentManagerIndex] buttonCount];
}

@end
