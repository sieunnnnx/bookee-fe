//
//  UIApplication+RootViewController.swift
//  Bookee
//
//  Created by sieunnnx on 5/11/26.
//

import UIKit

extension UIApplication {
    
    var rootViewController: UIViewController? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
