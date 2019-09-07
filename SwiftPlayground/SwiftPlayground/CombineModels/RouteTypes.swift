//
//  RouteTypes.swift
//  SwiftPlayground
//
//  Created by alex on 6/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine

class RouteTypes: RouteLoader {
    typealias Route = PTV.API.RouteTypes
    typealias Model = PTV.Models.RouteType
    
    var loading = false
    var cancellable: AnyCancellable?
    @Published var routeTypes: [Model] = []

    init() {
        resume(Route())
    }
    
    func receive(value: Route.ResultType) {
        routeTypes = value.routeTypes
    }
}
