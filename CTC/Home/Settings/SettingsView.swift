//
//  SettingsView.swift
//  CTC
//
//  Created by Dave Becker on 4/11/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit

protocol ShowGreetingDelegate: class {
    func showGreeting()
}
class SettingsView: UIView {
    
    weak var greetingDelegate: ShowGreetingDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateFrames(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(settingsTableView)
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.cgColor
    }
    
    public func updateFrames(frame: CGRect){
        self.frame = frame
        titleLabel.frame = CGRect(x: 10, y: 10, width: frame.width - 20, height: titleLabel.intrinsicContentSize.height)
        settingsTableView.frame =  CGRect(x: 20, y: titleLabel.frame.maxY + 20, width: frame.width - 40, height: frame.height - settingsTableView.frame.origin.y - 20)
        
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
        tableView.isScrollEnabled = false
        return tableView
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = ReplayIntroCell(frame: frame, spacing: 15)
            cell.greetingDelegate = greetingDelegate
            return cell
        case 1:
            return LinkCell(frame: frame, spacing: 15, text: "Contact us", url: "mailto:codethatcares@gmail.com")
        default:
            return UITableViewCell()
        }
    }
}
