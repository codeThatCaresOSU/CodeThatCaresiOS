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
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 500, height: 200))
        label.font = UIFont(name: "Futura-Medium", size: 45)
        label.text = """
                     Welcome
                     To
                     Code That Cares...
                     """
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()
    let animationView: LOTAnimationView = {
        let animationView = LOTAnimationView(contentsOf: URL(string: "https://assets.lottiefiles.com/datafiles/iWEiFJ0uySBMqNg/data.json")!)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.5
        animationView.loopAnimation = true
        return animationView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        animationView.frame = self.bounds
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(welcomeLabel)
        self.addSubview(animationView)
        animationView.play()
    }
}
