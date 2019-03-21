import UIKit

class EventCell: UITableViewCell {
    var title: String!
    var location: String!
    var detail: String!
    var day: String!
    var time: String!
    var month: String!
    
    private var viewModel: EventCellViewModel?
    
    private lazy var leftContainer: UIView = {
        let view = UIView()
        view.backgroundColor = Globals.constants.purpleColor
//        view.backgroundColor = Globals.constants.darkCTCColor
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
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = location
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var detailLabel: UITextView = {
        let textView = UITextView()
        textView.text = detail
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
        label.text = day
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = time
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = month
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    private let addToCalendarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .blue
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        button.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        button.layer.cornerRadius = 4
        button.setTitleColor(Globals.constants.purpleColor, for: .normal)
        button.backgroundColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    convenience init(event: Event, frame: CGRect) {
        self.init()
        self.viewModel = EventCellViewModel(event: event)
    }
    
    init(frame: CGRect, title: String, date: String, location: String, time: String, length: String) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = UIColor.white
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(leftContainer)
        addSubview(rightContainer)
        leftContainer.addSubview(dayLabel)
        leftContainer.addSubview(monthLabel)
        leftContainer.addSubview(timeLabel)
        leftContainer.addSubview(addToCalendarButton)
        rightContainer.addSubview(titleLabel)
        rightContainer.addSubview(detailLabel)
        rightContainer.addSubview(locationLabel)
        addSubview(titleLabel)
        constrain()
    }
    
    func constrain(){
        leftContainer.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        leftContainer.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        leftContainer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        leftContainer.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        rightContainer.leftAnchor.constraint(equalTo: leftContainer.rightAnchor).isActive = true
        rightContainer.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        rightContainer.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rightContainer.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
