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

class Routes: ViewModel {
    typealias Model = PTV.Models.Route
    
    private let endpoint: PTV.API.Routes
    @Published var routes: [Model] = []

    init(routeTypes: [PTV.Models.RouteType]) {
        self.endpoint = PTV.API.Routes(routeTypes: routeTypes)
    }
    
    @MainActor
    func bind() async {
        do {
            let result = try await ptv.request(endpoint: endpoint)
            self.routes = result.routes
        } catch _ {
            
        }
    }
}

