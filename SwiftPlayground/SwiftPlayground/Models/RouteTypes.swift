//
//  RouteTypes.swift
//  SwiftPlayground
//
//  Created by alex on 6/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class RouteTypes: EndpointLoader {
    typealias EndpointType = PTV.API.RouteTypes
    typealias Model = PTV.Models.RouteType
    
    let endpoint = EndpointType()
    var cancellable: AnyCancellable?
    @Published var routeTypes: [Model] = []
    
    func receive(value: EndpointType.ResultType) {
        self.routeTypes = value.routeTypes
    }
}
