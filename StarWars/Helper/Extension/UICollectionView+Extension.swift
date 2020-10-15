//
//  UICollectionView+Extension.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit

extension UICollectionView {
    func register<T: SWCollectionViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellWithReuseIdentifier: className)
    }
    
    func register<T: SWCollectionViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }
    
    func register<T: UICollectionReusableView>(reusableViewType: T.Type,
                                               ofKind kind: String = UICollectionView.elementKindSectionHeader) {
        let className = reusableViewType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: className)
    }
    
    func register<T: UICollectionReusableView>(reusableViewTypes: [T.Type],
                                               ofKind kind: String = UICollectionView.elementKindSectionHeader) {
        reusableViewTypes.forEach { register(reusableViewType: $0, ofKind: kind) }
    }
    
    func dequeueReusableCell<T: SWCollectionViewCell>(with type: T.Type,
                                                      for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: type.className, for: indexPath) as! T
        cell.indexPath = indexPath
        return cell
    }
    
    func dequeueReusableView<T: UICollectionReusableView>(with type: T.Type,
                                                          for indexPath: IndexPath,
                                                          ofKind kind: String = UICollectionView.elementKindSectionHeader) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: type.className, for: indexPath) as! T
    }
    
}


