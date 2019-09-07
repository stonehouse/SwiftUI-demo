//
//  StopsOnRoute.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine

class StopsOnRoute: RouteLoader {
    typealias Route = PTV.API.StopsOnRoute
    typealias Model = PTV.Models.Stop
    
    var loading = false
    var cancellable: AnyCancellable?
    @Published var stops: [Model] = []

    init(route: PTV.Models.Route) {
        resume(Route(route: route))
    }
    
    func receive(value: Route.ResultType) {
        stops = value.stops
    }
}

