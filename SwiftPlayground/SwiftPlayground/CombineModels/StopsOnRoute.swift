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
    var cancellable: AnyCancellable?
    @Published var stops: [Model] = []

    init(route: PTV.Models.Route) {
        self.endpoint = EndpointType(route: route)
    }
    
    func receive(value: EndpointType.ResultType) {
        self.stops = value.stops
    }
}

