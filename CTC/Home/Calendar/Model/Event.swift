//
//  Event.swift
//  CTC
//
//  Created by Jared Williams on 2/4/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import Foundation

struct Event {
    var title: String?
    var detail: String?
    var location: String?
    var displayColor: String?
    var durationMinutes: Int?
    var date: Date?
    
    enum CodingKeys: String, CodingKey {
        case title
        case detail
        case location
        case displayColor
        case durationMinutes
        case timeStamp
    }
}

extension Event: Decodable
{
    init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decode(String.self, forKey: .title)
        detail = try values.decode(String.self, forKey: .detail)
        location = try values.decode(String.self, forKey: .location)
        displayColor = try values.decode(String.self, forKey: .displayColor)
        durationMinutes = try values.decode(Int.self, forKey: .durationMinutes)
        let timeStamp = try values.decode(TimeInterval.self, forKey: .timeStamp)
        date = Date(timeIntervalSince1970: timeStamp)
    }
}
