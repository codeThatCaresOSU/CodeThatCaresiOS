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
        animationView.center = self.view.center
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = self.view.center
        animationView.play(fromProgress: 0.5, toProgress: 0.6, withCompletion: nil)
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
        let animationView = LOTAnimationView(contentsOf: URL(string: "https://assets.lottiefiles.com/datafiles/iWEiFJ0uySBMqNg/data.json")!)
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
        print(progress)
        let screenHeight = greetingView.bounds.size.height/2.0 //368
        var maxScale = screenHeight / animationView.bounds.height
        maxScale = 10
        print(maxScale)
        if progress >= 0.1 {
            animationView.transform = CGAffineTransform(scaleX: maxScale * progress, y: maxScale * progress)
        }
        if progress >= 1 {
            animationView.alpha = 0
        } else {
            animationView.alpha = 1.0
        }
        
    }
}
