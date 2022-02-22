//
//  MainTabViewController.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 18.02.2022.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.configure()
        setTabBarItems()
    }
    
    private func setTabBarItems() {
        let heartRateVC = createTabBarItem(controller: HeartRateViewController(), title: "Heart Rate", image: #imageLiteral(resourceName: "heartRateImg"))
        self.setViewControllers([heartRateVC], animated: false)
    }
    
    private func createTabBarItem(controller: UIViewController,
                                  title: String,
                                  image: UIImage) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: controller)
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }
}


