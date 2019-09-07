//
//  Routes.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine

class Routes: RouteLoader {
    typealias Route = PTV.API.Routes
    typealias Model = PTV.Models.Route
    
    var loading = false
    var cancellable: AnyCancellable?
    @Published var routes: [Model] = []

    init(routeTypes: [PTV.Models.RouteType]) {
        resume(Route(routeTypes: routeTypes))
    }
    
    func receive(value: Route.ResultType) {
        routes = value.routes
    }
}

