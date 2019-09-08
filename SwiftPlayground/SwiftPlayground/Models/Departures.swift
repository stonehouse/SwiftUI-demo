//
//  Departures.swift
//  SwiftPlayground
//
//  Created by alex on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine


class Departures: EndpointLoader {
    typealias EndpointType = PTV.API.DeparturesAtStop
    typealias Model = PTV.Models.Departure
    
    var endpoint: EndpointType
    var cancellables: [AnyCancellable] = []
    let stop: PTV.Models.Stop
    let route: PTV.Models.Route
    let directions: [PTV.Models.Direction]
    @Published var departures: [Model] = []

    init(stop: PTV.Models.Stop, route: PTV.Models.Route, directions: [PTV.Models.Direction]) {
        self.stop = stop
        self.route = route
        self.directions = directions
        self.endpoint = EndpointType(stop: stop, route: route)
    }
    
    func receive(value: EndpointType.ResultType) {
        self.departures = value.departures.sorted(by: { $0.id < $1.id })
    }
}

