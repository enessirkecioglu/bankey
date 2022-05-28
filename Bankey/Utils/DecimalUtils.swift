//
//  DecimalUtils.swift
//  Bankey
//
//  Created by Enes Sirkecioğlu on 29.05.2022.
//

import Foundation

extension Decimal {
    var doubleValue: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}
