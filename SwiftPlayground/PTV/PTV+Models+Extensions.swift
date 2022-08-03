//
//  PTV+Models+Extensions.swift
//  SwiftPlayground
//
//  Created by Alex Stonehouse on 3/8/2022.
//  Copyright © 2022 alex. All rights reserved.
//

import Foundation

enum TransportTypes: Identifiable {
    case train, tram, bus, vline, nightbus
    
    var id: Int {
        switch self {
        case .train:
            return 0
        case .tram:
            return 1
        case .bus:
            return 2
        case .vline:
            return 3
        case .nightbus:
            return 4
        }
    }
    
    static func from(id: Int) -> TransportTypes {
        switch id {
        case 0:
            return .train
        case 1:
            return .tram
        case 2:
            return .bus
        case 3:
            return .vline
        default:
            return .nightbus
        }
    }
}

extension PTV.Models.RouteTypes {
    var types: [TransportTypes] {
        routeTypes.map { TransportTypes.from(id: $0.id) }
    }
}

extension PTV.Models.RouteType {
    var type: TransportTypes {
        TransportTypes.from(id: id)
    }
}

extension PTV.Models.Route {
    var type: TransportTypes {
        TransportTypes.from(id: routeType)
    }
}

