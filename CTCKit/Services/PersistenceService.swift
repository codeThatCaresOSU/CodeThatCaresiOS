//
//  PersistenceService.swift
//  CTCKit
//
//  Created by Jared Williams on 4/12/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import Foundation

class PersistenceService {
    
    private static let NOTIFICATIONS_KEY = "notifications"
    private static let UD = UserDefaults.standard
    
    public static func addFutureNotificationToUD(notification: CTCNotification) {
        guard let notifications = UD.array(forKey: NOTIFICATIONS_KEY) as? [CTCNotification] else { return }
        
        var newArray = [CTCNotification]()
        notifications.forEach() { newArray.append($0) }
        newArray.append(notification)
        
        UD.setValue(newArray, forKey: NOTIFICATIONS_KEY)
    }
}
