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
        
//        view.addSubview(swipeCollection)
    var pageLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = Globals.constants.backgroundColor
        view.addSubview(swipeCollection)
        pageLabel = UILabel(frame: CGRect(x: 10, y: UIApplication.shared.statusBarFrame.height + 5, width: 200, height: 20))
        pageLabel.backgroundColor = .white
        pageLabel.text = "What's Next"
        view.addSubview(pageLabel)
        // If first time
        greetingView.delegate = self
        greetingView.contentInsetAdjustmentBehavior = .never
        greetingView.welcomeView.swipeAnimationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(scrollToBottom)))
        heartAnimationView.center = self.view.center
        let heartSize: CGFloat = 300
        heartAnimationView.frame = CGRect(x: 0, y: 0, width: heartSize, height: heartSize)
        heartAnimationView.center = self.view.center
        heartAnimationView.animationProgress = heartAnimationStartTime
        heartAnimationView.isUserInteractionEnabled = false
        view.addSubview(greetingView)
        view.addSubview(leftBracket)
        view.addSubview(rightBracket)
        view.addSubview(heartAnimationView)
        addConstraints()
    }

    private let heartAnimationStartTime: CGFloat = 0.18

    private lazy var greetingView = GreetingView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))

    private lazy var swipeCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        let bgImage = UIImageView()
        bgImage.image = UIImage(named: "background")
        bgImage.contentMode = .scaleAspectFill
        collectionView.backgroundView = bgImage
        return collectionView
    }()

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

extension HomeView: UICollectionViewDelegate {

}

extension HomeView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
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

extension HomeView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = 2 * greetingView.contentOffset.y / (greetingView.contentSize.height - greetingView.bounds.size.height)
        let animationDuration: Double = 0.5

        let screenHeight = self.view.bounds.height
        let maxScale = 2 * screenHeight / heartAnimationView.bounds.height
        if progress > 0 {
            greetingView.welcomeView.setSwipeAlpha(alpha: 0.0, duration: animationDuration)
            heartAnimationView.transform = CGAffineTransform(scaleX: 1 + maxScale * progress, y: 1 + maxScale * progress)
            leftBracket.transform = CGAffineTransform(translationX: progress * -350, y: 0)
            rightBracket.transform = CGAffineTransform(translationX: progress * 350, y: 0)
        } else if progress < 0 {
            let slideUpTransformation = CGAffineTransform(translationX: 0, y: -screenHeight / 2 * progress)
            heartAnimationView.transform = slideUpTransformation
            leftBracket.transform = slideUpTransformation
            rightBracket.transform = slideUpTransformation
            heartAnimationView.animationProgress = heartAnimationStartTime
        } else {
            greetingView.welcomeView.setSwipeAlpha(alpha: 1.0, duration: animationDuration)
        }
        if progress <= 1 && progress >= heartAnimationStartTime {
            heartAnimationView.animationProgress = progress
        } else if progress >= 2.0 { // Hides heart after done scrolling
            UIView.animate(withDuration: animationDuration, animations: {
                self.heartAnimationView.isHidden = true
                })
            greetingView.bioView.showView(duration: animationDuration)
        } else { // Shows heart if scrolling back up
            greetingView.bioView.hideView()
            UIView.animate(withDuration: animationDuration, animations: {
                self.heartAnimationView.isHidden = false
            })
        }
    }

    @objc func scrollToBottom(){
        greetingView.setContentOffset(CGPoint(x: 0, y: greetingView.contentSize.height - greetingView.bounds.size.height), animated: true)
    }
}
