//
//  BehaviorRelayExtension.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 2.02.2022.
//

import Foundation
import RxSwift
import RxCocoa

extension BehaviorRelay where Element: RangeReplaceableCollection, Element.Element: Equatable {

    func add(element: Element.Element) {
        var array = self.value
        if let firstIndex = array.firstIndex(where: {$0 == element}) {
            array.remove(at: firstIndex)
            array.append(element)
        } else {
            array.append(element)
        }
        self.accept(array)
    }
    
    func remove(element: Element.Element) {
        var array = self.value
        if let firstIndex = array.firstIndex(where: {$0 == element}) {
            array.remove(at: firstIndex)
        }
        self.accept(array)
    }
}
