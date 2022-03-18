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
    let state: BehaviorRelay<CBManagerState>
    let warningMessage = BehaviorRelay<String?>(value: nil)
    
    init() {
        state = BehaviorRelay<CBManagerState>(value: centralManager.state)
        self.centralManager.rx
            .stateChanged
            .observe(on: MainScheduler.instance)
            .bind(to: state)
            .disposed(by: disposeBag)
        
        self.state
            .flatMap { state -> Observable<String?> in
                if state == .unauthorized {
                    return .just("Bluetooth permission is required. Please give permission from Settings")
                }
                return .just(nil)
            }.compactMap{$0}
            .asDriver(onErrorJustReturn: nil)
            .drive(warningMessage)
            .disposed(by: disposeBag)
    }
    
    public func startScanning(for uuidString: String) -> Observable<Peripheral> {
        self.state
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { state in
                if state == CBManagerState.poweredOn {
                    self.scanning.accept(true)
                    DispatchQueue.main.async {
                        self.timerForScan = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.1), repeats: true) { _ in
                            self.centralManager.stopScan()
                            self.centralManager.scanForPeripherals(withServices: [CBUUID(string: uuidString)])
                        }
                        self.timerForScan.fire()
                    }
                }
            })
            .disposed(by: disposeBag)
        
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
    
    public func getService(for peripheral: CBPeripheral, serviceUUID: String) -> Observable<CBService?> {
        if let service = peripheral.services?
            .first(where: { $0.uuid.uuidString.isEqual(to: serviceUUID)}) {
            return .just(service)
        } else {
            peripheral.discoverServices([CBUUID(string: serviceUUID)])
            return peripheral.rx.didDiscoverServices
                .flatMap{ services -> Observable<CBService?> in
                    return .just(services.first(where: { $0.uuid.uuidString
                            .isEqual(to: serviceUUID)
                    }))
                }
        }
    }
    
    public func getCharacteristic(for peripheral: CBPeripheral, serviceUUID: String, characteristicUUID: String) -> Observable<CBCharacteristic?> {
        return self.getService(for: peripheral, serviceUUID: serviceUUID)
            .observe(on: MainScheduler.instance)
            .compactMap{$0}
            .take(1)
            .flatMap { service -> Observable<CBCharacteristic?> in
                if let characteristic = service.characteristics?
                    .first(where: {$0.uuid.uuidString.isEqual(to: characteristicUUID)}) {
                    return .just(characteristic)
                } else {
                    peripheral.discoverCharacteristics([CBUUID(string: characteristicUUID)], for: service)
                    return peripheral.rx.didDiscoverCharacteristics
                        .flatMap { characteristics -> Observable<CBCharacteristic?> in
                            return .just(characteristics.first(where: { $0.uuid.uuidString
                                .isEqual(to: characteristicUUID)
                            }))
                        }
                }
            }
    }
    
    public func setNotify(for peripheral: CBPeripheral, serviceUUID: String, characteristicUUID: String) -> Observable<Data?> {
        
        getCharacteristic(for: peripheral, serviceUUID: serviceUUID, characteristicUUID: characteristicUUID)
            .observe(on: MainScheduler.instance)
            .compactMap{$0}
            .subscribe(onNext: { characteristic in
                peripheral.setNotifyValue(true, for: characteristic)
            })
        
        let characteristic = peripheral.rx.didUpdateValue
            .flatMap { characteristic -> Observable<CBCharacteristic?> in
                if characteristic.uuid.uuidString.isEqual(to: characteristicUUID) {
                    return .just(characteristic)
                }
                return .just(nil)
            }
        
        let result = characteristic.filter { $0 != nil}
            .flatMap { characteristic -> Observable<Data?> in
                return .just(characteristic?.value)
            }
        
        return result
    }
    
    public func writeValue(for peripheral: CBPeripheral, serviceUUID: String, characteristicUUID: String, data: Data) {
        
        getCharacteristic(for: peripheral, serviceUUID: serviceUUID, characteristicUUID: characteristicUUID)
            .observe(on: MainScheduler.instance)
            .compactMap{$0}
            .take(1)
            .subscribe(onNext: { characteristic in
                peripheral.writeValue(data, for: characteristic, type: .withResponse)
                
            })
            .disposed(by: disposeBag)
        }
}
