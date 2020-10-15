//
//  SWCollectionViewCell.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit
import Combine

class SWCollectionViewCell: UICollectionViewCell {
    var cancellables = Set<AnyCancellable>()
    
    var indexPath: IndexPath?

    override func prepareForReuse() {
       super.prepareForReuse()
       cancellables = Set<AnyCancellable>() // because life cicle of every cell ends on prepare for reuse
    }
}
