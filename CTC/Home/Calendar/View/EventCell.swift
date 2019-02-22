import UIKit

class EventCell: UITableViewCell {
    var cellAddButton: UIButton!
    var cellTitle: UILabel!
    var cellDate: UILabel!
    var cellTime: UILabel!
    var cellLength: UILabel!
    var cellLocation: UILabel!
    
    private var viewModel: EventCellViewModel?
    
    
    convenience init(event: Event, frame: CGRect) {
        self.init()
        self.viewModel = EventCellViewModel(event: event)
    }
    
    // Do the above instead
    init(frame: CGRect, title: String, date: String, location: String, time: String, length: String) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        cellTitle = UILabel(frame: CGRect(x: 5, y: 15, width: frame.width/1.5, height: frame.height/3 - 5))
        cellTitle.text = title
        cellTitle.font = cellTitle.font.withSize(20)
        addSubview(cellTitle)
        
        cellDate = UILabel(frame: CGRect(x: 5, y: frame.height / 3 + 10, width: frame.width/4, height: frame.height/3 - 10))
        cellDate.text = date
        addSubview(cellDate)
        
        cellLocation = UILabel(frame: CGRect(x: cellDate.intrinsicContentSize.width + 2, y: frame.height / 3 + 10, width: frame.width/2, height: frame.height/3 - 10))
        cellLocation.text = "  - " + location
        addSubview(cellLocation)
        
        cellTime = UILabel(frame: CGRect(x: 5, y: frame.height * 2 / 3, width: frame.width/2, height: frame.height/3))
        cellTime.text = time
        addSubview(cellTime)
        
        cellLength = UILabel(frame: CGRect(x: cellTime.intrinsicContentSize.width + 2, y: frame.height * 2 / 3, width: frame.width/2, height: frame.height/3))
        cellLength.text = "  - " + length
        addSubview(cellLength)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
