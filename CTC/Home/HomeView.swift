//
//  HomeView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit
import BLTNBoard
import LUNSegmentedControl

@available(iOS 11.0, *)
class HomeView: UIViewController, bulletinDelegate {

    private var viewModel: HomeViewModel = HomeViewModel()
    let pageTitles = ["Home", "Calendar", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Globals.constants.backgroundColor
        
        view.addSubview(backgroundScrollView)
        view.addSubview(segmentedControl)
        constrainSegmentedControl()

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
//        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            view.addSubview(greetingView)
            greetingView.bioView.delegate = self
            prepareForBulletin()
//            self.viewModel.updateUi?.subscribe({ (event) in
//                self.updateUI()
//            })
//        }

        /* Temporary fix for swiping until I find a better way to handle this */
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.segmentedControl(self.segmentedControl, didScrollWithXOffset: 0)
    }

    private lazy var greetingView = GreetingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    
    lazy var segmentedControl: LUNSegmentedControl = {
        let seg = LUNSegmentedControl()
        seg.delegate = self
        seg.dataSource = self
        seg.selectorViewColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0)
        seg.backgroundColor = UIColor(red: 37.0/255.0, green: 37.0/255.0, blue: 37.0/255.0, alpha: 0.5)
        seg.cornerRadius = 15
        seg.applyCornerRadiusToSelectorView = true
        seg.translatesAutoresizingMaskIntoConstraints = false
        return seg
    }()
    lazy var backgroundScrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: CGRect(x:0, y:0, width: view.bounds.width, height: view.bounds.height))
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        scrollView.isUserInteractionEnabled = true
        let background = UIImageView(image: UIImage(named: "background"))
        background.isUserInteractionEnabled = true
        /* Width adds 1.5x to account for scrolling slightly past the end of the first and last page.
         To add a 4th page, use this code:
         background.frame = CGRect(x: -view.bounds.width * 1.5 / 2, y: 0, width: view.bounds.width * 4 + view.bounds.width * 1.5, height: view.bounds.height)
         */
        background.frame = CGRect(x: -view.bounds.width * 1.5 / 2, y: 0, width: view.bounds.width * 3 + view.bounds.width * 1.5, height: view.bounds.height)
        background.addSubview(view1)
        background.addSubview(view2)
        background.addSubview(settings)
        scrollView.addSubview(background)
        return scrollView
    }()
    /* Each new page must add to the x point view.bounds.width to keep it aligned in scrollview.
     To add a 4th page, use this code:
     lazy var templateView4 = CalendarView(frame: CGRect(x: view.bounds.width * 1.5 / 2 + view.bounds.width * 3, y: 0, width: view.bounds.width, height: view.bounds.height))
     */
    lazy var view1 = CalendarView(frame: CGRect(x: view.bounds.width * 1.5 / 2, y: 0, width: view.bounds.width, height: view.bounds.height))
    lazy var view2 = CalendarView(frame: CGRect(x: view.bounds.width * 1.5 / 2 + view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height))
    lazy var settings = CalendarView(frame: CGRect(x: view.bounds.width * 1.5 / 2 + view.bounds.width * 2, y: 0, width: view.bounds.width, height: view.bounds.height))

    lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = notificationBulletin
        return BLTNItemManager(rootItem: rootItem)
    }()
    lazy var notificationBulletin: BLTNPageItem = {
        let page = BLTNPageItem(title: "Push Notifications")
        page.descriptionText = "Please enable push notifications to hear about meetings and important events."
        page.actionButtonTitle = "Subscribe"
        page.image = UIImage(named: "notification")
        page.alternativeButtonTitle = "Nah"
        page.isDismissable = false
        page.requiresCloseButton = false
        return page
    }()
    
    func prepareForBulletin(){
        notificationBulletin.actionHandler = {(item: BLTNActionItem) in
            UserDefaults.standard.set(true, forKey: "setupComplete")
            self.bulletinManager.dismissBulletin()
            self.greetingView.removeFromSuperview()
        }
        notificationBulletin.alternativeHandler = {(item: BLTNActionItem) in
            UserDefaults.standard.set(true, forKey: "setupComplete")
            self.bulletinManager.dismissBulletin()
            self.greetingView.removeFromSuperview()
        }
    }
    func showBulletin(){
        bulletinManager.backgroundViewStyle = .blurredDark
        bulletinManager.showBulletin(above: self)
    }
    
    /* Temporary function to handle gestures */
    @objc func handleSwipes(_ sender:UISwipeGestureRecognizer) {
        if (sender.direction == .left) {
            if (segmentedControl.currentState != 2) {
                segmentedControl.setCurrentState(segmentedControl.currentState + 1, animated: true)
            }
        }
        if (sender.direction == .right) {
            if (segmentedControl.currentState != 0) {
                segmentedControl.setCurrentState(segmentedControl.currentState - 1, animated: true)
            }
        }
    }
    
    /*
     Constraints
     */
    func constrainSegmentedControl(){
        segmentedControl.widthAnchor.constraint(equalToConstant: 350).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

@available(iOS 11.0, *)
extension HomeView: LUNSegmentedControlDataSource, LUNSegmentedControlDelegate {
    
    func numberOfStates(in segmentedControl: LUNSegmentedControl!) -> Int {
        return 3
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, attributedTitleForStateAt index: Int) -> NSAttributedString! {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 12)!]
        return NSAttributedString(string: pageTitles[index], attributes: attrs)
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, attributedTitleForSelectedStateAt index: Int) -> NSAttributedString! {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 16)!]
        return NSAttributedString(string: pageTitles[index], attributes: attrs)
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, didScrollWithXOffset offset: CGFloat) {
        let maxOffset: CGFloat = self.segmentedControl.frame.size.width/CGFloat(self.segmentedControl.statesCount)
        let width: CGFloat = self.view.frame.size.width
        let leftDistance: CGFloat = (self.backgroundScrollView.contentSize.width - width)
        let rightDistance: CGFloat = (self.backgroundScrollView.contentSize.width - width)
        let backgroundScrollViewOffset: CGFloat = leftDistance + ((offset / maxOffset) * (self.backgroundScrollView.contentSize.width - rightDistance - leftDistance))
        backgroundScrollView.setContentOffset(CGPoint(x: backgroundScrollViewOffset, y: 0), animated: false)
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, gradientColorsForStateAt index: Int) -> [UIColor]! {
        switch(index){
        case 0:
            return [UIColor(red:0.63, green:0.87, blue:0.22, alpha:1.0), UIColor(red:0.69, green:1.00, blue:0.00, alpha:1.0)]
        case 1:
            return [UIColor(red:0.31, green:0.99, blue:0.82, alpha:1.0), UIColor(red:0.20, green:0.78, blue:0.96, alpha:1.0)]
        case 2:
            return [UIColor(red:0.70, green:0.00, blue:0.92, alpha:1.0), UIColor(red:0.91, green:0.00, blue:0.58, alpha:1.0)]
        default:
            break
        }
        return nil
    }
}
