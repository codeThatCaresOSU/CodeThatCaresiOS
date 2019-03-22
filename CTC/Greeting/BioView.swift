//
//  BioView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit

protocol bulletinDelegate: class {
    func showBulletin()
}

class BioView: UIView {
    
    weak var delegate: bulletinDelegate?
    
    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Futura-Medium", size: 35)
        label.text = "We're a student organization at OSU dedicated to creating mobile applications for charities and nonprofits."
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.alpha = 0.0
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Futura-Medium", size: 35)
        label.text = "Please enable push notifications to stay up to date on meetings and important events!"
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.alpha = 0.0
        return label
    }()
    
    lazy var readyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Started", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.black
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(readyButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.addSubview(topLabel)
        self.addSubview(bottomLabel)
        self.addSubview(readyButton)
        autoLayout()
    }
    
    func showView(duration: Double){
        self.backgroundColor = Globals.constants.ctcColor
        self.superview?.backgroundColor = Globals.constants.ctcColor
        UIView.animate(withDuration: duration, animations: {
            self.topLabel.alpha = 1.0
            self.bottomLabel.alpha = 1.0
            self.readyButton.alpha = 1.0
        })
    }
    
    func hideView(){
        self.backgroundColor = Globals.constants.backgroundColor
        self.superview?.backgroundColor = Globals.constants.backgroundColor
        self.topLabel.alpha = 0.0
        self.bottomLabel.alpha = 0.0
        self.readyButton.alpha = 0.0
    }
    
    func autoLayout() {
        topLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        topLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        topLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        bottomLabel.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        bottomLabel.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        readyButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        readyButton.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        readyButton.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor, constant: -10).isActive = true
        
        bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 60).isActive = true
        readyButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func readyButtonPressed() {
        delegate?.showBulletin()
    }
    
}
