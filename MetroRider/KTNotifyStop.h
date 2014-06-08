//
//  KTNotifyStop.h
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/14/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AudioToolbox;

@interface KTNotifyStop : NSObject
+(void)_sendBusStopApproachingLocalNotificationNextStop;
+(void)_sendBusStopDidEnterLastStopRegion;
+(void)_sendThreeHundredMetersLocalNotification;
+(void)_sendFinalStopLocalNotification;
+(void)_sendWrongWayAlert;
@end
