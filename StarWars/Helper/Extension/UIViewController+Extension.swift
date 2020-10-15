//
//  UIViewController+Extension.swift
//  StarWars
//
//  Created by Rahul Garg on 15/10/20.
//

import UIKit

extension UIViewController {
    class func loadFromNib<T: UIViewController>() -> T {
         return T(nibName: String(describing: self), bundle: nil)
    }
}
