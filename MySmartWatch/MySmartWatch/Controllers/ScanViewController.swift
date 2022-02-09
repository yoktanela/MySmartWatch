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
    private var scannedPeripherals = BehaviorRelay<[HeartRatePeripheral]>(value: [])
    private var disposeBag = DisposeBag()
    var timerForScan = Timer()
    
    var peripheralTableView: UITableView = {
        var tableView = UITableView()
        tableView.contentInset = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        return tableView
    }()
    
    var explanationLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor(named: "titleColor")
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .light)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemBackground
        self.setSubviews()
        
        self.scannedPeripherals.asObservable()
            .bind(to: self.peripheralTableView.rx.items) { (tableView, row, element ) in
                let cell = self.peripheralTableView.dequeueReusableCell(withIdentifier: "peripheralViewCell", for: IndexPath(row : row, section : 0)) as! PeripheralViewCell
                cell.customizeCell(name: element.name, rssi: element.rssi, connectable: element.connectable)
                return cell
            }
        
        // Create CBCentralManager
        queue = DispatchQueue(label: "CentralManager")
        centralManager = CBCentralManager(delegate: self, queue: queue, options: nil)
    }
    
    func setSubviews() {
        self.view.addSubview(explanationLabel)
        explanationLabel.translatesAutoresizingMaskIntoConstraints = false
        let topLblConstariant = explanationLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10.0)
        let leftLblConstraint = explanationLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20.0)
        let rightLblConstraint = explanationLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20.0)
        self.view.addConstraints([topLblConstariant, leftLblConstraint, rightLblConstraint])
        
        peripheralTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(peripheralTableView)
        let topConstraint = self.peripheralTableView.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: 10.0)
        let bottomConstraint = self.peripheralTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30)
        let leftConstraint = self.peripheralTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0)
        let rightConstraint = self.peripheralTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0)
        self.view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        
        peripheralTableView.register(PeripheralViewCell.self, forCellReuseIdentifier: "peripheralViewCell")
        peripheralTableView.separatorStyle = .none
        
        self.navigationItem.title = "Available Devices"
        let button = UIBarButtonItem()
        button.tintColor = UIColor(named: "buttonColor")
        button.title = "Stop Scan"
        self.navigationItem.setRightBarButtonItems([button], animated: false)
        self.navigationItem.rightBarButtonItem?
            .rx.tap.subscribe(onNext: { _ in
                if (self.centralManager.isScanning) {
                    self.centralManager.stopScan()
                    self.timerForScan.invalidate()
                    button.title = "Start Scan"
                } else {
                    self.startPeriodicScan()
                    button.title = "Stop Scan"
                }
            }).disposed(by: disposeBag)
        
        scannedPeripherals.flatMap{ peripherals -> Observable<Bool> in
            return .just(peripherals.count != 0)
        }.observe(on: MainScheduler.instance)
            .subscribe(onNext: { hasElements in
            if hasElements {
                self.explanationLabel.text = "Select one of the smart watch to connect and monitor your heart rate, steps and sleep quality."
            }else {
                self.explanationLabel.text = ""
            }
            }).disposed(by: disposeBag)
    }
    
    func startPeriodicScan() {
        DispatchQueue.main.async {
            self.timerForScan = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.1), repeats: true) { _ in
                self.centralManager.stopScan()
                self.centralManager.scanForPeripherals(withServices: [CBUUID(string: Constants.heartRatePeripheralServiceUUID)])
            }
            self.timerForScan.fire()
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
            self.startPeriodicScan()
        @unknown default:
            print("default")
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(RSSI.stringValue)
        self.scannedPeripherals.add(element: HeartRatePeripheral(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI))
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    }
}

