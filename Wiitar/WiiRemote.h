//
//  WiiRemote.h
//  DarwiinRemote
//
//  Created by KIMURA Hiroaki on 06/12/04.
//  Copyright 2006 KIMURA Hiroaki. All rights reserved.
//

#import "Mii.h"

#import <Cocoa/Cocoa.h>
#import <IOBluetooth/objc/IOBluetoothDevice.h>
#import <IOBluetooth/objc/IOBluetoothL2CAPChannel.h>

// useful logging macros
#ifndef NSLogDebug
#if DEBUG
#	define NSLogDebug(log, ...) NSLog(log, ##__VA_ARGS__)
#	define LogIOReturn(result) if (result != kIOReturnSuccess) { printf ("IOReturn error (%s [%d]): system 0x%x, sub 0x%x, error 0x%x\n", __FILE__, __LINE__, err_get_system (result), err_get_sub (result), err_get_code (result)); }
#else
#	define NSLogDebug(log, ...)
#	define LogIOReturn(result)
#endif
#endif

extern NSString * WiiRemoteExpansionPortChangedNotification;


typedef unsigned char WiiIRModeType;
enum {
	kWiiIRModeBasic			= 0x01,
	kWiiIRModeExtended		= 0x03,
	kWiiIRModeFull			= 0x05
};

typedef struct {
	int x, y, s;
} IRData;

typedef struct {
	unsigned short accX_zero, accY_zero, accZ_zero, accX_1g, accY_1g, accZ_1g; 
} WiiAccCalibData;

typedef struct {
	unsigned short x_min, x_max, x_center, y_min, y_max, y_center; 
} WiiJoyStickCalibData;


typedef enum {
	WiiRemoteAButton,
	WiiRemoteBButton,
	WiiRemoteOneButton,
	WiiRemoteTwoButton,
	WiiRemoteMinusButton,
	WiiRemoteHomeButton,
	WiiRemotePlusButton,
	WiiRemoteUpButton,
	WiiRemoteDownButton,
	WiiRemoteLeftButton,
	WiiRemoteRightButton,
	
	WiiNunchukZButton,
	WiiNunchukCButton,
	
	WiiClassicControllerXButton,
	WiiClassicControllerYButton,
	WiiClassicControllerAButton,
	WiiClassicControllerBButton,
	WiiClassicControllerLButton,
	WiiClassicControllerRButton,
	WiiClassicControllerZLButton,
	WiiClassicControllerZRButton,
	WiiClassicControllerUpButton,
	WiiClassicControllerDownButton,
	WiiClassicControllerLeftButton,
	WiiClassicControllerRightButton,
	WiiClassicControllerMinusButton,
	WiiClassicControllerHomeButton,
	WiiClassicControllerPlusButton,
    
    WiiGuitarHeroWorldTourGreenButton,
    WiiGuitarHeroWorldTourRedButton,
    WiiGuitarHeroWorldTourYellowButton,
    WiiGuitarHeroWorldTourBlueButton,
    WiiGuitarHeroWorldTourOrangeButton,
    
    WiiGuitarHeroWorldTourStrumDownButton,
    WiiGuitarHeroWorldTourStrumUpButton,
    
    WiiGuitarHeroWorldTourPlusButton,
    WiiGuitarHeroWorldTourMinusButton,
    
    WiiButtonCount
} WiiButtonType;

unsigned char mii_data_buf[WIIMOTE_MII_DATA_BYTES_PER_SLOT + 16];
unsigned short mii_data_offset;

typedef enum {
	WiiExpNotAttached,
	WiiNunchuk,
	WiiClassicController,
    WiiGuitar,
    WiiGuitarWorldTour
}  WiiExpansionPortType;

typedef enum {
	WiiRemoteAccelerationSensor,
	WiiNunchukAccelerationSensor
} WiiAccelerationSensorType;


typedef enum {
	WiiNunchukJoyStick					= 0,
	WiiClassicControllerLeftJoyStick	= 1,
	WiiClassicControllerRightJoyStick	= 2
} WiiJoyStickType;

@interface WiiRemote : NSObject
{
#ifdef DEBUG
	BOOL _dump;
#endif
	
	BOOL _opened;
	BOOL _shouldUpdateReportMode;
	BOOL _shouldReadExpansionCalibration;
	BOOL _isMotionSensorEnabled;
	BOOL _isIRSensorEnabled;
	BOOL _isVibrationEnabled;
	BOOL _isExpansionPortEnabled;
	BOOL _isExpansionPortAttached;
	BOOL _isLED1Illuminated;
	BOOL _isLED2Illuminated;
	BOOL _isLED3Illuminated;
	BOOL _isLED4Illuminated;

