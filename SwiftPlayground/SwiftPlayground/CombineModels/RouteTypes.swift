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
    
    var cancellable: AnyCancellable?
    @Published var routeTypes: [Model] = []

    init() {
        resume()
    }
    
    func receive(value: PTV.Models.RouteTypes) {
        routeTypes = value.routeTypes
    }
}
