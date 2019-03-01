//
//  CollectionViewPassthrough.swift
//  CTC
//
//  Created by Dave Becker on 3/1/19.
//  Copyright © 2019 Code That Cares. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewPassthrough: UICollectionView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
}
