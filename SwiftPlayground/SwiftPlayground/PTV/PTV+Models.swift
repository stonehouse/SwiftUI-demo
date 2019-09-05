//
//  PTV+Models.swift
//  SwiftPlayground
//
//  Created by alex on 6/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation

extension PTV {
    struct Models {
        struct RouteTypes: Codable {
            let routeTypes: [RouteType]
        }
        
        struct RouteType: Codable, Identifiable {
            typealias ID = Int
            let routeTypeName: String
            let routeType: Int
            var id: ID {
               routeType
           }
        }
    }
}
