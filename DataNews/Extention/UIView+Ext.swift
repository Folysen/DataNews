//
//  UIView+Ext.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {addSubview(view) }
    }
}
