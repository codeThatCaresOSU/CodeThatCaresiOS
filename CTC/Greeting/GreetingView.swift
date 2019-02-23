//
//  GreetingView.swift
//  CTC
//
//  Created by Dave Becker on 1/16/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import UIKit
import Lottie

class GreetingView: UIScrollView, UICollectionViewDelegateFlowLayout {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentSize = CGSize(width: self.frame.width, height: self.frame.height * 2)
        
        self.addSubview(welcomeView)
        self.addSubview(bioView)
        
        self.backgroundColor = Globals.constants.backgroundColor
        self.delegate = self
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
            // TODO
        }
        self.showsVerticalScrollIndicator = false
        self.welcomeView.swipeAnimationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scrollToBottom)))
        heartAnimationView.frame = CGRect(x: 0, y: 0, width: heartSize, height: heartSize)
        heartAnimationView.center = self.center
        heartAnimationView.animationProgress = heartAnimationStartTime
        heartAnimationView.isUserInteractionEnabled = false
        self.addSubview(leftBracket)
        self.addSubview(rightBracket)
        self.addSubview(heartAnimationView)
        addConstraints()
    }
    
    private let heartAnimationStartTime: CGFloat = 0.18
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var welcomeView = WelcomeView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
    lazy var bioView = BioView(frame: CGRect(x: 0, y: self.frame.maxY, width: self.frame.width, height: self.frame.height))
    
    let heartSize: CGFloat = 300
    let heartAnimationView: LOTAnimationView = {
        let animationView = LOTAnimationView(name: "heart-green")
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 0.5
        animationView.loopAnimation = false
        return animationView
    }()
    
    let leftBracket: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AdventPro-SemiBold", size: 200)
        label.text = "<"
        label.textColor = Globals.constants.ctcColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let rightBracket: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AdventPro-SemiBold", size: 200)
        label.text = ">"
        label.textColor = Globals.constants.ctcColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func addConstraints() {
        let bracketSpacing: CGFloat = 75
        leftBracket.rightAnchor.constraint(equalTo: heartAnimationView.centerXAnchor, constant: -bracketSpacing).isActive = true
        leftBracket.centerYAnchor.constraint(equalTo: heartAnimationView.centerYAnchor).isActive = true
        leftBracket.heightAnchor.constraint(equalToConstant: leftBracket.intrinsicContentSize.height).isActive = true
        leftBracket.widthAnchor.constraint(equalToConstant: leftBracket.intrinsicContentSize.width).isActive = true
        
        rightBracket.leftAnchor.constraint(equalTo: heartAnimationView.centerXAnchor, constant: bracketSpacing).isActive = true
        rightBracket.centerYAnchor.constraint(equalTo: heartAnimationView.centerYAnchor).isActive = true
        rightBracket.heightAnchor.constraint(equalToConstant: rightBracket.intrinsicContentSize.height).isActive = true
        rightBracket.widthAnchor.constraint(equalToConstant: rightBracket.intrinsicContentSize.width).isActive = true
    }
    
}

extension GreetingView: UICollectionViewDelegate {
    
}

extension GreetingView: UICollectionViewDataSource {
    
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

extension GreetingView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = 2 * scrollView.contentOffset.y / (scrollView.contentSize.height - scrollView.frame.height)
        let animationDuration: Double = 0.5
        let screenHeight = scrollView.contentSize.height / 2
        let maxScale = 2 * screenHeight / heartAnimationView.bounds.height
        if progress > 0 {
            welcomeView.setSwipeAlpha(alpha: 0.0, duration: animationDuration)
            let pinPositionAnimation = CGAffineTransform(translationX: 0, y: screenHeight / 2 * progress)
            let scaleHeartAnimation = CGAffineTransform(scaleX: 1 + maxScale * progress, y: 1 + maxScale * progress)
            let leftBracketAnimation = CGAffineTransform(translationX: progress * -350, y: 0)
            let rightBracketAnimation = CGAffineTransform(translationX: progress * 350, y: 0)
            heartAnimationView.transform = scaleHeartAnimation.concatenating(pinPositionAnimation)
            leftBracket.transform = leftBracketAnimation.concatenating(pinPositionAnimation)
            rightBracket.transform = rightBracketAnimation.concatenating(pinPositionAnimation)
        } else if progress < 0 {
            let pinPositionAnimation = CGAffineTransform(translationX: 0, y: -(screenHeight / 4 * progress))
            heartAnimationView.transform = pinPositionAnimation
            leftBracket.transform = pinPositionAnimation
            rightBracket.transform = pinPositionAnimation
            heartAnimationView.animationProgress = heartAnimationStartTime
        } else {
            welcomeView.setSwipeAlpha(alpha: 1.0, duration: animationDuration)
        }
        if progress <= 1 && progress >= heartAnimationStartTime {
            heartAnimationView.animationProgress = progress
        } else if progress >= 2.0 { // Hides heart after done scrolling
            UIView.animate(withDuration: animationDuration, animations: {
                self.heartAnimationView.isHidden = true
            })
            bioView.showView(duration: animationDuration)
        } else { // Shows heart if scrolling back up
            bioView.hideView()
            UIView.animate(withDuration: animationDuration, animations: {
                self.heartAnimationView.isHidden = false
            })
        }
    }
    
    @objc func scrollToBottom(){
        self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height), animated: true)
    }
}
