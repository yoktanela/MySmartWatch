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
    
    public func connect(to peripheral: CBPeripheral) -> Observable<Bool> {
        centralManager.connect(peripheral, options: nil)
        return centralManager.rx.connectedPeripheral
            .flatMap { connectedPeripheral -> Observable<Bool> in
                return .just(connectedPeripheral == peripheral)
            }
    }
    
    public func setNotify(for peripheral: CBPeripheral, serviceUUID: String, characteristicUUID: String) -> Observable<Data?> {
        
        peripheral.discoverServices([CBUUID(string: serviceUUID)])

        peripheral.rx.didDiscoverServices
            .flatMap{ services -> Observable<CBService?> in
                return .just(services.first(where: { $0.uuid.uuidString
                        .isEqual(to: serviceUUID)
                }))
            }.subscribe( onNext: { service in
                if let service = service {
                    peripheral.discoverCharacteristics([CBUUID(string: characteristicUUID)], for: service)
                }
            }).disposed(by: disposeBag)
        
        peripheral.rx.didDiscoverCharacteristics
            .flatMap { characteristics -> Observable<CBCharacteristic?> in
                return .just(characteristics.first(where: { $0.uuid.uuidString
                    .isEqual(to: characteristicUUID)
                }))
            }.subscribe( onNext: { characteristic in
            if let characteristic = characteristic {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }).disposed(by: disposeBag)
        
        return peripheral.rx.didUpdateValue
    }
}
