//
//  ScannerViewModel.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 9.02.2022.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa

class ScannerViewModel: NSObject {
    
    var queue: DispatchQueue = DispatchQueue(label: "CentralManager")
    private var centralManager: CBCentralManager!
    private var scannedPeripherals = BehaviorRelay<[HeartRatePeripheral]>(value: [])
    private var disposeBag = DisposeBag()
    var timerForScan = Timer()
    var scanning = BehaviorRelay<Bool>(value: false)
    
    var noDeviceFound: Observable<Bool> {
        return self.scannedPeripherals
            .flatMap{ peripherals -> Observable<Bool> in
                return .just(peripherals.count == 0)
            }.asObservable()
    }
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: queue, options: nil)
    }
    
    private func startPeriodicScan() {
        scanning.accept(true)
        DispatchQueue.main.async {
            self.timerForScan = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.1), repeats: true) { _ in
                self.centralManager.stopScan()
                self.centralManager.scanForPeripherals(withServices: [CBUUID(string: Constants.heartRatePeripheralServiceUUID)])
            }
            self.timerForScan.fire()
        }
    }
    
    private func stopPeriodicScan() {
        self.timerForScan.invalidate()
        self.centralManager.stopScan()
        scanning.accept(false)
    }
    
    func getPeripherals() -> BehaviorRelay<[HeartRatePeripheral]> {
        return self.scannedPeripherals
    }
}

extension ScannerViewModel: CBCentralManagerDelegate {
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
        self.scannedPeripherals.add(element: HeartRatePeripheral(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI))
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    }
}


