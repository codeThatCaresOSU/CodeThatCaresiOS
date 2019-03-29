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
    let decoder = JSONDecoder()

    public func getAllEvents(completion: @escaping ([Event]) -> ()){
        self.events = Array<Event>()
        let urlString = "https://us-central1-ctcios.cloudfunctions.net/getAllEvents"

        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url){(data,response,err) in
            guard let dataResponse = data else {return}
            do{
                self.events = try self.decoder.decode([Event].self, from: dataResponse)
                DispatchQueue.main.async {
                    completion(self.events!.sorted(by: { $0.date! < $1.date! }))
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
            }.resume()
    }
}
