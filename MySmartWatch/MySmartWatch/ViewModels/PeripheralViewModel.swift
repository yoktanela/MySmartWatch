//
//  PeripheralConnectorViewModel.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 22.02.2022.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa

class PeripheralViewModel: NSObject {
    
    private var bluetoothService:BluetoothService!
    private var peripheral: CBPeripheral!
    private var disposeBag = DisposeBag()
    
    var connected = BehaviorRelay<Bool>(value: false)
    var heartRate = BehaviorRelay<Int?>(value: nil)
    
    init(bluetoothService: BluetoothService, peripheral: CBPeripheral) {
        super.init()
        self.bluetoothService = bluetoothService
        self.peripheral = peripheral
        
        bluetoothService.connect(to: peripheral)
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
            .drive(connected)
            .disposed(by: disposeBag)
        
        connected.subscribe(onNext: { value in
            if (value) {
                // Notify for primary service
                bluetoothService.setNotify(for: peripheral, serviceUUID: Constants.primaryServiceUUID, characteristicUUID: Constants.primaryCharacteristicUUID)
                // Notify for heart rate service
                bluetoothService.setNotify(for: peripheral, serviceUUID: Constants.heartRatePeripheralServiceUUID, characteristicUUID: Constants.heartRateCharacteristicUUID).flatMap { data -> Observable<Int?> in
                    if let data = data {
                        let str = data.hexEncodedString().dropFirst(2)
                        let rate = Int(Int8(bitPattern: UInt8(str, radix: 16) ?? 0))
                        return .just(rate != 0 ? rate : nil)
                    }
                    return .just(nil)
                }.asDriver(onErrorJustReturn: nil)
                    .drive(self.heartRate)
                    .disposed(by: self.disposeBag)
            } else {
                // try to connect again
            }
        })
    }
}
