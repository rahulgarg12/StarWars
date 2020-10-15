//
//  UITableView+Extension.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit

extension UITableView {
    func register<T: SWTableViewCell>(cellType: T.Type) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forCellReuseIdentifier: className)
    }
    
    func register<T: SWTableViewCell>(cellTypes: [T.Type]) {
        cellTypes.forEach { register(cellType: $0) }
    }
    
    func dequeueReusableCell<T: SWTableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
        cell.indexPath = indexPath
        return cell
    }
}
