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
    public var eventCount: Int {
        get {
            return self.events?.count ?? 0
        }
    }
    public func getAllEvents(completion: @escaping ([Event]) -> ()){
        self.events = Array<Event>()
        
        let urlString = "https://us-central1-ctcios.cloudfunctions.net/getAllEvents"
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url){(data,response,err) in
            guard let dataResponse = data,
                err == nil else {
                    print(err?.localizedDescription ?? "Response Error")
                    return }
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
//                print(jsonResponse)
                
                guard let jsonArray = jsonResponse as? [[String: Any]] else {return}
                
                for dic in jsonArray{
                    var event = Event()
                    
                    guard let title = dic["title"] as? String else { return }
                    guard let detail = dic["detail"] as? String else { return }
                    guard let location = dic["location"] as? String else { return }
                    guard let month = dic["month"] as? Int else { return }
                    guard let day = dic["day"] as? Int else { return }
                    guard let year = dic["year"] as? Int else { return }
                    guard let time = dic["time"] as? String else { return }
                    guard let amORpm = dic["amORpm"] as? String else { return }
                    guard let durationMinutes = dic["durationMinutes"] as? Int else { return }
                    guard let displayColor = dic["displayColor"] as? String else { return }
                    
                    event.title = title
                    event.detail = detail
                    event.location = location
                    event.month = month
                    event.day = day
                    event.year = year
                    event.time = time
                    event.amORpm = amORpm
                    event.durationMinutes = durationMinutes
                    event.displayColor = displayColor
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "h:mm a MM/dd/yyyy"
                    let startDate = formatter.date(from: "\(time) \(amORpm) \(month)/\(day)/\(year)")
                    event.startDate = startDate
                    self.events?.append(event)
                }
                self.events = self.events!.sorted(by: { $0.startDate! < $1.startDate!})
                DispatchQueue.main.async {
                    completion(self.events!)
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }.resume()
    }
}
