//
//  Strings.swift
//  DRone
//
//  Created by Mihai Ocnaru on 09.08.2023.
//

import Foundation

extension String {
    func limitLettersFormattedString(limit: Int) -> String {
        if limit >= 3 {
            return String(self.prefix(limit - 3)) + (self.count <= limit - 3 ? "" : "...")
        } else {
            return "..."
        }
    }
}
