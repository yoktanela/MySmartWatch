//
//  BluetoothService.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 26.02.2022.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa

class BluetoothService {
    
    var centralManager = CBCentralManager(delegate: nil, queue: DispatchQueue(label: "CentralManager"))
    var timerForScan = Timer()
    var scanning = BehaviorRelay<Bool>(value: false)
    private var disposeBag = DisposeBag()
    
    public func startScanning(for uuidString: String) -> Observable<Peripheral> {
        scanning.accept(true)
        DispatchQueue.main.async {
            self.timerForScan = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.1), repeats: true) { _ in
                self.centralManager.stopScan()
                self.centralManager.scanForPeripherals(withServices: [CBUUID(string: uuidString)])
            }
            self.timerForScan.fire()
        }
        return centralManager.rx.didDiscoverPeripheral
    }
    
    public func stopScan() {
        self.timerForScan.invalidate()
        self.centralManager.stopScan()
        scanning.accept(false)
    }
}
