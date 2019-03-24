import UIKit

protocol calendarDelegate: class {
    func addToCalendar(title: String, eventStartDate: Date, eventEndDate: Date, location: String, detail: String)
}

class EventCell: UITableViewCell {
    
    weak var cellCalendarDelegate: calendarDelegate?
    var event: Event?
    
    let borderWidth: CGFloat = 4
    let cellSpacing: CGFloat = 10
    let cornerRadius: CGFloat = 8
    
    private lazy var leftContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: event!.displayColor!)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var rightContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = event!.title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = event!.location
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var detailLabel: UITextView = {
        let textView = UITextView()
        textView.text = event!.detail
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textColor = .black
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "\(event!.day!)"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(event!.time!) \(event!.amORpm!)"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = DateFormatter().monthSymbols[event!.month! - 1]
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    private lazy var addToCalendarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .blue
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        button.layer.cornerRadius = 4
        let color = UIColor(hexString: event!.displayColor!)
        button.setTitleColor(color, for: .normal)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(frame: CGRect, title: String, date: String, location: String, time: String, length: String) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: cellSpacing, bottom: cellSpacing, right: cellSpacing))
        addToCalendarButton.addTarget(self, action: #selector(addButtonPressed(_:)), for: .touchUpInside)
        contentView.layer.borderColor = UIColor(hexString: event!.displayColor!).cgColor
        contentView.layer.borderWidth = borderWidth
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = borderWidth
        layer.shadowOffset = CGSize(width: 0, height: borderWidth)
        layer.shadowColor = UIColor.black.cgColor
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = cornerRadius
        
        contentView.addSubview(leftContainer)
        contentView.addSubview(rightContainer)
        leftContainer.addSubview(dayLabel)
        leftContainer.addSubview(monthLabel)
        leftContainer.addSubview(timeLabel)
        leftContainer.addSubview(addToCalendarButton)
        rightContainer.addSubview(titleLabel)
        rightContainer.addSubview(detailLabel)
        rightContainer.addSubview(locationLabel)
        rightContainer.layer.cornerRadius = cornerRadius
        rightContainer.layer.borderWidth = borderWidth
        rightContainer.layer.borderColor = UIColor(hexString: event!.displayColor!).cgColor
        contentView.addSubview(titleLabel)
        constrain()
    }
    
    func constrain(){
        leftContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        leftContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        leftContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        leftContainer.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        rightContainer.leftAnchor.constraint(equalTo: leftContainer.rightAnchor, constant: -borderWidth).isActive = true
        rightContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        rightContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        rightContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        dayLabel.topAnchor.constraint(equalTo: leftContainer.topAnchor, constant: 10).isActive = true
        dayLabel.heightAnchor.constraint(equalToConstant: dayLabel.intrinsicContentSize.height).isActive = true
        dayLabel.centerXAnchor.constraint(equalTo: leftContainer.centerXAnchor).isActive = true
        dayLabel.widthAnchor.constraint(equalToConstant: dayLabel.intrinsicContentSize.width).isActive = true

        monthLabel.topAnchor.constraint(equalTo: dayLabel.bottomAnchor).isActive = true
        monthLabel.heightAnchor.constraint(equalToConstant: monthLabel.intrinsicContentSize.height).isActive = true
        monthLabel.centerXAnchor.constraint(equalTo: leftContainer.centerXAnchor).isActive = true
        monthLabel.widthAnchor.constraint(equalToConstant: monthLabel.intrinsicContentSize.width).isActive = true

        timeLabel.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 10).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: timeLabel.intrinsicContentSize.height).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: leftContainer.centerXAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: timeLabel.intrinsicContentSize.width).isActive = true
        
        titleLabel.widthAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: rightContainer.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: rightContainer.topAnchor, constant: 20).isActive = true
        
        detailLabel.widthAnchor.constraint(equalTo: rightContainer.widthAnchor, constant: -20).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        detailLabel.centerXAnchor.constraint(equalTo: rightContainer.centerXAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -5).isActive = true
        
        locationLabel.widthAnchor.constraint(equalToConstant: locationLabel.intrinsicContentSize.width).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: locationLabel.intrinsicContentSize.height).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: rightContainer.centerXAnchor).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: rightContainer.bottomAnchor, constant: -10).isActive = true
        
        addToCalendarButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addToCalendarButton.centerXAnchor.constraint(equalTo: leftContainer.centerXAnchor).isActive = true
        addToCalendarButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5).isActive = true
        addToCalendarButton.bottomAnchor.constraint(equalTo: leftContainer.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func addButtonPressed(_ sender: UIButton){
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .minute, value: event!.durationMinutes!, to: event!.startDate!)
        cellCalendarDelegate?.addToCalendar(title: "CTC - \(event!.title!)", eventStartDate: event!.startDate!, eventEndDate: endDate!, location: event!.location!, detail: event!.detail!)
    }
}
