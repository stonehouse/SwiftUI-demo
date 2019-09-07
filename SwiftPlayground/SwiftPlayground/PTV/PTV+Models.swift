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
            var id: ID {
               routeType
            }
            let routeTypeName: String
            let routeType: Int
        }
        
        struct Routes: Codable {
            let routes: [Route]
        }
        
        struct Route: Codable, Identifiable {
            typealias ID = Int
            var id: ID {
                routeId
            }
            let routeServiceStatus: RouteServiceStatus
            let routeType: Int
            let routeId: Int
            let routeName: String
            let routeNumber: String
            let routeGtfsId: String
        }
        
        struct RouteServiceStatus: Codable {
            let description: String
            let timestamp: String
        }
        
        struct StopsOnRoute: Codable {
            let stops: [Stop]
        }
        
        struct Stop: Codable, Identifiable {
            typealias ID = Int
            var id: ID {
                stopId
            }
            let disruptionIds: [Int]
            let stopSuburb: String
            let stopName: String
            let stopId: Int
            let routeType: Int
            let stopLatitude: Double
            let stopLongitude: Double
            let stopSequence: Int
        }
    }
}
