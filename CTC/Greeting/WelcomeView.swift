//
//  WelcomeView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit
import Lottie

class WelcomeView: UIView {

    lazy var welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Futura-Medium", size: 45)
        label.text = "Welcome To \nCode That Cares..."
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let swipeAnimationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "scrolldown")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 1.0
        animationView.loopAnimation = true
        return animationView
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
        swipeAnimationView.play()
        self.addSubview(swipeAnimationView)
        autoLayout()
    }
    
    func autoLayout() {
        welcomeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: welcomeLabel.intrinsicContentSize.height).isActive = true

        swipeAnimationView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        swipeAnimationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        swipeAnimationView.widthAnchor.constraint(equalToConstant: 800).isActive = true
        swipeAnimationView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
}

