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
    var heartRate = BehaviorRelay<Int>(value: 0)
    var minHeartRate = BehaviorRelay<Int>(value: 0)
    var maxHeartRate = BehaviorRelay<Int>(value: 0)
    var averageHeartRate = BehaviorRelay<Int>(value: 0)
    
    init(bluetoothService: BluetoothService, peripheral: CBPeripheral) {
        super.init()
        self.bluetoothService = bluetoothService
        self.peripheral = peripheral
        
        self.bindVariables()
    }
    
    func bindVariables() {
        
        // Calculate min
        heartRate.filter {$0 != 0}
            .flatMap{ rate -> Observable<Int> in
                let min = self.minHeartRate.value
                if min == 0 {
                    return .just(rate)
                }
                return rate < min ? .just(rate) : .just(min)
            }.asDriver(onErrorJustReturn: 0)
            .drive(minHeartRate)
            .disposed(by: disposeBag)
        
        // Calculate max
        heartRate.flatMap{ rate -> Observable<Int> in
            let max = self.maxHeartRate.value
                if max == 0 {
                    return .just(rate)
                }
                return rate > max ? .just(rate) : .just(max)
            }.asDriver(onErrorJustReturn: 0)
            .drive(maxHeartRate)
            .disposed(by: disposeBag)

        // Calculate average heart rate
        let countObs = heartRate.filter {$0 != 0}
            .scan(0) {a, b in
                return a + 1
            }.asObservable()
        
        let sumObs = heartRate.filter {$0 != 0}
            .scan(0) { prev, value in
                return prev + value
            }.asObservable()
        
        Observable.zip(sumObs, countObs) { sum, count in
            let result = Float(sum)/Float(count)
            return Int(round(result))
        }.asDriver(onErrorJustReturn: 0)
            .drive(averageHeartRate)
            .disposed(by: disposeBag)
        
        bluetoothService.connect(to: peripheral)
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
            .drive(connected)
            .disposed(by: disposeBag)
        
        connected.subscribe(onNext: { value in
            if (value) {
                // Notify for primary service
                self.bluetoothService.setNotify(for: self.peripheral, serviceUUID: Constants.primaryServiceUUID, characteristicUUID: Constants.primaryCharacteristicUUID)
                // Notify for heart rate service
                self.bluetoothService.setNotify(for: self.peripheral, serviceUUID: Constants.heartRatePeripheralServiceUUID, characteristicUUID: Constants.heartRateCharacteristicUUID).flatMap { data -> Observable<Int> in
                    if let data = data {
                        let str = data.hexEncodedString().dropFirst(2)
                        let rate = Int(Int8(bitPattern: UInt8(str, radix: 16) ?? 0))
                        return .just(rate != 0 ? rate : 0)
                    }
                    return .just(0)
                }.asDriver(onErrorJustReturn: 0)
                    .drive(self.heartRate)
                    .disposed(by: self.disposeBag)
            } else {
                // try to connect again
            }
        })
    }
}
