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
}
