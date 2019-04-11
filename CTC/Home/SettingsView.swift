//
//  SettingsView.swift
//  CTC
//
//  Created by Dave Becker on 4/11/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateFrames(frame: frame)
        self.addSubview(titleLabel)
    }
    
    public func updateFrames(frame: CGRect){
        self.frame = frame
        titleLabel.frame = CGRect(x: 10, y: 10, width: frame.width - 20, height: titleLabel.intrinsicContentSize.height)
        settingsTableView.frame =  CGRect(x: 10, y: titleLabel.frame.maxY + 20, width: frame.width - 20, height: frame.height - settingsTableView.frame.origin.y)
        
        self.setNeedsDisplay()
        titleLabel.setNeedsDisplay()
        settingsTableView.setNeedsDisplay()
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        return label
    }()
    private lazy var settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
        tableView.layer.cornerRadius = 5
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
