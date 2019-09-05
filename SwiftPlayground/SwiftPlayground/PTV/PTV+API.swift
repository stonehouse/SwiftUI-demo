//
//  PTV.API.swift
//  SwiftPlayground
//
//  Created by alex on 6/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation

extension PTV {
    struct API {
        struct RouteTypes: Routable {
            typealias ResultType = PTV.Models.RouteTypes
            let component: String = "route_types"
        }
    }
}
