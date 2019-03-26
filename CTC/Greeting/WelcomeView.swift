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
        label.font = UIFont(name: "Futura-Bold", size: 45)
        label.text = "Welcome To \nCode That Cares!"
        label.textColor = Globals.constants.greyColor
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var swipeAnimationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "scrolldown2-dark")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopAnimation = true
        return animationView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Globals.constants.ctcColor
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(welcomeLabel)
        swipeAnimationView.play()
        self.addSubview(swipeAnimationView)
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        welcomeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        welcomeLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        welcomeLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        swipeAnimationView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        swipeAnimationView.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor).isActive = true
        swipeAnimationView.heightAnchor.constraint(equalToConstant: 140).isActive = true
    }
    
    func setSwipeAlpha(alpha: CGFloat, duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.swipeAnimationView.alpha = alpha
        })
    }
}
