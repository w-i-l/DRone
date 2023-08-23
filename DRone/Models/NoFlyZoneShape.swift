//
//  NoFlyZoneShape.swift
//  DRone
//
//  Created by Mihai Ocnaru on 23.08.2023.
//

import SwiftUI
import CoreLocation


enum NoFLyZoneGeometricType: String {
    case polygon = "polygon"
    case circle = "circle"
}

enum NoFlyZoneType: String, CaseIterable {
    case restricted = "restricted-zone"
    case firstZone = "first-zone"
    case requestZone = "request-zone"
    
    static func random() -> NoFlyZoneType {
        let randomInt = Int.random(in: 0...2)
        
        if randomInt % 3 == 0 {
            return .restricted
        } else if randomInt % 3 == 1 {
            return .firstZone
        } else {
            return .requestZone
        }
    }
    
    static func match(zoneType: String) -> NoFlyZoneType {
        for zone in NoFlyZoneType.allCases {
            if zone.rawValue == zoneType {
                return zone
            }
        }
        
        return .firstZone
    }
}

protocol NoFlyZoneShape {
    var geometrycType: NoFLyZoneGeometricType { get }
    var type: NoFlyZoneType { get }
}

struct NoFlyZoneCircle: NoFlyZoneShape {
    let geometrycType: NoFLyZoneGeometricType
    let type: NoFlyZoneType
    let center: CLLocationCoordinate2D
    let radius: CLLocationDistance
}

struct NoFlyZonePolygon: NoFlyZoneShape {
    let geometrycType: NoFLyZoneGeometricType
    let type: NoFlyZoneType
    let coordinates: [CLLocationCoordinate2D]
}
