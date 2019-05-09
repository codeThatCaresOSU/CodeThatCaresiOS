//
//  PersistenceService.swift
//  CTCKit
//
//  Created by Jared Williams on 4/12/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import Foundation

open class PersistenceService {
    
    private static let NOTIFICATIONS_KEY = "notifications"
    private static let UD = UserDefaults.standard
    
    public static func addFutureNotificationToUD(notification: CTCNotification) {
        guard let notifications = UD.array(forKey: NOTIFICATIONS_KEY) as? [CTCNotification] else { return }
        
        var newArray = [CTCNotification]()
        notifications.forEach() { newArray.append($0) }
        newArray.append(notification)
        
        UD.setValue(newArray, forKey: NOTIFICATIONS_KEY)
    }
    
    public static func notificationsCount() -> Int {
        guard let notifications = UD.array(forKey: NOTIFICATIONS_KEY) as? [CTCNotification] else { return 0}
        return notifications.count
    }
    
    public static func isNotificationsStored(notification: CTCNotification) -> Bool {
        
        guard let storedNotifications = UD.array(forKey: NOTIFICATIONS_KEY) as? [CTCNotification] else { return false }
        
        return storedNotifications.contains(where: {$0.body == notification.body && $0.date.hashValue == notification.date.hashValue && $0.title == notification.title})
    }
    
    private static func cleanUpOldNotifications() {
        guard let notifications = UD.array(forKey: NOTIFICATIONS_KEY) as? [CTCNotification] else { return }
        var newNotifications = [CTCNotification]()
        notifications.forEach({
            let date = $0.date
            let currentDate = Date()
            
            if currentDate.timeIntervalSince1970 < date?.timeIntervalSince1970 ?? 0 {
                newNotifications.append($0)
            }
        })
        
        UD.setValue(newNotifications, forKey: NOTIFICATIONS_KEY)
    }
}
