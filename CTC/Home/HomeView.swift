//
//  HomeView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit
import BLTNBoard
import CTCKit

class HomeView: UIViewController, bulletinDelegate, HomeDelegate, ShowGreetingDelegate {

    private let pageTitles = ["Calendar", "Settings"]
    private var collectionViewIsActive = false
    private lazy var pages = [calendarView, settingsView]
    private var isStatusBarLight = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = Globals.constants.greyColor
        
        view.addSubview(backgroundScrollView)
        view.addSubview(segmentedControl)
        updateConstraints()
        //----
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
      
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            showGreeting()
            prepareForBulletin()
        } else {
            self.calendarView.showCalendar()
        }
    }
    
    func showGreeting(){
        greetingView = GreetingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
//        view.addSubview(greetingView)
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.view.addSubview(self.greetingView)
        }, completion: nil)
        greetingView.bioView.delegate = self
        greetingView.homeDelegate = self
    }
    
    func setStatusBar(style: UIStatusBarStyle) {
        isStatusBarLight = style == .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if(isStatusBarLight){
            return .lightContent
        }
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.segmentedControl(self.segmentedControl, didScrollWithXOffset: 0)
        
        let yPadding: CGFloat = 10 // Padding below segmentedControl for views
        let yOffset = segmentedControl.frame.size.height + segmentedControl.frame.origin.y + yPadding
        calendarView.updateFrames(frame: CGRect(x: calendarView.frame.origin.x, y: yOffset, width: calendarView.frame.size.width, height: calendarView.frame.size.height - yOffset))
        settingsView.updateFrames(frame: CGRect(x: settingsView.frame.origin.x, y: yOffset, width: settingsView.frame.size.width, height: settingsView.frame.size.height - yOffset))
    }
    
    private lazy var segmentedControl: LUNSegmentedControl = {
        let seg = LUNSegmentedControl()
        seg.delegate = self
        seg.dataSource = self
        seg.selectorViewColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.1)
//        seg.backgroundColor = UIColor(red: 37.0/255.0, green: 37.0/255.0, blue: 37.0/255.0, alpha: 0.5)
        seg.backgroundColor = UIColor(white: 1, alpha: 0.2)
        seg.cornerRadius = 22 // 18 for 3 pages
        seg.applyCornerRadiusToSelectorView = true
        seg.translatesAutoresizingMaskIntoConstraints = false
        return seg
    }()
    private lazy var backgroundScrollView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(x:0, y:0, width: view.bounds.width, height: view.bounds.height), collectionViewLayout: flowLayout)
        collectionView.contentSize = CGSize(width: view.frame.width, height: view.frame.height)
        collectionView.isUserInteractionEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        let background = UIImageView(image: UIImage(named: "particles"))
        background.isUserInteractionEnabled = true
        
        /* Width adds 1.5x to account for scrolling slightly past the end of the first and last page. */
        background.frame = CGRect(x: -view.bounds.width * 1.5 / 2, y: 0, width: view.bounds.width * CGFloat(pages.count) + view.bounds.width * 1.5, height: view.bounds.height)
        for page in pages {
            background.addSubview(page)
        }
        collectionView.addSubview(background)
        return collectionView
    }()
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    private lazy var greetingView = GreetingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    
    /* Each new page must add to the x point view.bounds.width to keep it aligned in scrollview.
     To add a 4th page, use this code:
     lazy var templateView4 = CalendarView(frame: CGRect(x: view.bounds.width * 1.5 / 2 + view.bounds.width * 3, y: 0, width: view.bounds.width, height: view.bounds.height))
     */
    private lazy var calendarView: CalendarView = {
        let view = CalendarView(frame: CGRect(x: self.view.frame.width * 1.5 / 2, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        return view
    }()
    private lazy var settingsView: SettingsView = {
        let view = SettingsView(frame: CGRect(x: self.view.bounds.width * 1.5 / 2 + self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        view.greetingDelegate = self
        return view
    }()

    private lazy var bulletinManager: BLTNItemManager = {
        let rootItem: BLTNItem = notificationBulletin
        return BLTNItemManager(rootItem: rootItem)
    }()
    private lazy var notificationBulletin: BLTNPageItem = {
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
            //TODO: Notifications
            self.afterBulletin()
        }
        notificationBulletin.alternativeHandler = {(item: BLTNActionItem) in
            UserDefaults.standard.set(true, forKey: "setupComplete")
            self.afterBulletin()
        }
    }
    func showBulletin(){
        let setupComplete = UserDefaults.standard.bool(forKey: "setupComplete")
        if !setupComplete {
            bulletinManager.backgroundViewStyle = .blurredDark
            bulletinManager.showBulletin(above: self)
        } else {
            removeGreeting()
        }
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
    func afterBulletin(){
        self.bulletinManager.dismissBulletin()
        removeGreeting()
    }
    
    func removeGreeting(){
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.greetingView.removeFromSuperview()
        }, completion: nil)
        self.calendarView.showCalendar()
    }
    
    /*
     Constraints
     */
    func updateConstraints(){
        segmentedControl.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -20).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 60).isActive = true //45 for 3 pages
        segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:10).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

