//
//  ScanViewController.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 2.02.2022.
//

import Foundation
import UIKit
import CoreBluetooth
import RxSwift
import RxCocoa

class ScanViewController: UIViewController {
    
    var queue: DispatchQueue!
    private var centralManager: CBCentralManager!
    private var scannedPeripherals = BehaviorRelay<[CBPeripheral]>(value: [])
    
    var peripheralTableView: UITableView = {
        return UITableView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.peripheralTableView = UITableView(frame: self.view.frame)
        self.view.addSubview(peripheralTableView)
        let topConstraint = self.peripheralTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0)
        self.view.addConstraints([topConstraint])
        peripheralTableView.separatorStyle = .none
        
        queue = DispatchQueue(label: "CentralManager")
        centralManager = CBCentralManager(delegate: self, queue: queue, options: nil)
        
        self.scannedPeripherals.asObservable()
            .bind(to: self.peripheralTableView.rx.items) { (tableView, row, element ) in
                let cell = UITableViewCell(style: .default, reuseIdentifier: "peripheralCell")
                cell.textLabel?.text = element.name
                //TODO: Set rssi and connectable info
                return cell
            }
    }
}


extension ScanViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            self.centralManager.scanForPeripherals(withServices: [CBUUID(string: Constants.heartRatePeripheralServiceUUID)])
        @unknown default:
            print("default")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(RSSI.stringValue)
        self.scannedPeripherals.add(element: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    }
}

