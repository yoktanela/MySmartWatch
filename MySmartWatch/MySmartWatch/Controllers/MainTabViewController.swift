//
//  MainTabViewController.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 18.02.2022.
//

import Foundation
import UIKit
import CoreBluetooth
import RxSwift
import RxCocoa

class MainTabBarController: UITabBarController {
    
    private var bluetoothService: BluetoothService!
    var peripheral: CBPeripheral!

    init(bluetoothService: BluetoothService, peripheral: CBPeripheral) {
        self.bluetoothService = bluetoothService
        self.peripheral = peripheral
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.configure()
        setTabBarItems()
    }
    
    private func setTabBarItems() {
        let heartRateVC = HeartRateViewController(bluetoothService: self.bluetoothService, peripheral: self.peripheral)
        let tabBarItem = createTabBarItem(controller: heartRateVC, title: "Heart Rate", image: #imageLiteral(resourceName: "heartRateImg"))
        self.setViewControllers([tabBarItem], animated: false)
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


