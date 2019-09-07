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
        struct RouteTypes: Routable {
            typealias ResultType = PTV.Models.RouteTypes
            let path = "route_types"
            let query = [String: String]()
        }
        struct Routes: Routable {
            typealias ResultType = PTV.Models.Routes
            let path: String
            let query: [String: String]
            
            init(routeTypes: [PTV.Models.RouteType]) {
                var query = [String: String]()
                query["route_types"] = routeTypes.map({ "\($0.routeType)" }).joined(separator: ",")
                self.query = query
                self.path = "routes"
            }
        }
        struct StopsOnRoute: Routable {
            typealias ResultType = PTV.Models.StopsOnRoute
            let path: String
            let query: [String: String] = [:]
            
            init(route: PTV.Models.Route) {
                path = "stops/route/\(route.routeId)/route_type/\(route.routeType)"
            }
        }
    }
}
