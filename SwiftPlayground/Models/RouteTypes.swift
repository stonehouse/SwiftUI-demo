//
//  RouteTypes.swift
//  SwiftPlayground
//
//  Created by alex on 6/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

class RouteTypes: ViewModel {
    typealias Model = PTV.Models.RouteType

    @Published var routeTypes: [Model] = []
    
    @MainActor
    func bind() async {
        do {
            let value = try await ptv.request(endpoint: PTV.API.RouteTypes())
            self.routeTypes = value.routeTypes
        } catch _ {
            
        }
    }
}
