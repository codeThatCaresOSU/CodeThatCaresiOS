//
//  testView.swift
//  CTC
//
//  Created by Dave Becker on 3/1/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit

class testView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel(frame: CGRect(x: 10, y: 125, width: frame.width - 20, height: 75))
        label.text = "Code that Cares"
        label.font = label.font.withSize(40)
        self.addSubview(label)
        let myFirstButton = UIButton()
        myFirstButton.setTitle("✸", for: .normal)
        myFirstButton.setTitleColor(.blue, for: .normal)
        myFirstButton.frame = CGRect(x: 100, y: 200, width: 30, height: 30)
        myFirstButton.backgroundColor = .white
        myFirstButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        self.addSubview(myFirstButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pressed() {
        print("pressed")
    }
}
