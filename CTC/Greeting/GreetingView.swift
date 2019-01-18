//
//  GreetingView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit

class GreetingView: UIScrollView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentSize = CGSize(width: self.frame.width, height: self.frame.height * 2)
        self.addSubview(welcomeView)
        self.addSubview(bioView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var welcomeView = WelcomeView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
    lazy var bioView = BioView(frame: CGRect(x: 0, y: self.frame.maxY, width: self.frame.width, height: self.frame.height))
    
}
