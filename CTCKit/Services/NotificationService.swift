//
//  NotificationService.swift
//  CTCKit
//
//  Created by Jared Williams on 4/11/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import Foundation
import UserNotifications

open class NotificationService {
    static let NC = UNUserNotificationCenter.current()
    static let NOTIFICATION_ID = "CTC"
    
    public static func scheduleNotification(notification: CTCNotification, negativeOffsetInMinutes: Int = 0) {
        
        checkAuth() { success in
            if success && canSchedule(notification: notification) {
                let differenceInSeconds = notification.date.timeIntervalSinceNow - Double((negativeOffsetInMinutes * 60))
                
                
                let content = UNMutableNotificationContent()
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(differenceInSeconds), repeats: false)
                
                content.title = notification.title
                content.subtitle = notification.subtitle
                content.body = notification.body
                content.badge = 1
                content.sound = UNNotificationSound.default
                
                let request = UNNotificationRequest(identifier: NOTIFICATION_ID, content: content, trigger: trigger)
                NC.add(request) { (error: Error?) in
                    if error != nil {
                     print(error.debugDescription)
                    } else {
                        print("Scheduled notification for  \(request) in \(trigger.nextTriggerDate()) \(trigger.timeInterval )")
                    }
                }
                
                
            } else {
                requestAuth(completion: nil)
                print("Notification already scheduled or access denied")
            }
        }
    }
    
    public static func showNotificationNow(notification: CTCNotification) {
        let content = UNMutableNotificationContent()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        checkAuth() { (success) in
            if success {
                content.title = notification.title
                content.subtitle = notification.subtitle
                content.body = notification.body ?? ""
                content.badge = 1
                
                
                let request = UNNotificationRequest(identifier: NOTIFICATION_ID, content: content, trigger: trigger)
                NC.add(request) { (error) in
                    print(error.debugDescription)
                }
            } else {
                requestAuth(completion: nil)
            }
        }
    }
    
    public static func requestAuth(completion: ((Bool) -> ())?) {
        NC.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            completion?(success)
        }
    }
    
    private static func checkAuth(completion: @escaping (Bool) -> ()) {
        NC.getNotificationSettings() { (settings) in
            completion(settings.authorizationStatus == .authorized)
        }
    }
    
    private static func canSchedule(notification: CTCNotification) -> Bool {
        return !PersistenceService.isNotificationsStored(notification: notification) //&& !isNotificationInPast(notification: notification)
    }
    
    private static func isNotificationInPast(notification: CTCNotification) -> Bool {
        let timeDiff = notification.date.timeIntervalSince(Date())
        return timeDiff >= 0
    }
}
