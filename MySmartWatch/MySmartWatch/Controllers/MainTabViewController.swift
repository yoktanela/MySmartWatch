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
    
    var peripheralViewModel: PeripheralViewModel!
    var bluetoothService: BluetoothService!
    var peripheral: CBPeripheral!
    
    init(bluetoothService: BluetoothService, peripheral: CBPeripheral) {
        self.bluetoothService = bluetoothService
        self.peripheral = peripheral
        self.peripheralViewModel = PeripheralViewModel(bluetoothService: bluetoothService, peripheral: peripheral)
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
        let heartRateVC = HeartRateViewController(peripheralViewModel: self.peripheralViewModel)
        let heartRateTabBarItem = createTabBarItem(controller: heartRateVC, title: "Heart Rate", image: #imageLiteral(resourceName: "heartRateImg"))
        let stepCountVC = StepCountViewController(peripheralViewModel: self.peripheralViewModel)
        let stepCountTabBarItem = createTabBarItem(controller: stepCountVC, title: "Step Count", image: #imageLiteral(resourceName: "stepImg"))
        let settingsVC = SettingsViewController(bluetoothService: bluetoothService, peripheral: peripheral)
        let settingsTabBarItem = createTabBarItem(controller: settingsVC, title: "Settings", image: #imageLiteral(resourceName: "settingImg"))
        
        self.setViewControllers([heartRateTabBarItem, stepCountTabBarItem, settingsTabBarItem], animated: false)
    }
    
    private func createTabBarItem(controller: UIViewController,
                                  title: String,
                                  image: UIImage) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.isNavigationBarHidden = true
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: nil)
        navigationController.tabBarItem = tabBarItem
        return navigationController
    }
}


