//
//  WTFretboardView.m
//  Wiitar
//
//  Created by Grant Butler on 12/7/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import "WTFretboardView.h"

static NSBezierPath *fretPath = nil;

void WTFretboardViewFillFret(NSColor *color, NSPoint origin);
void WTFretboardViewFillFret(NSColor *color, NSPoint origin) {
	NSAffineTransform *transform = [NSAffineTransform transform];
	[transform translateXBy:origin.x yBy:origin.y];
	
	[fretPath transformUsingAffineTransform:transform];
	
	[color setFill];
	[fretPath fill];
	
	[transform invert];
	
	[fretPath transformUsingAffineTransform:transform];
}

void WTFretboardViewStrokeFret(NSColor *color, NSPoint origin);
void WTFretboardViewStrokeFret(NSColor *color, NSPoint origin) {
	NSAffineTransform *transform = [NSAffineTransform transform];
	[transform translateXBy:origin.x yBy:origin.y];
	
	[fretPath transformUsingAffineTransform:transform];
	
	[color setStroke];
	[fretPath stroke];
	
	[transform invert];
	
	[fretPath transformUsingAffineTransform:transform];
}

@implementation WTFretboardView {
	CGFloat newWidth;
	CGFloat newHeight;
	CGFloat xPadding;
	CGFloat yPadding;
}

@synthesize editable = _editable;

@synthesize buttons = _buttons;

+ (void)initialize {
	if(self == [WTFretboardView class]) {
		fretPath = [[NSBezierPath alloc] init];
		[fretPath setLineWidth:2.0];
		[fretPath appendBezierPathWithArcWithCenter:NSMakePoint(25.0, 25.0) radius:25.0 startAngle:180.0 endAngle:0.0];
		[fretPath lineToPoint:NSMakePoint(50.0, 70.0)];
		[fretPath appendBezierPathWithArcWithCenter:NSMakePoint(45.0, 70.0) radius:5.0 startAngle:0.0 endAngle:90.0];
		[fretPath lineToPoint:NSMakePoint(5.0, 75.0)];
		[fretPath appendBezierPathWithArcWithCenter:NSMakePoint(5.0, 70.0) radius:5.0 startAngle:90.0 endAngle:180.0];
		[fretPath lineToPoint:NSMakePoint(0.0, 50.0)];
		[fretPath closePath];
	}
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
		self.editable = YES;
		
		[self addObserver:self forKeyPath:@"bounds" options:0 context:NULL];
		[self addObserver:self forKeyPath:@"buttons" options:0 context:NULL];
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
	
	CGFloat scale = (self.bounds.size.height - 10.0 - 10.0) / 75.0;
	
	NSAffineTransform *transform = [NSAffineTransform transform];
	[transform scaleBy:scale];
	
	newWidth = 50.0 * scale;
	newHeight = 75.0 * scale;
	CGFloat leftoverVertialSpace = self.bounds.size.width - newWidth * 5;
	xPadding = leftoverVertialSpace / 6.0;
	yPadding = (self.bounds.size.height - newHeight) / 2.0;
	
	[fretPath transformUsingAffineTransform:transform];
	
	NSPoint origin = NSMakePoint(xPadding, yPadding);
	
	if(self.buttons & WTGreenFretButton) {
		WTFretboardViewFillFret([NSColor greenColor], origin);
	} else {
		WTFretboardViewStrokeFret([NSColor greenColor] , origin);
	}
	
	origin.x += xPadding + newWidth;
	
	if(self.buttons & WTRedFretButton) {
		WTFretboardViewFillFret([NSColor redColor], origin);
	} else {
		WTFretboardViewStrokeFret([NSColor redColor], origin);
	}
	
	origin.x += xPadding + newWidth;
	
	if(self.buttons & WTYellowFretButton) {
		WTFretboardViewFillFret([NSColor yellowColor], origin);
	} else {
		WTFretboardViewStrokeFret([NSColor yellowColor], origin);
	}
	
	origin.x += xPadding + newWidth;
	
	if(self.buttons & WTBlueFretButton) {
		WTFretboardViewFillFret([NSColor blueColor], origin);
	} else {
		WTFretboardViewStrokeFret([NSColor blueColor], origin);
	}
	
	origin.x += xPadding + newWidth;
	
	if(self.buttons & WTOrangeFretButton) {
		WTFretboardViewFillFret([NSColor orangeColor], origin);
	} else {
		WTFretboardViewStrokeFret([NSColor orangeColor], origin);
	}
	
	[transform invert];
	[fretPath transformUsingAffineTransform:transform];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if([keyPath isEqualToString:@"bounds"] ||
	   [keyPath isEqualToString:@"buttons"]) {
		[self setNeedsDisplay:YES];
		
		return;
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)mouseUp:(NSEvent *)theEvent {
	if(![self isEditable]) {
		[[self nextResponder] mouseUp:theEvent];
		
		return;
	}
	
	CGRect convertedRect = NSRectToCGRect(self.frame);
	CGPoint convertedPoint = NSPointToCGPoint([theEvent locationInWindow]);
	
	if(!CGRectContainsPoint(convertedRect, convertedPoint)) {
		return;
	}
	
	// Alright, the point is in our rect. Convert it to our coordinate space.
	
	CGPoint location = NSPointToCGPoint([self convertPoint:[theEvent locationInWindow] fromView:[[self window] contentView]]);
	
	CGRect fretFrame = CGRectMake(xPadding, 0.0, newWidth, self.frame.size.height);
	
	if(CGRectContainsPoint(fretFrame, location)) {
		self.buttons ^= WTGreenFretButton;
	} else {
		fretFrame.origin.x += xPadding + newWidth;
		
		if(CGRectContainsPoint(fretFrame, location)) {
			self.buttons ^= WTRedFretButton;
		} else {
			fretFrame.origin.x += xPadding + newWidth;
			
			if(CGRectContainsPoint(fretFrame, location)) {
				self.buttons ^= WTYellowFretButton;
			} else {
				fretFrame.origin.x += xPadding + newWidth;
				
				if(CGRectContainsPoint(fretFrame, location)) {
					self.buttons ^= WTBlueFretButton;
				} else {
					fretFrame.origin.x += xPadding + newWidth;
					
					if(CGRectContainsPoint(fretFrame, location)) {
						self.buttons ^= WTOrangeFretButton;
					}
				}
			}
		}
	}
}

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"bounds"];
	[self removeObserver:self forKeyPath:@"buttons"];
}

@end
