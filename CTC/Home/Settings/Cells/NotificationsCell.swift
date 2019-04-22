import UIKit

class NotificationsCell: SettingsCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont(name: "Avenir", size: 24)
        label.text = "Notifications"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var toggle: UISwitch = {
        let toggle = UISwitch()
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    override init(frame: CGRect, spacing: CGFloat) {
        super.init(frame: frame, spacing: spacing)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(label)
        contentView.addSubview(toggle)
        
        toggle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: toggle.leftAnchor, constant: -10).isActive = true
        label.heightAnchor.constraint(equalToConstant: label.intrinsicContentSize.height).isActive = true
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
}
