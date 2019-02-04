//
//  HomeViewModel.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit
import RxSwift

class HomeViewModel {
    
    var backgroundImageName = "background"
    var itemsCount = 2
    var updateUI: PublishSubject<Any?>?
    var pageLabelText: String = "What's New"

    init() {
        self.updateUI = PublishSubject<Any?>()
    }
    
    func viewScrolled(percentageScrolled: Double) {
        switch percentageScrolled {
        case 0 ..< 1:
            pageLabelText = "What's Next"
            
        case 1 ..< 2:
            pageLabelText = "Settings"
            
        default:
            pageLabelText = "\(percentageScrolled)"
        }
        
        self.updateUI?.onNext(nil)
    }
}