	IOBluetoothDevice * _wiiDevice;
	IOBluetoothL2CAPChannel * _ichan;
	IOBluetoothL2CAPChannel * _cchan;

	id _delegate;

	float _lowZ, _lowX;
	int orientation;
	int leftPoint; // is point 0 or 1 on the left. -1 when not tracking.

	WiiExpansionPortType expType;
	WiiAccCalibData wiiCalibData, nunchukCalibData;
	WiiJoyStickCalibData nunchukJoyStickCalibData;
	WiiIRModeType wiiIRMode;
	IRData	irData[4];
	double _batteryLevel;
	double _warningBatteryLevel;
	
	NSTimer * statusTimer;
	IOBluetoothUserNotification * disconnectNotification;
	BOOL buttonState[WiiButtonCount];
	
	//wiimote
	unsigned short accX;
	unsigned short accY;
	unsigned short accZ;
	unsigned short buttonData;	
	
	//nunchuk
	unsigned short nStickX;
	unsigned short nStickY;
	unsigned short nAccX;
	unsigned short nAccY;
	unsigned short nAccZ;
	unsigned short nButtonData;
	
	// classic controller
	unsigned short cButtonData;
	unsigned short cStickX1;
	unsigned short cStickY1;
	unsigned short cStickX2;
	unsigned short cStickY2;
	unsigned short cAnalogL;
	unsigned short cAnalogR;
    
    // guitar hero world tour guitar
    unsigned short wtTouchBar;
    unsigned short wtWhammyBar;
    unsigned short wtButtonDataPlusMinus;
    unsigned short wtButtonDataOther;
} 

- (NSString*) address;
- (void) setDelegate:(id) delegate;
- (double) batteryLevel;

- (WiiExpansionPortType) expansionPortType;
- (BOOL) isExpansionPortAttached;
- (BOOL) available;
- (BOOL) isButtonPressed:(WiiButtonType) type;
- (WiiJoyStickCalibData) joyStickCalibData:(WiiJoyStickType) type;
- (WiiAccCalibData) accCalibData:(WiiAccelerationSensorType) type;

- (IOReturn) connectTo:(IOBluetoothDevice*) device;
- (IOReturn) closeConnection;
- (IOReturn) getCurrentStatus:(NSTimer*) timer;
- (IOReturn) writeData:(const unsigned char*) data at:(unsigned long) address length:(size_t) length;
- (IOReturn) readData:(unsigned long) address length:(unsigned short) length;
- (IOReturn) sendCommand:(const unsigned char*) data length:(size_t) length;

- (void) updateReportMode;
- (IOReturn) doUpdateReportMode;
- (void) setIRSensorEnabled:(BOOL) enabled;
- (void) setForceFeedbackEnabled:(BOOL) enabled;
- (void) setMotionSensorEnabled:(BOOL) enabled;
- (void) setExpansionPortEnabled:(BOOL) enabled;
- (void) setLEDEnabled1:(BOOL) enabled1 enabled2:(BOOL) enabled2 enabled3:(BOOL) enabled3 enabled4:(BOOL) enabled4;

- (IOReturn) getMii:(unsigned int) slot;

- (void) sendWiiRemoteButtonEvent:(UInt16) data;
- (void) sendWiiNunchukButtonEvent:(UInt16) data;
- (void) sendWiiClassicControllerButtonEvent:(UInt16) data;
- (void)sendGuitarHeroWorldTourEvent:(UInt16)data;
- (void)sendGuitarHeroWorldTourFretEvent:(UInt16)data;

@end


@interface NSObject (WiiRemoteDelegate)

- (void) wiimoteWillSendData;
- (void) wiimoteDidSendData;

- (void) irPointMovedX:(float) px Y:(float) py;
- (void) rawIRData: (IRData[4]) irData;
- (void) buttonChanged:(WiiButtonType) type isPressed:(BOOL) isPressed;
- (void) accelerationChanged:(WiiAccelerationSensorType) type accX:(unsigned short) accX accY:(unsigned short) accY accZ:(unsigned short) accZ;
- (void) joyStickChanged:(WiiJoyStickType) type tiltX:(unsigned short) tiltX tiltY:(unsigned short) tiltY;
- (void) analogButtonChanged:(WiiButtonType) type amount:(unsigned short) press;
- (void) batteryLevelChanged:(double) level;
- (void) wiiRemoteDisconnected:(IOBluetoothDevice*) device;
- (void) gotMiiData: (Mii*) mii_data_buf at: (int) slot;

//- (void) dataChanged:(unsigned short)buttonData accX:(unsigned char)accX accY:(unsigned char)accY accZ:(unsigned char)accZ mouseX:(float)mx mouseY:(float)my;


@end
