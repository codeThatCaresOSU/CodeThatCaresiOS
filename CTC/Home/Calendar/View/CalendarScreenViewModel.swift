//
//  CalendarViewModel.swift
//  CTC
//
//  Created by Jared Williams on 2/4/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import Foundation
import CTCKit
import EventKit

class CalendarScreenViewModel {

    public var mainLabel: String?
    public var events: [Event]?
    public var eventCount: Int {
        get {
            return self.events?.count ?? 0
        }
    }
    public let API_URL = "https://us-central1-ctcios.cloudfunctions.net/getAllEvents"
    private let store = EKEventStore()
    
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
                    completion(events)
                    
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
            }.resume()
    }
    
    // TODO: Fix bug where events can be added multiple times to the calendar
    func addToCalendar(title: String, eventStartDate: Date, eventEndDate: Date, location: String, detail: String, completion: @escaping (Bool, Event?) -> ()) {
        store.requestAccess(to: .event) { (success, error) in
            
            if  error == nil {
                let event = EKEvent.init(eventStore: self.store)
                event.title = title
                event.calendar = self.store.defaultCalendarForNewEvents
                event.startDate = eventStartDate
                event.endDate = eventEndDate
                event.location = location
                event.notes = detail
                
                do {
                    try self.store.save(event, span: .thisEvent)
                    
                    let ctcEvent = Event(title: title, detail: detail, location: location, displayColor: nil, durationMinutes: Date.determineEventDurationInMinutes(startDate: eventStartDate, endDate: eventEndDate), date: eventStartDate)
            
                    
                    DispatchQueue.main.async {
                        completion(true, ctcEvent)
                    }
                } catch let error as NSError {
                    print("Failed to add event with error: \(error)")
                    DispatchQueue.main.async {
                        completion(false, nil)
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
            }
        }
    }
    
    public func scheduleNotificationFromEvent(events: [Event], negativeOffsetInMinutes: Int = 0) {
        let notifications = events.map({ $0.convertToNotification() })
        notifications.forEach() {
            NotificationService.scheduleNotification(notification: $0, negativeOffsetInMinutes: negativeOffsetInMinutes)
        }
    }
}
