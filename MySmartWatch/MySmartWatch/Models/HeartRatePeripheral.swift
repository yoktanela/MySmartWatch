//
//  HeartRatePeripheral.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 2.02.2022.
//

import Foundation
import CoreBluetooth

class HeartRatePeripheral: Equatable {
    
    var peripheral: CBPeripheral
    var name: String?
    var rssi: NSNumber?
    var connectable: Bool = false
    
    init(_ peripheral: Peripheral) {
        self.peripheral = peripheral.peripheral
        self.name = peripheral.advertisementData["kCBAdvDataLocalName"] as? String
        self.connectable = peripheral.advertisementData["kCBAdvDataIsConnectable"] as? Bool ?? false
        self.rssi = peripheral.rssi
    }
    
    static func == (lhs: HeartRatePeripheral, rhs: HeartRatePeripheral) -> Bool {
        return lhs.peripheral == rhs.peripheral
    }
}
