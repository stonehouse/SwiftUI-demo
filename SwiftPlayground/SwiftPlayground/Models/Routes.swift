//
//  Routes.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class Routes: EndpointLoader {
    typealias EndpointType = PTV.API.Routes
    typealias Model = PTV.Models.Route
    
    var endpoint: EndpointType
    var cancellables: [AnyCancellable] = []
    @Published var routes: [Model] = []

    init(routeTypes: [PTV.Models.RouteType]) {
        self.endpoint = EndpointType(routeTypes: routeTypes)
    }
    
    func receive(value: EndpointType.ResultType) {
        self.routes = value.routes
    }
}

