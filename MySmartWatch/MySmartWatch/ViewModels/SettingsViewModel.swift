//
//  SettingsViewModel.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 18.03.2022.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa

class SettingsViewModel: NSObject {
    
    private var bluetoothService:BluetoothService!
    private var peripheral: CBPeripheral!
    private var disposeBag = DisposeBag()

    var connected = BehaviorRelay<Bool>(value: false)
    var battery = BehaviorRelay<Int?>(value: nil)
    var alarms = BehaviorRelay<[Alarm]>(value: [])
    var maxAlarmCount = 5
    
    init(bluetoothService: BluetoothService, peripheral: CBPeripheral) {
        super.init()
        self.bluetoothService = bluetoothService
        self.peripheral = peripheral
        
        self.bindVariables()
    }
    
    func bindVariables() {
        
        bluetoothService.connect(to: peripheral)
            .observe(on: MainScheduler.instance)
            .asDriver(onErrorJustReturn: false)
            .drive(connected)
            .disposed(by: disposeBag)
        
        connected.subscribe(onNext: { value in
            if (value) {
                // Notify to get battery info
                let dataObs = self.bluetoothService.setNotify(for: self.peripheral, serviceUUID: Constants.primaryServiceUUID, characteristicUUID: Constants.stepCountCharacteristicUUID).compactMap{$0}
                let deviceInfo = dataObs
                    .filter {String($0.hexEncodedString().prefix(2)).isEqual(to: "00")}
                deviceInfo.flatMap { data -> Observable<Int?> in
                    return .just(data.toInt(startIndex: 34, offset: 4))
                }.asDriver(onErrorJustReturn: nil)
                    .drive(self.battery)
                    .disposed(by: self.disposeBag)
            } else {
                //
            }
        })
        
        // alarms
        self.alarms
            .skip(1)
            .subscribe(onNext: { alarms in
                var str = "BE0109FE"
                let count = pow(2.0, alarms.count)-1
                str += String(format:"%02X", NSDecimalNumber(decimal: count).intValue)
                alarms.forEach { alarm in
                    var repeats = 0
                    alarm.repeatDays.forEach({ repeats += $0.rawValue})
                    str += String(format:"%02X", alarm.hour)
                    str += String(format:"%02X", alarm.minute)
                    str += String(format:"%02X", repeats)
                }
                self.bluetoothService.writeValue(for: self.peripheral,
                                                    serviceUUID: Constants.primaryServiceUUID,
                                                    characteristicUUID: Constants.primaryCharacteristicUUID,
                                                    data: str.toData())
            }).disposed(by: disposeBag)
    }
    
    func getDeviceName() -> String? {
        return peripheral.name
    }
    
    func vibrateDevice() {
        self.bluetoothService.writeValue(for: self.peripheral, serviceUUID: Constants.primaryServiceUUID, characteristicUUID: Constants.primaryCharacteristicUUID, data: "BE060FED".toData())
    }
    
    func addAlarm(hour: Int, minute: Int, repeatDays: [Day]) {
        let alarm = Alarm(hour: hour, minute: minute, repeatDays: repeatDays)
        self.alarms.add(element: alarm)
    }
}
