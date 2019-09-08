//
//  StopsOnRoute.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine

class StopsOnRoute: EndpointLoader {
    typealias EndpointType = PTV.API.StopsOnRoute
    typealias Model = PTV.Models.Stop
    
    var endpoint: EndpointType
    var cancellables: [AnyCancellable] = []
    @Published var stops: [Model] = []
    @Published var directions: [PTV.Models.Direction] = []
    let route: PTV.Models.Route

    init(route: PTV.Models.Route) {
        self.route = route
        self.endpoint = EndpointType(route: route)
        load(PTV.API.Directions(route: route)) { value in
            self.directions = value.directions
        }
    }
    
    func receive(value: EndpointType.ResultType) {
        self.stops = value.stops
    }
}

