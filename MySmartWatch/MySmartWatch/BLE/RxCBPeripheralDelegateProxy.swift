//
//  RxCBPeripheralDelegateProxy.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 5.03.2022.
//

import Foundation
import CoreBluetooth
import RxSwift
import RxCocoa

extension CBPeripheral: HasDelegate {}

class RxCBPeripheralDelegateProxy: DelegateProxy<CBPeripheral, CBPeripheralDelegate>, DelegateProxyType, CBPeripheralDelegate {

    weak public private(set) var peripheral: CBPeripheral?

    public init(peripheral: ParentObject) {
        self.peripheral = peripheral
        super.init(parentObject: peripheral,
               delegateProxy: RxCBPeripheralDelegateProxy.self)
    }

    static func registerKnownImplementations() {
        register { RxCBPeripheralDelegateProxy(peripheral: $0) }
    }
}

public extension Reactive where Base: CBPeripheral {
    var delegate: DelegateProxy<CBPeripheral, CBPeripheralDelegate> {
        RxCBPeripheralDelegateProxy.proxy(for: base)
    }
    
    var didDiscoverServices: Observable<[CBService]> {
        delegate.methodInvoked(#selector(CBPeripheralDelegate
                                            .peripheral(_:didDiscoverServices:)))
            .compactMap { parameters -> [CBService]? in
                return (parameters[0] as? CBPeripheral)?.services
            }
    }
    
    var didDiscoverCharacteristics: Observable<[CBCharacteristic]> {
        return delegate.methodInvoked(#selector(CBPeripheralDelegate
                                            .peripheral(_:didDiscoverCharacteristicsFor:error:)))
            .compactMap{ parameters -> [CBCharacteristic]? in
                return (parameters[1] as? CBService)?.characteristics
            }
    }
    
    var didDiscoverDescriptors: Observable<[CBDescriptor]> {
        return delegate.methodInvoked(#selector(CBPeripheralDelegate
                                            .peripheral(_:didDiscoverDescriptorsFor:error:)))
            .compactMap { parameters -> [CBDescriptor]? in
                return (parameters[1] as? CBCharacteristic)?.descriptors
            }
    }
    
    var didNotify: Observable<CBCharacteristic> {
        delegate.methodInvoked(#selector(CBPeripheralDelegate
                                            .peripheral(_:didUpdateNotificationStateFor:error:)))
            .compactMap { parameters in
                return parameters[1] as? CBCharacteristic
            }
    }
    
    var didUpdateValue: Observable<CBCharacteristic> {
        delegate.methodInvoked(#selector(CBPeripheralDelegate
                                            .peripheral(_:didUpdateValueFor:error:) as ((CBPeripheralDelegate) -> ((CBPeripheral, CBCharacteristic, Error?) -> Void))?))
            .compactMap { paremeters in
                return paremeters[1] as? CBCharacteristic
            }
    }
    
    var didWriteValue: Observable<CBCharacteristic> {
        delegate.methodInvoked(#selector(CBPeripheralDelegate
                                            .peripheral(_:didWriteValueFor:error:) as ((CBPeripheralDelegate) -> ((CBPeripheral, CBCharacteristic, Error?) -> Void))?))
            .compactMap { parameters in
                return parameters[1] as? CBCharacteristic
            }
    }
}
