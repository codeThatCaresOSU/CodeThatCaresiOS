//
//  HomeView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit
import RxSwift

class HomeView: UIViewController, UICollectionViewDelegateFlowLayout {
    
    var pageLabel: UILabel!
    private var viewModel: HomeViewModel = HomeViewModel()
    private var subscription: Disposable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(swipeCollection)
        pageLabel = UILabel(frame: CGRect(x: 10, y: UIApplication.shared.statusBarFrame.height + 5, width: 200, height: 20))
        pageLabel.backgroundColor = .white
        pageLabel.text = self.viewModel.pageLabelText
        view.addSubview(pageLabel)
        // If first time
        view.addSubview(GreetingView())
        
        self.subscription = self.viewModel.updateUI?.subscribe(self.updateUI)
    }
    
    private lazy var swipeCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        let bgImage = UIImageView()
        bgImage.image = UIImage(named: self.viewModel.backgroundImageName)
        bgImage.contentMode = .scaleAspectFill
        collectionView.backgroundView = bgImage
        return collectionView
    }()
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.viewModel.viewScrolled(percentageScrolled: Double(round(self.swipeCollection.contentOffset.x / self.swipeCollection.frame.size.width)))
    }
    
    func updateUI(event: Event<Any?>) {
        self.pageLabel.text = self.viewModel.pageLabelText
    }
    
    
}

extension HomeView: UICollectionViewDelegate {
    
}

extension HomeView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.addSubview(CalendarView(frame: collectionView.frame))
        } else { }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                                 forItemAt indexPath: IndexPath) {
//        cell.alpha = 0
//        UIView.animate(withDuration: 0.8) {
//            cell.alpha = 1
//        }
        if indexPath.row == 0 {
            cell.subviews[1].subviews[0].frame = CGRect(x: -30, y: 125, width: cell.frame.width - 20, height: 75)
            UIView.animate(withDuration: 0.6) {
                cell.subviews[1].subviews[0].frame = CGRect(x: 10, y: 125, width: cell.frame.width - 20, height: 75)
            }
            cell.subviews[1].subviews[1].frame = CGRect(x: -30, y: 210, width: cell.frame.width - 20, height: cell.frame.height - 275)
            UIView.animate(withDuration: 0.5) {
                cell.subviews[1].subviews[1].frame = CGRect(x: 10, y: 210, width: cell.frame.width - 20, height: cell.frame.height - 275)
            }
        }
        if indexPath.row == 1 {
        }
    }
}
