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
    
    public static func scheduleNotification(notification: CTCNotification) {
        
        checkAuth() { success in
            if success {
                let differenceInSeconds = abs(notification.date.timeIntervalSinceNow)
                
                let content = UNMutableNotificationContent()
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(differenceInSeconds), repeats: false)
                
                content.title = notification.title
                content.subtitle = notification.subtitle
                content.body = notification.body
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
    
    public static func showNotificationNow(notification: CTCNotification) {
        let content = UNMutableNotificationContent()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        checkAuth() { (success) in
            if success {
                content.title = notification.title
                content.subtitle = notification.subtitle
                content.body = notification.body
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
}
