//
//  WTMIDINoteFormatter.m
//  Wiitar
//
//  Created by Grant Butler on 12/11/11.
//  Copyright (c) 2011 iSpeech, Inc. All rights reserved.
//

#import "WTMIDINoteFormatter.h"

@implementation WTMIDINoteFormatter

- (NSString *)stringForObjectValue:(id)anObject {
	if(![anObject isKindOfClass:[NSNumber class]]) {
		return nil;
	}
	
	int octave = ([anObject intValue] / 12) - 1;
	
	NSString *note = nil;
	
	switch ([anObject intValue] % 12) {
		case 0:
			note = @"C";
			break;
		
		case 1:
			note = @"C#";
			break;
		
		case 2:
			note = @"D";
			break;
		
		case 3:
			note = @"D#";
			break;
		
		case 4:
			note = @"E";
			break;
		
		case 5:
			note = @"F";
			break;
		
		case 6:
			note = @"F#";
			break;
		
		case 7:
			note = @"G";
			break;
		
		case 8:
			note = @"G#";
			break;
			
		case 9:
			note = @"A";
			break;
		
		case 10:
			note = @"A#";
			break;
		
		case 11:
			note = @"B";
			break;
			
		default:
			break;
	}
	
	return [note stringByAppendingFormat:@"%d", octave];
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error {
	NSScanner *scanner = [NSScanner scannerWithString:string];
	
	NSString *note;
	BOOL returnValue = NO;
	int midiNote = -1;
	
	if([scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGabcdefg"] intoString:&note] && [note length] == 1) {
		
		if([[note lowercaseString] isEqualToString:@"a"]) {
			midiNote = 9;
		} else if([[note lowercaseString] isEqualToString:@"b"]) {
			midiNote = 11;
		} else if([[note lowercaseString] isEqualToString:@"c"]) {
			midiNote = 0;
		} else if([[note lowercaseString] isEqualToString:@"d"]) {
			midiNote = 2;
		} else if([[note lowercaseString] isEqualToString:@"e"]) {
			midiNote = 4;
		} else if([[note lowercaseString] isEqualToString:@"f"]) {
			midiNote = 5;
		} else if([[note lowercaseString] isEqualToString:@"g"]) {
			midiNote = 7;
		}
		
		if(midiNote == -1) {
			if(error) {
				*error = NSLocalizedString(@"Could not parse note.", @"Parsing error");
			}
		} else {
			NSString *modifiers;
			
			if([scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"#b"] intoString:&modifiers]) {
				if([modifiers isEqualToString:@"#"]) {
					midiNote++;
				} else  if([modifiers isEqualToString:@"b"]) {
					midiNote--;
				}
			}
			
			int octave;
			
			if([scanner scanInt:&octave]) {
				midiNote += (octave + 1) * 12;
				
				returnValue = YES;
				
				if(anObject) {
					*anObject = [NSNumber numberWithInt:midiNote];
				}
			} else {
				if(error) {
					*error = NSLocalizedString(@"Could not parse note.", @"Parsing error");
				}
			}
		}
	} else {
		if(error) {
			*error = NSLocalizedString(@"Could not parse note.", @"Parsing error");
		}
	}
	
	return returnValue;
}

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr
	   proposedSelectedRange:(NSRangePointer)proposedSelRangePtr
			  originalString:(NSString *)origString
	   originalSelectedRange:(NSRange)origSelRange
			errorDescription:(NSString **)error {
	if([*partialStringPtr length] > 3) {
		if(error) {
			*error = NSLocalizedString(@"Could not parse note. Too long.", @"Parsing error");
		}
		
		return NO;
	}
	
	return YES;
}

@end
