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
    var connected = BehaviorRelay<Bool>(value: false)
    private var disposeBag = DisposeBag()

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
                // read and notify values
            } else {
                // try to connect again
            }
        })
    }
}
