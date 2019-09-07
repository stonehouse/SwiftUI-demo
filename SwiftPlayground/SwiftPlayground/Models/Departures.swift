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
    var cancellable: AnyCancellable?
    @Published var departures: [Model] = []

    init(stop: PTV.Models.Stop, route: PTV.Models.Route) {
        self.endpoint = EndpointType(stop: stop, route: route)
    }
    
    func receive(value: EndpointType.ResultType) {
        self.departures = value.departures
    }
}

