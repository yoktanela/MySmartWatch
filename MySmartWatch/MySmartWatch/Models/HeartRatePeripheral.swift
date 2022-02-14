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
    
    init(peripheral: CBPeripheral, advertisementData: [String: Any], rssi: NSNumber?) {
        self.peripheral = peripheral
        self.name = advertisementData["kCBAdvDataLocalName"] as? String
        self.connectable = advertisementData["kCBAdvDataIsConnectable"] as? Bool ?? false
        self.rssi = rssi
    }
    
    static func == (lhs: HeartRatePeripheral, rhs: HeartRatePeripheral) -> Bool {
        return lhs.peripheral == rhs.peripheral
    }
}
