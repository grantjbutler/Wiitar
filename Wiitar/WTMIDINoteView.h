//
//  WTMIDINoteView.h
//  Wiitar
//
//  Created by Grant Butler on 12/11/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WTMIDINoteView : NSView

@property (nonatomic, assign) NSInteger note;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@end
