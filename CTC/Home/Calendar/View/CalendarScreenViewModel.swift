//
//  CalendarViewModel.swift
//  CTC
//
//  Created by Jared Williams on 2/4/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import Foundation
import CTCKit

class CalendarScreenViewModel {

    public var mainLabel: String?
    public var events: [Event]?
    public var eventCount: Int {
        get {
            return self.events?.count ?? 0
        }
    }
    public let API_URL = "https://us-central1-ctcios.cloudfunctions.net/getAllEvents"

    
    // TO-DO Clean this up
    public func getAllEvents(completion: @escaping ([Event]) -> ()){
        self.events = Array<Event>()

        guard let url = URL(string: API_URL) else {return}
        URLSession.shared.dataTask(with: url){(data,response,err) in
            guard let dataResponse = data else {return}
            do{
                self.events = try JSONDecoder().decode([Event].self, from: dataResponse).sorted{ $0.date! < $1.date! }
                DispatchQueue.main.async {
                    guard let events = self.events else { return }
                    self.scheduleNotificationFromEvent(events: events)
                    completion(events)
                    
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
            }.resume()
    }
    
    private func scheduleNotificationFromEvent(events: [Event]) {
        let notifications = events.map({ $0.convertToNotification() })
        notifications.forEach({ NotificationService.scheduleNotification(notification: $0) })
        print("Notifications scheduled")
    }
}
