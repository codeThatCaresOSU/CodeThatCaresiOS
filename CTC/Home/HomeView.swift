//
//  HomeView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit
import Lottie

class HomeView: UIViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red:0.15, green:0.15, blue:0.15, alpha:1.0)
//        view.addSubview(swipeCollection)
        // If first time
        greetingView.delegate = self
        greetingView.contentInsetAdjustmentBehavior = .never
        animationView.center = self.view.center
        let heartSize: CGFloat = 300
        animationView.frame = CGRect(x: 0, y: 0, width: heartSize, height: heartSize)
        animationView.center = self.view.center
        animationView.animationProgress = 0.18
        animationView.isUserInteractionEnabled = false
        view.addSubview(greetingView)
        view.addSubview(animationView)
    }
    
    private lazy var greetingView = GreetingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
    
    private lazy var swipeCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    let animationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "heart")
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.5
        animationView.loopAnimation = false
        return animationView
    }()
    
}

extension HomeView: UICollectionViewDelegate {
    
}

extension HomeView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.row == 0 {
            cell.backgroundColor = .red
            cell.addSubview(CalendarView(frame: collectionView.frame))
        } else {
            cell.backgroundColor = .gray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension HomeView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = 2 * greetingView.contentOffset.y / (greetingView.contentSize.height - greetingView.bounds.size.height)
        print("progress: \(progress)")
        let duration = 0.5
        
        let screenHeight = self.view.bounds.height
        // 2 is tested on 8+ only, might need to increase/decrease
        let maxScale = 2 * screenHeight / animationView.bounds.height
        if progress > 0 {
            animationView.transform = CGAffineTransform(scaleX: 1 + maxScale * progress, y: 1 + maxScale * progress)
        } else if progress < 0 {
            animationView.transform = CGAffineTransform(translationX: 0, y: -screenHeight / 2 * progress)
        }
        if progress <= 1 && progress >= 0.18 { // 0.18 cuts off the first part of the animation that is unnecessary
            animationView.animationProgress = progress
        } else if progress >= 2.0 { // Hides heart after done scrolling
            UIView.animate(withDuration: duration, animations: {
                self.animationView.isHidden = true
                })
            greetingView.bioView.showView(duration: duration)
        } else { // Shows heart if scrolling back up
            greetingView.bioView.hideView()
            UIView.animate(withDuration: duration, animations: {
                self.animationView.isHidden = false
            })
        }
    }
}
