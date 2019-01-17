//
//  CalendarView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit

class CalendarView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = UILabel(frame: CGRect(x: self.frame.midX, y: self.frame.midY, width: 100, height: 100))
        label.text = "Deez Nuts"
        self.addSubview(label)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
