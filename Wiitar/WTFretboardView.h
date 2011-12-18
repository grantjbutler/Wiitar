//
//  WTFretboardView.h
//  Wiitar
//
//  Created by Grant Butler on 12/7/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum _WTFretButton {
	WTGreenFretButton  = 1 << 1,
	WTRedFretButton    = 1 << 2,
	WTYellowFretButton = 1 << 3,
	WTBlueFretButton   = 1 << 4,
	WTOrangeFretButton = 1 << 5
};

typedef NSUInteger WTFretButton;

@interface WTFretboardView : NSView

@property (nonatomic, assign, getter = isEditable) BOOL editable;

@property (nonatomic, assign) WTFretButton buttons;

@end
