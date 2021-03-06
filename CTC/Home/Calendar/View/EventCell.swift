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
        label.text = "Title"
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var detailLabel: UITextView = {
        let textView = UITextView()
        textView.text = "Details"
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textColor = .black
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    private lazy var leftStack: UIStackView = {
        let stack = UIStackView()
        stack.addArrangedSubview(dayLabel)
        stack.addArrangedSubview(monthLabel)
        stack.addArrangedSubview(timeLabel)
        stack.addArrangedSubview(calendarButtonContainer)
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    private lazy var dayLabel: UILabelPadding = {
        let label = UILabelPadding(padding: UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0))
        label.text = "1"
        label.baselineAdjustment = .alignCenters
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        return label
    }()
    private lazy var timeLabel: UILabelPadding = {
        let label = UILabelPadding(padding: UIEdgeInsets(top: -2, left: 0, bottom: -2, right: 0))
        label.text = "2:30 PM"
        label.baselineAdjustment = .alignCenters
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    private lazy var monthLabel: UILabelPadding = {
        let label = UILabelPadding(padding: UIEdgeInsets(top: -2, left: 0, bottom: -2, right: 0))
        label.text = DateFormatter().monthSymbols[1]
        label.baselineAdjustment = .alignCenters
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    private lazy var calendarButtonContainer: UIView = {
        let view = UIView()
        view.addSubview(addToCalendarButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var addToCalendarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .blue
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        button.layer.cornerRadius = 4
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
//        enableBorder()
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = borderWidth
        layer.shadowOffset = CGSize(width: 0, height: borderWidth)
        layer.shadowColor = UIColor.black.cgColor
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = cornerRadius
        dayLabel.sizeToFit()
        
        contentView.addSubview(leftContainer)
        contentView.addSubview(rightContainer)
        leftContainer.addSubview(leftStack)
        rightContainer.addSubview(titleLabel)
        rightContainer.addSubview(detailLabel)
        rightContainer.addSubview(locationLabel)
        rightContainer.layer.cornerRadius = cornerRadius
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
        
        leftStack.widthAnchor.constraint(equalTo: leftContainer.widthAnchor).isActive = true
        leftStack.heightAnchor.constraint(equalTo: leftContainer.heightAnchor, constant: -30).isActive = true
        leftStack.centerYAnchor.constraint(equalTo: leftContainer.centerYAnchor).isActive = true
        leftStack.centerXAnchor.constraint(equalTo: leftContainer.centerXAnchor).isActive = true
        
        addToCalendarButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addToCalendarButton.heightAnchor.constraint(equalTo: calendarButtonContainer.heightAnchor).isActive = true
        addToCalendarButton.centerYAnchor.constraint(equalTo: calendarButtonContainer.centerYAnchor).isActive = true
        addToCalendarButton.centerXAnchor.constraint(equalTo: calendarButtonContainer.centerXAnchor).isActive = true
        
        calendarButtonContainer.centerXAnchor.constraint(equalTo: leftStack.centerXAnchor).isActive = true
        calendarButtonContainer.widthAnchor.constraint(equalTo: leftStack.widthAnchor).isActive = true
        calendarButtonContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true

        titleLabel.widthAnchor.constraint(equalTo: rightContainer.widthAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: rightContainer.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: rightContainer.topAnchor, constant: 20).isActive = true
        
        detailLabel.widthAnchor.constraint(equalTo: rightContainer.widthAnchor, constant: -20).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
        detailLabel.centerXAnchor.constraint(equalTo: rightContainer.centerXAnchor).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: locationLabel.topAnchor, constant: -5).isActive = true
        
        locationLabel.widthAnchor.constraint(equalTo: rightContainer.widthAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: locationLabel.intrinsicContentSize.height).isActive = true
        locationLabel.centerXAnchor.constraint(equalTo: rightContainer.centerXAnchor).isActive = true
        locationLabel.bottomAnchor.constraint(equalTo: rightContainer.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func addButtonPressed(_ sender: UIButton){
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .minute, value: event!.durationMinutes!, to: event!.date!)
        cellCalendarDelegate?.addToCalendar(title: "CTC - \(event!.title!)", eventStartDate: event!.date!, eventEndDate: endDate!, location: event!.location!, detail: event!.detail!)
        print(event?.date)
    }
    
    public func updateUI(){
        let color = event?.displayColor ?? "#ffffff"
        leftContainer.backgroundColor = UIColor(hexString: color)
        titleLabel.text = event?.title ?? "Title"
        locationLabel.text = event?.location ?? "location"
        detailLabel.text = event?.detail ?? "Detail"
        let date = event?.date ?? Date()
        let day = Calendar.current.component(.day, from: date)
        dayLabel.text = "\(day)"
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let time = formatter.string(from: date)
        timeLabel.text = "\(time)"
        let month = Calendar.current.component(.month, from: date)
        monthLabel.text = DateFormatter().monthSymbols[month - 1]
        let buttonColor = UIColor(hexString: color)
        addToCalendarButton.setTitleColor(buttonColor, for: .normal)
        contentView.layer.borderColor = UIColor(hexString: color).cgColor
        rightContainer.layer.borderColor = UIColor(hexString: color).cgColor
    }
    
    func enableBorder(){
        contentView.layer.borderWidth = borderWidth
        rightContainer.layer.borderWidth = borderWidth
    }
}
