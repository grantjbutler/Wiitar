//
//  WTMIDINoteView.m
//  Wiitar
//
//  Created by Grant Butler on 12/11/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import "WTMIDINoteView.h"
#import "WTMIDINoteFormatter.h"

#include <objc/runtime.h>

void invokeSelector(id object, SEL selector, NSArray *arguments);
void invokeSelector(id object, SEL selector, NSArray *arguments)
{
    Method method = class_getInstanceMethod([object class], selector);
    int argumentCount = method_getNumberOfArguments(method);
	
    if(argumentCount > [arguments count] + 2) {
		return; // Not enough arguments in the array
	}
	
    NSMethodSignature *signature = [object methodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:object];
    [invocation setSelector:selector];
	
    for(int i=0; i<[arguments count]; i++)
    {
        id arg = [arguments objectAtIndex:i];
        [invocation setArgument:&arg atIndex:i+2]; // The first two arguments are the hidden arguments self and _cmd
    }
	
    [invocation invoke]; // Invoke the selector
}

@implementation WTMIDINoteView {
	NSStepper *stepper;
	NSTextField *textField;
	NSButton *button;
}

@synthesize note = _note;
@synthesize target = _target;
@synthesize action = _action;

- (void)commonInit_ {
	_note = 12;
	
	button = [[NSButton alloc] initWithFrame:NSZeroRect];
	[button setButtonType:NSSwitchButton];
	[button setTarget:self];
	[button setAction:@selector(checkboxChecked:)];
	[button setTitle:@""];
	[button sizeToFit];
	[button setAutoresizingMask:NSViewMaxXMargin];
	
	NSRect frame = [button frame];
	frame.origin.y = (self.frame.size.height - frame.size.height) / 2.0;
	[button setFrame:frame];
	
	[self addSubview:button];
	
	stepper = [[NSStepper alloc] initWithFrame:NSZeroRect];
	[stepper setIncrement:1];
	[stepper setMinValue:0];
	[stepper setMaxValue:INT_MAX];
	[stepper bind:@"value" toObject:self withKeyPath:@"note" options:nil];
	[stepper sizeToFit];
	[stepper setAutoresizingMask:NSViewMinXMargin];
	[stepper setAction:@selector(stepperStepped:)];
	[stepper setTarget:self];
	
	frame = [stepper frame];
	frame.origin.y = (self.frame.size.height - frame.size.height) / 2.0;
	frame.origin.x = (self.frame.size.width - frame.size.width);
	[stepper setFrame:frame];
	
	[self addSubview:stepper];
	
	textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
	[textField setFormatter:[[WTMIDINoteFormatter alloc] init]];
	[textField bind:@"value" toObject:self withKeyPath:@"note" options:nil];
	[textField setContinuous:YES];
	[textField sizeToFit];
	[textField setTarget:self];
	[textField setAction:@selector(textFieldTexted:)];
	
	frame = [textField frame];
	frame.origin.y = (self.frame.size.height - frame.size.height) / 2.0;
	frame.origin.x = [button frame].size.width + 3.0;
	frame.size.width = self.frame.size.width - frame.origin.x - [stepper frame].size.width - 3.0;
	[textField setFrame:frame];
	
	[self addSubview:textField];
	
	[self setEnabled:YES];
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		[self commonInit_];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if((self = [super initWithCoder:aDecoder])) {
		[self commonInit_];
	}
	
	return self;
}

- (void)checkboxChecked:(NSButton *)sender {
	if([sender state] == NSOnState) {
		[textField setEnabled:YES];
		[stepper setEnabled:YES];
	} else if([sender state] == NSOffState) {
		[textField setEnabled:NO];
		[stepper setEnabled:NO];
	}
	
	if(_target != nil && _action != NULL) {
		if(![_target respondsToSelector:_action]) {
			return;
		}
		
		invokeSelector(_target, _action, [NSArray arrayWithObject:self]);
	}
}

- (void)stepperStepped:(NSStepper *)sender {
	if(_target != nil && _action != NULL) {
		if(![_target respondsToSelector:_action]) {
			return;
		}
		
		invokeSelector(_target, _action, [NSArray arrayWithObject:self]);
	}
}

- (void)textFieldTexted:(NSTextField *)sender {
	if(_target != nil && _action != NULL) {
		if(![_target respondsToSelector:_action]) {
			return;
		}
		
		invokeSelector(_target, _action, [NSArray arrayWithObject:self]);
	}
}

- (void)setEnabled:(BOOL)flag {
	[self willChangeValueForKey:@"enabled"];
	
	if(flag) {
		[button setState:NSOnState];
	} else {
		[button setState:NSOffState];
	}
	
	[self checkboxChecked:button];
	
	[self didChangeValueForKey:@"enabled"];
}

- (BOOL)isEnabled {
	return [textField isEnabled];
}

- (void)dealloc {
	[textField unbind:@"intValue"];
	[stepper unbind:@"intValue"];
}

@end