extension HomeView: LUNSegmentedControlDataSource, LUNSegmentedControlDelegate {
    
    func numberOfStates(in segmentedControl: LUNSegmentedControl!) -> Int {
        return pages.count
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, attributedTitleForStateAt index: Int) -> NSAttributedString! {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "AvenirNext-Medium", size: 18)!,
            .foregroundColor: UIColor.white
        ]
        return NSAttributedString(string: pageTitles[index], attributes: attrs)
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, attributedTitleForSelectedStateAt index: Int) -> NSAttributedString! {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "AvenirNext-Medium", size: 23)!,
            .foregroundColor: UIColor.white
        ]
        return NSAttributedString(string: pageTitles[index], attributes: attrs)
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, didScrollWithXOffset offset: CGFloat) {
        if (!collectionViewIsActive){
            let maxOffset: CGFloat = self.segmentedControl.frame.size.width/CGFloat(self.segmentedControl.statesCount)
            let percentageOffsetSeg = offset / maxOffset / 2
            let maxBackgroundOffset: CGFloat = backgroundScrollView.frame.size.width * 2
            let backgroundScrollViewOffset: CGFloat = maxBackgroundOffset * percentageOffsetSeg
            backgroundScrollView.setContentOffset(CGPoint(x: backgroundScrollViewOffset, y: 0), animated: false)
        }
    }
    
    func segmentedControl(_ segmentedControl: LUNSegmentedControl!, gradientColorsForStateAt index: Int) -> [UIColor]! {
        switch(index){
        case 0:
            return [UIColor(red:0.51, green:0.38, blue:0.76, alpha:1.0), UIColor(red:0.34, green:0.33, blue:0.76, alpha:1.0)]
        case 1:
            return [UIColor(red:0.29, green:0.44, blue:0.76, alpha:1.0), UIColor(red:0.25, green:0.58, blue:0.75, alpha:1.0)]
        case 2:
            return [UIColor(red:0.22, green:0.74, blue:0.75, alpha:1.0), UIColor(red:0.18, green:0.75, blue:0.56, alpha:1.0)]
        default:
            break
        }
        return nil
    }
}
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(collectionViewIsActive){
            let maximumOffset = scrollView.contentSize.width - scrollView.frame.width
            let currentOffset = scrollView.contentOffset.x
            let percentageOffset = 1 - (currentOffset / maximumOffset)
            let segPos = percentageOffset * (segmentedControl.scrollView.contentSize.width - segmentedControl.scrollView.frame.width)
            segmentedControl.scrollView.setContentOffset(CGPoint(x: segPos, y: segmentedControl.scrollView.contentOffset.y), animated: false)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewIsActive = false
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        collectionViewIsActive = true
    }
}
