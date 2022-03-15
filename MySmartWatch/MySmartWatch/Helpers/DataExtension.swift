//
//  DataExtension.swift
//  MySmartWatch
//
//  Created by Elanur Yoktan on 8.03.2022.
//

import Foundation

extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
    
    func toInt(startIndex: Int, offset: Int) -> Int? {
        let str = self.hexEncodedString()
        let start = str.index(str.startIndex, offsetBy: startIndex)
        let end = str.index(start, offsetBy: offset)
        let range = start..<end
        let mySubstring = String(str[range])
        return Int(mySubstring, radix: 16)
    }
}
