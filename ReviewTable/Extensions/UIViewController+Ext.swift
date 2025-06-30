//
//  UIViewController+Ext.swift
//  ReviewTable
//
//  Created by Maxim Makarenkov on 29.06.2025.
//

import UIKit

extension UIViewController {
    func showNavBarLoadingIndicator(animated: Bool) {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.startAnimating()
        
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicatorView)
        }
    }
    
    func dismissNavBarLoadingIndicator(animated: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: animated ? 0.25 : 0) {
                self.navigationItem.rightBarButtonItem = nil
            }
            
        }
    }
}
