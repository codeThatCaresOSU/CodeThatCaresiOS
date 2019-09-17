import UIKit

class SettingsCell: UITableViewCell {
    
    let borderWidth: CGFloat = 4
    var cellSpacing: CGFloat = 5
    let cornerRadius: CGFloat = 8
    
    init(frame: CGRect, spacing: CGFloat) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cellSpacing = spacing
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: borderWidth, bottom: cellSpacing, right: borderWidth))
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = borderWidth
        layer.shadowOffset = CGSize(width: 0, height: borderWidth)
        layer.shadowColor = UIColor.black.cgColor
        contentView.backgroundColor = UIColor(hexString: "#F8F8FF")
        contentView.layer.cornerRadius = cornerRadius
    }
    
}
