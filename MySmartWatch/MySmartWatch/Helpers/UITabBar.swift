//
//  UITabBar.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 22.02.2022.
//

import Foundation
import UIKit

extension UITabBar {
    func configure() {
        self.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.clipsToBounds = true
        self.layer.borderWidth = 0.50
        self.unselectedItemTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.tintColor = #colorLiteral(red: 0, green: 0.5647058824, blue: 0.4392156863, alpha: 1)
    }
}
