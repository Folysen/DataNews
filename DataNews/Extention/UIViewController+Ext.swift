//
//  UIViewController+Ext.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

extension UIViewController {
    
    func presentDNAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = DNAlertVC(title: title, message: message, buttonTitle: buttonTitle)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle   = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}
