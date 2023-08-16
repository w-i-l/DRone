//
//  Floats.swift
//  DRone
//
//  Created by Mihai Ocnaru on 16.08.2023.
//

import Foundation

public extension Double {
    func roundToOneDecimal() -> String {
        String(format: "%.1f", self)
    }
}

