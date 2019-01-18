//
//  BioView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit

class BioView: UIView {

    lazy var topLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Futura-Medium", size: 35)
        label.text = """
        ...We're a student
        organization at OSU
        dedicated to creating
        mobile applications for
        charities and nonprofits
        
        
        """
        label.textColor = .white
        label.numberOfLines = 7
        label.alpha = 0.0
        return label
    }()
    
    lazy var bottomLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Futura-Medium", size: 35)
        label.text = """
        
        
        Please enable push
        notifications so that
        you don't miss any
        important events!
        """
        label.textColor = .white
        label.numberOfLines = 6
        label.alpha = 0.0
        return label
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
        autoLayout()
    }
    
    func showView(duration: Double){
        self.backgroundColor = UIColor(red:0.96, green:0.31, blue:0.40, alpha:1.0)
        self.superview?.backgroundColor = UIColor(red:0.96, green:0.31, blue:0.40, alpha:1.0)
        UIView.animate(withDuration: duration, animations: {
            self.topLabel.alpha = 1.0
            self.bottomLabel.alpha = 1.0
        })
    }
    
    func hideView(){
        self.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        self.superview?.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
        self.topLabel.alpha = 0.0
        self.bottomLabel.alpha = 0.0
    }
    
    func autoLayout() {
        topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        topLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        topLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: topLabel.intrinsicContentSize.height).isActive = true
        
        bottomLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        bottomLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        bottomLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
        bottomLabel.heightAnchor.constraint(equalToConstant: bottomLabel.intrinsicContentSize.height).isActive = true
    }
    
}
