//
//  PTV.API.swift
//  SwiftPlayground
//
//  Created by alex on 6/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation

extension PTV {
    struct API {
        static let baseURL = "https://timetableapi.ptv.vic.gov.au"
        static let apiVersion = "3"
        
        struct RouteTypes: Endpoint {
            typealias ResultType = PTV.Models.RouteTypes
            let cache = true
            let path = "route_types"
            let query = [String: String]()
        }
        
        struct Routes: Endpoint {
            typealias ResultType = PTV.Models.Routes
            let cache = true
            let path: String
            let query: [String: String]
            
            init(routeTypes: [PTV.Models.RouteType]) {
                var query = [String: String]()
                query["route_types"] = routeTypes.map({ "\($0.routeType)" }).joined(separator: ",")
                self.query = query
                self.path = "routes"
            }
        }
        
        struct StopsOnRoute: Endpoint {
            typealias ResultType = PTV.Models.Stops
            let cache = true
            let path: String
            let query: [String: String] = [:]
            
            init(route: PTV.Models.Route) {
                path = "stops/route/\(route.routeId)/route_type/\(route.routeType)"
            }
        }
        
        struct Stops: Endpoint {
            typealias ResultType = PTV.Models.Stops
            let cache = true
            let path: String
            let query: [String: String] = [:]
            
            init(latitude: Double, longitude: Double) {
                path = "stops/location/\(latitude),\(longitude)"
            }
        }
        
        struct DeparturesAtStop: Endpoint {
            typealias ResultType = PTV.Models.Departures
            let cache = false
            let path: String
            let query: [String: String] = [:]
            
            init(stop: PTV.Models.Stop) {
                path = "departures/route_type/\(stop.routeType)/stop/\(stop.stopId)"
            }
            
            init(stop: PTV.Models.Stop, route: PTV.Models.Route) {
                path = "departures/route_type/\(stop.routeType)/stop/\(stop.stopId)/route/\(route.routeId)"
            }
        }
        
        struct Directions: Endpoint {
            typealias ResultType = PTV.Models.Directions
            let cache = true
            let path: String
            let query: [String: String] = [:]
            
            init(route: PTV.Models.Route) {
                path = "directions/route/\(route.routeId)"
            }
        }
        
        struct Search: Endpoint {
            typealias ResultType = PTV.Models.Search
            let cache = false
            let path: String
            let query: [String: String] = [:]
            
            init(searchTerm: String) {
                path = "search/\(searchTerm)"
            }
        }
    }
}
