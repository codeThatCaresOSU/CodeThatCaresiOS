//
//  CalendarViewModel.swift
//  CTC
//
//  Created by Jared Williams on 2/4/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import Foundation


class CalendarScreenViewModel {
    
    public var mainLabel: String?
    public var events: [Event]?
//    public var eventCount: Int {
//        get {
//            return self.events?.count ?? 0
//        }
//    }
    public var eventCount = 20
    
    init() {
        self.events = Array<Event>()
        var event = Event()
        event.length = 1
        event.date = Date()
        event.location = "Enarson 245"
        event.time = "7:00pm"
        event.title = "UX Technical"
    }
}
