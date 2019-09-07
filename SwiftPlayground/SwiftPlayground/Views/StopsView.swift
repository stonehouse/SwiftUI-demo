//
//  StopsView.swift
//  SwiftPlayground
//
//  Created by Alexander Stonehouse on 7/9/19.
//  Copyright © 2019 alex. All rights reserved.
//

import SwiftUI

struct StopsOnRouteView: View {
    @ObservedObject var model: StopsOnRoute
    
    init(route: PTV.Models.Route) {
        self.model = StopsOnRoute(route: route)
    }
    
    var body: some View {
        List(model.stops) { stop in
            Text("\(stop.stopName)")
        }
    }
}
