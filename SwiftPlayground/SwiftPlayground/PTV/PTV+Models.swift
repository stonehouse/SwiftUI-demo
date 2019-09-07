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
        struct RouteTypes: RootResultType {
            let routeTypes: [RouteType]
            
            init() {
                routeTypes = []
            }
            
            init(routeTypes: [RouteType]) {
                self.routeTypes = routeTypes
            }
        }
        
        struct RouteType: Codable, Identifiable {
            typealias ID = Int
            var id: ID {
               routeType
            }
            let routeTypeName: String
            let routeType: Int
        }
        
        struct Routes: RootResultType {
            let routes: [Route]
            
            init() {
                self.routes = []
            }
            
            init(routes: [Route]) {
                self.routes = routes
            }
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
        
        struct StopsOnRoute: RootResultType {
            let stops: [Stop]
            
            init() {
                self.stops = []
            }
            
            init(stops: [Stop]) {
                self.stops = stops
            }
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

        struct Departures: RootResultType {
            let departures: [Departure]
            
            init() {
                self.departures = []
            }
            
            init(departures: [Departure]) {
                self.departures = departures
            }
        }
        
        struct Departure: Codable, Identifiable {
            typealias ID = String
            var id: ID {
                scheduledDepartureUtc
            }
            let stopId: Int
            let routeId: Int
            let runId: Int
            let directionId: Int
            let disruptionIds: [Int]
            let scheduledDepartureUtc: String
            let estimatedDepartureUtc: String?
            let atPlatform: Bool
            let platformNumber: String
            let flags: String
            let departureSequence: Int
        }
    }
}
