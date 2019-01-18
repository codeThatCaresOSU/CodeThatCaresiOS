//
//  WelcomeView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit
//import Lottie

class WelcomeView: UIView {

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Futura-Medium", size: 45)
        label.text = """
                     Welcome To
                     Code That Cares...
                     """
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(welcomeLabel)
        autoLayout()
    }
    
    func autoLayout() {
        welcomeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: welcomeLabel.intrinsicContentSize.height).isActive = true
    }
}

