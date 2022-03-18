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

class ScannerViewModel {
    
    private var bluetoothService: BluetoothService!
    private var disposeBag = DisposeBag()
    var scannedPeripherals = BehaviorRelay<[HeartRatePeripheral]>(value: [])
    
    var noDeviceFound: Observable<Bool> {
        return self.scannedPeripherals
            .flatMap{ peripherals -> Observable<Bool> in
                return .just(peripherals.count == 0)
            }.asObservable()
    }
    
    var scanning: BehaviorRelay<Bool> {
        return bluetoothService.scanning
    }
    var warningMessage = BehaviorRelay<String?>(value: nil)
    
    init(bluetoothService: BluetoothService) {
        self.bluetoothService = bluetoothService
        self.warningMessage = bluetoothService.warningMessage
    }
    
    func getPeripherals(for uuidString: String) -> BehaviorRelay<[HeartRatePeripheral]> {
        bluetoothService.startScanning(for: uuidString)
            .observe(on: MainScheduler.instance)
            .flatMap{ peripheral -> Observable<HeartRatePeripheral> in
                return .just(HeartRatePeripheral(peripheral))
            }.subscribe( onNext: { heartRatePeripheral in
                self.scannedPeripherals.add(element: heartRatePeripheral)
            })
            .disposed(by: disposeBag)
        return self.scannedPeripherals
    }
    
    public func stopScan() {
        self.bluetoothService.stopScan()
    }
}
