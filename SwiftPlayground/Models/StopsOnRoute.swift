//
//  StopsOnRoute.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import Foundation

class StopsOnRoute: ViewModel {
    typealias Model = PTV.Models.Stop
    
    @Published var stops: [Model] = []
    private let route: PTV.Models.Route

    init(route: PTV.Models.Route) {
        self.route = route
    }
    
    @MainActor
    func bind() async {
        do {
            let stopsResult = try await ptv.request(endpoint: PTV.API.StopsOnRoute(route: route))
            self.stops = stopsResult.stops
        } catch _ {
            
        }
    }
}

