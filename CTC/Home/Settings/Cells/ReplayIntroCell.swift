import UIKit

class ReplayIntroCell: SettingsCell {
    
    weak var greetingDelegate: ShowGreetingDelegate?
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont(name: "Avenir", size: 24)
        button.setTitle("Replay intro", for: .normal)
        button.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect, spacing: CGFloat) {
        super.init(frame: frame, spacing: spacing)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(button)
        button.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -10).isActive = true
        button.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10).isActive = true
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    @objc func buttonPressed(){
        greetingDelegate?.showGreeting()
    }
}
