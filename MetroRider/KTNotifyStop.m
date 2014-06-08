//
//  KTNotifyStop.m
//  MetroRider
//
//  Created by Kevin Taniguchi on 4/14/14.
//  Copyright (c) 2014 Taniguchi. All rights reserved.
//

#import "KTNotifyStop.h"

@implementation KTNotifyStop
+(void)_sendBusStopApproachingLocalNotificationNextStop{
    UILocalNotification *stopNotification = [[UILocalNotification alloc]init];
    stopNotification.alertBody = @"Your Next Stop is Your Stop!";
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    stopNotification.alertAction = @"Ok";
    stopNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication]presentLocalNotificationNow:stopNotification];
}

+(void)_sendThreeHundredMetersLocalNotification{
    UILocalNotification *stopNotification = [[UILocalNotification alloc]init];
    stopNotification.alertBody = @"Your Stop is Coming Up Soon!";
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    stopNotification.alertAction = @"Ok";
    stopNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication]presentLocalNotificationNow:stopNotification];
}

+(void)_sendBusStopDidEnterLastStopRegion{
    UILocalNotification *stopNotification = [[UILocalNotification alloc]init];
    stopNotification.alertBody = @"Entered last stop region!";
    stopNotification.alertAction = @"Ok";
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    stopNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication]presentLocalNotificationNow:stopNotification];
}

+(void)_sendFinalStopLocalNotification{
    UILocalNotification *stopNotification = [[UILocalNotification alloc]init];
    stopNotification.alertBody = @"This is your stop";
    stopNotification.alertAction = @"Ok";
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    stopNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication]presentLocalNotificationNow:stopNotification];
}

+(void)_sendWrongWayAlert{
    UILocalNotification *stopNotification = [[UILocalNotification alloc]init];
    stopNotification.alertBody = @"Warning: Possibly going in the wrong direction";
    stopNotification.alertAction = @"Ok";
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    stopNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication]presentLocalNotificationNow:stopNotification];
}

@end
