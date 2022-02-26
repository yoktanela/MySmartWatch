//
//  RxCBCentralManagerDelegateProxy.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 26.02.2022.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa


extension CBCentralManager: HasDelegate {}

class RxCBCentralManagerDelegateProxy: DelegateProxy<CBCentralManager, CBCentralManagerDelegate>, DelegateProxyType, CBCentralManagerDelegate {

    weak public private(set) var centralManager: CBCentralManager?

    public init(centralManager: ParentObject) {
        self.centralManager = centralManager
        super.init(parentObject: centralManager,
               delegateProxy: RxCBCentralManagerDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        register { RxCBCentralManagerDelegateProxy(centralManager: $0) }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
}

public extension Reactive where Base: CBCentralManager {
    var delegate: DelegateProxy<CBCentralManager, CBCentralManagerDelegate> {
        RxCBCentralManagerDelegateProxy.proxy(for: base)
    }
    
    var didDiscoverPeripheral: Observable<Peripheral> {
        delegate.methodInvoked(#selector(CBCentralManagerDelegate
                                            .centralManager(_:didDiscover:advertisementData:rssi:)))
            .map { parameters in
                Peripheral(peripheral: parameters[1] as! CBPeripheral, advertisementData: parameters[2] as! [String:Any], rssi: parameters[3] as! NSNumber)
            }
    }
    
    var stateChanged: Observable<CBManagerState> {
        delegate.methodInvoked(#selector(CBCentralManagerDelegate.centralManagerDidUpdateState(_:)))
            .map { parameters in
                (parameters[0] as! CBCentralManager).state
            }
    }
}
