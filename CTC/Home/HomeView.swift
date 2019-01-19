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
        heartAnimationView.center = self.view.center
        let heartSize: CGFloat = 300
        heartAnimationView.frame = CGRect(x: 0, y: 0, width: heartSize, height: heartSize)
        heartAnimationView.center = self.view.center
        heartAnimationView.animationProgress = 0.18
        heartAnimationView.isUserInteractionEnabled = false
        view.addSubview(greetingView)
        view.addSubview(heartAnimationView)
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
    
    let heartAnimationView: LOTAnimationView = {
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
        let maxScale = 2 * screenHeight / heartAnimationView.bounds.height
        if progress > 0 {
            UIView.animate(withDuration: duration, animations: {
                self.greetingView.welcomeView.swipeAnimationView.alpha = 0.0
            })
            heartAnimationView.transform = CGAffineTransform(scaleX: 1 + maxScale * progress, y: 1 + maxScale * progress)
        } else if progress < 0 {
            heartAnimationView.transform = CGAffineTransform(translationX: 0, y: -screenHeight / 2 * progress)
        } else {
            UIView.animate(withDuration: duration, animations: {
                self.greetingView.welcomeView.swipeAnimationView.alpha = 1.0
            })
        }
        if progress <= 1 && progress >= 0.18 { // 0.18 cuts off the first part of the animation that is unnecessary
            heartAnimationView.animationProgress = progress
        } else if progress >= 2.0 { // Hides heart after done scrolling
            UIView.animate(withDuration: duration, animations: {
                self.heartAnimationView.isHidden = true
                })
            greetingView.bioView.showView(duration: duration)
        } else { // Shows heart if scrolling back up
            greetingView.bioView.hideView()
            UIView.animate(withDuration: duration, animations: {
                self.heartAnimationView.isHidden = false
            })
        }
    }
}
