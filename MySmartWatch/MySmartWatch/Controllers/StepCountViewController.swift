//
//  StepCountViewController.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 10.03.2022.
//

import Foundation
import UIKit
import CoreBluetooth
import RxSwift
import RxCocoa

class StepCountViewController: UIViewController {
    
    var peripheralViewModel: PeripheralViewModel?
    private var disposeBag = DisposeBag()
    
    init(bluetoothService: BluetoothService, peripheral: CBPeripheral) {
        self.peripheralViewModel = PeripheralViewModel(bluetoothService: bluetoothService, peripheral: peripheral)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.systemBackground
    }
}
