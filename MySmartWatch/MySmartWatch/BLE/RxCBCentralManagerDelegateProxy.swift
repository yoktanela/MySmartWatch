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
    let state = PublishSubject<CBManagerState>()
    
    public init(centralManager: ParentObject) {
        self.centralManager = centralManager
        super.init(parentObject: centralManager,
               delegateProxy: RxCBCentralManagerDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        register { RxCBCentralManagerDelegateProxy(centralManager: $0) }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        state.on(.next(central.state))
        self._forwardToDelegate?.centralManagerDidUpdateState?(central)
    }
}

public extension Reactive where Base: CBCentralManager {
    var delegate: DelegateProxy<CBCentralManager, CBCentralManagerDelegate> {
        RxCBCentralManagerDelegateProxy.proxy(for: base)
    }
    
    var didDiscoverPeripheral: Observable<Peripheral> {
        let selector = #selector(CBCentralManagerDelegate
                                    .centralManager(_:didDiscover:advertisementData:rssi:))
        return delegate.methodInvoked(selector)
            .compactMap { parameters -> Peripheral? in
                guard let peripheral = parameters[1] as? CBPeripheral,
                        let advertisementData = parameters[2] as? [String:Any],
                        let rssi = parameters[3] as? NSNumber else {
                    return nil
                }
                return Peripheral(peripheral: peripheral, advertisementData: advertisementData, rssi: rssi)
            }
    }
    
    var stateChanged: Observable<CBManagerState> {
        return RxCBCentralManagerDelegateProxy.proxy(for: base).state
    }
    
    var connectedPeripheral: Observable<CBPeripheral> {
        let selector = #selector(CBCentralManagerDelegate
                                    .centralManager(_:didConnect:))
        return delegate.methodInvoked(selector)
            .compactMap { parameters in
                return parameters[1] as? CBPeripheral
            }
    }
}
