//
//  StringExtension.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 8.03.2022.
//

import Foundation

extension String {
    func isEqual(to str: String) -> Bool {
        return self.caseInsensitiveCompare(str) == ComparisonResult.orderedSame
    }
    
    func toData() -> Data {
        var hex = self
        var data = Data()
        while(hex.count > 0) {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
}
